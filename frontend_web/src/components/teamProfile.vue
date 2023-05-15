<template>
  <loader v-if="isLoading" />
  <confirmPopup :Message="confirmationMessage" v-if="confirmationMessage" />
  <rate
    v-if="rate"
    :for="`team`"
    :ratingOne="rateOne"
    :ratingTwo="rateTwo"
    :text="reviewText"
    @done="getRateData"
  />
  <div
    class="all"
    v-if="!isLoading && !rate"
    :class="{ hidden: confirmationMessage || rate }"
  >
    <div class="info">
      <div class="group">
        <label for="name">Team Name</label>
        <input type="text" id="name" :value="teamInfo.name" disabled />
      </div>
      <div class="group">
        <label for="rate-two">averageMoralRating </label>
        <input
          type="text"
          id="rate-two"
          :value="teamInfo.averageMoralRating"
          disabled
        />
      </div>

      <div class="group">
        <label for="rate-one">Average Skill rating</label>
        <input
          type="text"
          id="rate-one"
          :value="teamInfo.averageSkillRating"
          disabled
        />
      </div>
      <div class="group reviews-comments">
        <label>Team Reviews</label>

        <viewReviews :reviews="reviews" />
      </div>
      <div class="group buttons" v-if="isSelfVisit">
        <button @click="deleteTeam()" id="delete-btn">Delete The Team</button>
        <button @click="editTeam()">Edit Team</button>
      </div>
      <div class="group buttons" v-else>
        <button @click="rateTeam()">Rate</button>
      </div>
    </div>

    <div class="cards">
      <div class="players-cards">
        <playerCard
          v-for="(player, index) in players"
          :player-info="player"
          :key="index"
        />
      </div>
    </div>
  </div>
