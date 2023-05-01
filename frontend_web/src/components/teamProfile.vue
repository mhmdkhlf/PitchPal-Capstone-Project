<template>
  <loader v-if="isLoading" />
  <confirmPopup :Message="confirmationMessage" v-if="confirmationMessage" />
  <div class="all" v-if="!isLoading" :class="{ hidden: confirmationMessage }">
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
      <div class="group buttons" v-if="isSelfVisit">
        <button @click="deleteTeam()" id="delete-btn">Delete The Team</button>
        <button @click="editTeam()">Edit Team</button>
      </div>
      <div class="group buttons" v-else>
        <button @click="rateTeam()">Rate</button>
      </div>
    </div>
    <div class="butons"></div>
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
import confirmPopup from "./confirmationPopup.vue";
export default {
  name: "teamView",
  components: {
    loader,
    playerCard,
    confirmPopup,
  },
  mounted() {
    console.log("in");
  },
  async created() {
    this.$store.dispatch("setLoading");
    let res = await helpers.isTeamAuthenticated(this.$route.params.name);
    console.log(res);

    if (this.isSelfVisit) {
      if (!res) {
        this.$router.push("/login");
        this.$store.dispatch("stopLoading");
      }
    }
    axios
      .get(helpers.api + "getTeamByName/" + this.$route.params.name)
      .then((res) => {
        this.teamInfo = res.data;
        Promise.all(
          this.teamInfo.playerIds.map((id) => {
            axios
              .get("http://localhost:5000/api/getPlayer/" + id)
              .then((res) => {
                axios
                  .get(
                    "http://localhost:5000/api/getProfilePictureByEmail/" +
                      res.data.email
                  )
                  .then((res2) => {
                    if (res2.data) {
                      res.data["src"] = `data:${
                        res2.data.img.contentType
                      };base64,${Buffer.from(
                        res2.data.img.data,
                        "utf-8"
                      ).toString("base64")}`;
                      this.players.push(res.data);
                    } else {
                      this.players.push(res.data);
                    }
                  });
              });
          })
        );
        this.$store.dispatch("stopLoading");
      });
  },
  data() {
    return {
      teamInfo: null,
      isSelfVisit: this.$route.params.captainVisit === "true" ? true : false,
      players: [],
      isConfirmed: false,
      confirmationMessage: null,
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
  grid-template-columns: repeat(2, 1fr);
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