</template>
<script>
import axios from "axios";
const helpers = require("../../helpers/authentication.js");
import loader from "./loader.vue";
import playerCard from "./playerCard.vue";
import { Buffer } from "buffer";
import rate from "./ratingPopup.vue";
import viewReviews from "./viewReviews.vue";
import confirmPopup from "./confirmationPopup.vue";
export default {
  name: "teamView",
  components: {
    loader,
    playerCard,
    confirmPopup,
    rate,
    viewReviews,
  },
  async created() {
    this.$store.dispatch("setLoading");
    let res = await helpers.isTeamAuthenticated(this.$route.params.name);

    if (this.isSelfVisit) {
      if (!res) {
        this.$router.push("/logIn");
        sessionStorage.clear();
        this.$store.dispatch("stopLoading");
      }
    }
    let teamI = await axios.get(
      helpers.api + "getTeamByName/" + this.$route.params.name
    );

    this.teamInfo = teamI.data;
    await Promise.all(
      this.teamInfo.playerIds.map(async (id) => {
        let playerI = await axios.get(
          "http://localhost:5000/api/getPlayer/" + id
        );

        let img = await axios.get(
          "http://localhost:5000/api/getProfilePictureByEmail/" +
            playerI.data.email
        );

        if (img.data) {
          playerI.data["src"] = `data:${
            img.data.img.contentType
          };base64,${Buffer.from(img.data.img.data, "utf-8").toString(
            "base64"
          )}`;
          this.players.push(playerI.data);
        } else {
          this.players.push(playerI.data);
        }
      })
    );
    if (!this.isSelfVisit) {
      let review = await axios.post(
        helpers.api + "getTeamReviewByTeamNameAndReviewerID",
        {
          teamName: this.$route.params.name,
          reviewerID: this.$store.state.playerInfo.playerID,
        }
      );
      if (review.data) {
        this.rateOne = review.data.skillLevel.value;
        this.rateTwo = review.data.moralityScore.value;
        this.reviewText = review.data.reviewText;
        this.rateId = review.data._id;
        this.firstRate = false;
      }
    }
    let reviews = await axios.get(
      helpers.api + "getATeamReviews/" + this.$route.params.name
    );

    this.reviews = reviews.data.map((review) => {
      return {
        description: review.reviewText,
        date: review.submissionDate.substring(0, 10),
      };
    });

    this.$store.dispatch("stopLoading");
  },
  data() {
    return {
      teamInfo: null,
      isSelfVisit: this.$route.params.captainVisit === "true" ? true : false,
      players: [],
      isConfirmed: false,
      confirmationMessage: null,
      rate: false,
      rateData: null,
      rateOne: 0,
      rateTwo: 0,
      reviewText: "",
      firstRate: true,
      rateId: "",
      reviews: null,
    };
  },
  watch: {
    // whenever question changes, this function will run
    isConfirmed(newA) {
      if (newA) {
        this.remover();
      }
    },
  },
  methods: {
    rateTeam() {
      this.rate = true;
    },
    async getRateData(done) {
      this.$store.dispatch("setLoading");
      this.rateData = done;
      let date = new Date();
      if (this.firstRate) {
        await axios.post(helpers.api + "newTeamReview", {
          teamName: this.$route.params.name,
          reviewerID: this.$store.state.playerInfo.playerID,
          moralityScore: {
            value: this.rateData.newRateTwo,
          },
          skillLevel: {
            value: this.rateData.newRateOne,
          },
          reviewText: this.rateData.text,
          submissionDate: date.toJSON(),
        });
        await axios.patch(
          helpers.api + "updateTeamAverageRatingInCaseOfNewReview",
          {
            teamName: this.$route.params.name,
            newReviewSkillValue: this.rateData.newRateOne,
            newReviewMoralValue: this.rateData.newRateTwo,
          }
        );
      } else {
        await axios.patch(helpers.api + "updateTeamReview/" + this.rateId, {
          moralityScore: { value: this.rateData.newRateTwo },
          skillLevel: { value: this.rateData.newRateOne },
          reviewText: this.rateData.text,
          submissionDate: date.toJSON(),
        });
        await axios.patch(
          helpers.api + "updateTeamAverageRatingInCaseOfNewEdit",
          {
            teamName: this.$route.params.name,
            oldSkillReviewValue: this.rateOne,
            oldMoralReviewValue: this.rateTwo,
            newSkillReviewValue: this.rateData.newRateOne,
            newMoralReviewValue: this.rateData.newRateTwo,
          }
        );
      }
      let teamI = await axios.get(
        helpers.api + "getTeamByName/" + this.$route.params.name
      );

      this.teamInfo = teamI.data;
      let review = await axios.post(
        helpers.api + "getTeamReviewByTeamNameAndReviewerID",
        {
          teamName: this.$route.params.name,
          reviewerID: this.$store.state.playerInfo.playerID,
        }
      );
      if (review.data) {
        this.rateOne = review.data.skillLevel.value;
        this.rateTwo = review.data.moralityScore.value;
        this.reviewText = review.data.reviewText;
        this.rateId = review.data._id;
        this.firstRate = false;
      }

      let reviews = await axios.get(
        helpers.api + "getATeamReviews/" + this.$route.params.name
      );

      this.reviews = reviews.data.map((review) => {
        return {
          description: review.reviewText,
          date: review.submissionDate.substring(0, 10),
        };
      });

      this.rate = false;

      // this.$router.push(this.$router.currentRoute);
      this.$store.dispatch("stopLoading");
    },
    deleteTeam() {
      this.confirmationMessage = "Are you sure to delete this team?";
    },
    editTeam() {
      this.$router.push({
        path: "/team-update-form",
        query: {
          info: JSON.stringify({
            teamInfo: this.teamInfo,
          }),
        },
      });
    },
    async remover() {
      this.$store.dispatch("setLoading");
      if (this.isConfirmed) {
        await axios.delete(
          "http://localhost:5000/api/deleteTeam/" + this.teamInfo.name
        );
      }
      this.$store.dispatch("stopLoading");
    },
  },
  computed: {
    isLoading() {
      return this.$store.state.isLoading;
    },
  },
};
</script>
<style lang="scss" scoped>
.hidden {
  opacity: 0.07;
}
.all {
  margin: 5px;
  .info {
    border: 2px solid green;
    margin-bottom: 7px;
    border-radius: 7px;
  }
  .cards {
    border: 2px solid green;
    border-radius: 7px;
  }
  color: green !important;
}
.buttons {
  display: flex;
  justify-content: space-evenly;
}
button {
  border-color: green;
  padding: 5px;
  color: green;
}
#delete-btn {
  border-color: red;
  color: red;
}
.group {
  padding: 20px;
  border: 1px solid #ccc;
  border-radius: 5px;
  margin: 20px;
  box-sizing: border-box;
}
.players-cards {
  // display: flex;
  // flex-wrap: wrap;
  // padding: 4px;
  // margin: 0 auto;
  // max-width: 1000px;
  display: grid;
  gap: 5px;
  grid-template-columns: repeat(3, 1fr);
  @media (max-width: 768px) {
    grid-template-columns: repeat(1, 1fr);
  }
  // grid-template-columns: repeat(auto-fill, minmax(225px, 1fr));
}

input {
  color: green;
  width: 100%;
  border: 0;
}
</style>
