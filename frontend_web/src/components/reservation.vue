<template>
  <loader v-if="isLoading" />
  <confirmPopup :Message="confirmationMessage" v-if="confirmationMessage" />
  <div class="all" v-if="!isLoading" :class="{ hidden: confirmationMessage }">
    <div class="reservation-view">
      <div class="reservation-info">
        <div class="info-row">
          <span class="label">Sport Center:</span>
          <span class="value"
            ><a @click="goToSportCenter()" class="sport-center">{{
              reservationInfo.sportCenterName
            }}</a></span
          >
        </div>
        <div class="info-row">
          <span class="label">Reserver Email:</span>
          <span class="value">{{ reservationInfo.reserverEmail }}</span>
        </div>
        <div class="info-row">
          <span class="label">Field Number:</span>
          <span class="value">{{ reservationInfo.fieldNumber }}</span>
        </div>
        <div class="info-row">
          <span class="label">Time</span>
          <span class="value">{{ time }}</span>
        </div>
        <div class="info-row">
          <span class="label">Reservation Date:</span>
          <span class="value">{{
            reservationInfo.reservationDate.substring(0, 10)
          }}</span>
        </div>
        <div class="info-row">
          <span class="label">Reservation Type:</span>
          <span class="value">{{ reservationInfo.reserverType }}</span>
        </div>
        <div class="info-row">
          <span class="label">Comments:</span>
          <span class="value">{{
            reservationInfo.comment ? reservationInfo.comment : "No comments"
          }}</span>
        </div>
      </div>

      <div class="team-players">
        <div class="team">
          <h3>Team 1</h3>
          <ul>
            <li v-for="player in TeamOne" :key="player.id">
              <playerRow
                :userName="player.name"
                :user-id="player.id"
                :imageSrc="player.src"
                :isCaptain="true"
              />
            </li>
          </ul>
          <button
            class="button"
            @click="includeMeInTeam(1)"
            v-if="!isOwner && !isIncluded"
          >
            Include Me in the Team
          </button>
        </div>
        <div class="team">
          <h3>Team 2</h3>
          <ul>
            <li v-for="player in TeamTwo" :key="player.id">
              <playerRow
                :userName="player.name"
                :user-id="player.id"
                :imageSrc="player.src"
                :isCaptain="true"
              />
            </li>
          </ul>
          <button
            class="button"
            @click="includeMeInTeam(2)"
            v-if="!isOwner && !isIncluded"
          >
            Include Me in the Team
          </button>
        </div>
      </div>

      <div class="button-div" v-if="isOwner">
        <button @click="deleteT()" class="button">
          Cancel This Reservation
        </button>
      </div>
    </div>
  </div>
</template>
<script>
import axios from "axios";
import { Buffer } from "buffer";
const helpers = require("../../helpers/authentication.js");
import loader from "./loader.vue";
import confirmPopup from "./confirmationPopup.vue";
import playerRow from "./userRow.vue";
export default {
  name: "ReservationView",
  //props: ["isOwner"],
  components: {
    loader,
    playerRow,
    confirmPopup,
  },
  watch: {
    // whenever question changes, this function will run
    isConfirmed(newA) {
      if (newA) {
        this.cancelReservation();
      }
    },
  },
  data() {
    return {
      reservationInfo: null,
      TeamOne: [],
      TeamTwo: [],
      isIncluded: "",
      isConfirmed: false,
      confirmationMessage: null,
      isManagerAuth: false,
    };
  },
  async beforeMount() {
    this.$store.dispatch("setLoading");

    let _id = this.$route.params.id;
    let reservation = await axios.get(
      helpers.api + "getReservationById/" + _id
    );
    this.reservationInfo = reservation.data;
    let isManagerAuth = await helpers.isSportCenterAuthenticated(
      this.reservationInfo.sportCenterName
    );
    this.isManagerAuth = isManagerAuth;
    console.log(reservation.data.teamTwoIds);

    let T1P = reservation.data.teamOneIds.map(async (id) => {
      let res = {};
      let playerInfo = await axios.get(helpers.api + "getPlayer/" + id);
      let playerData = playerInfo.data;
      res["name"] = playerData.name;
      res["id"] = playerData.playerID;
      let img = await axios.get(
        helpers.api + "getProfilePictureByEmail/" + playerData.email
      );
      if (img.data) {
        res["src"] = `data:${img.data.img.contentType};base64,${Buffer.from(
          img.data.img.data,
          "utf-8"
        ).toString("base64")}`;
      } else {
        res["src"] = "";
      }
      return res;
    });
    await Promise.all(T1P).then((results) => {
      this.TeamOne = results;
    });
    let T2P = reservation.data.teamTwoIds.map(async (id) => {
      let res = {};
      let playerInfo = await axios.get(helpers.api + "getPlayer/" + id);
      let playerData = playerInfo.data;
      res["name"] = playerData.name;
      res["id"] = playerData.playerID;
      let img = await axios.get(
        helpers.api + "getProfilePictureByEmail/" + playerData.email
      );
      if (img.data) {
        res["src"] = `data:${img.data.img.contentType};base64,${Buffer.from(
          img.data.img.data,
          "utf-8"
        ).toString("base64")}`;
      } else {
        res["src"] = "";
      }
      return res;
    });
    await Promise.all(T2P).then((results) => {
      this.TeamTwo = results;
    });
    if (this.$store.state.playerInfo) {
      if (
        this.reservationInfo.teamOneIds.includes(
          this.$store.state.playerInfo.playerID
        )
      ) {
        this.isIncluded = "teamOne";
      } else if (
        this.reservationInfo.teamTwoIds.includes(
          this.$store.state.playerInfo.playerID
        )
      ) {
        this.isIncluded = "teamTwo";
      } else {
        this.isIncluded = "";
      }
    }
    this.$store.dispatch("stopLoading");
  },
  methods: {
    deleteT() {
      this.confirmationMessage = "Are you sure to cancel this reservation?";
    },
    async includeMeInTeam(teamNumber) {
      this.$store.dispatch("setLoading");
      let newList = [];
      if (teamNumber === 1) {
        newList = this.reservationInfo.teamOneIds;
      } else {
        newList = this.reservationInfo.teamTwoIds;
      }
      newList.push(this.$store.state.playerInfo.playerID);
      await axios.post(helpers.api + "updateTeamPlayers", {
        reservationId: this.$route.params.id,
        teamNumber: teamNumber,
        playerIds: newList,
      });
      if (teamNumber === 1) {
        this.reservationInfo.teamOneIds = newList;
        this.isIncluded = "teamOne";
      } else {
        this.reservationInfo.teamTwoIds = newList;
        this.isIncluded = "teamTwo";
      }
      let T1P = this.reservationInfo.teamOneIds.map(async (id) => {
        let res = {};
        let playerInfo = await axios.get(helpers.api + "getPlayer/" + id);
        let playerData = playerInfo.data;
        res["name"] = playerData.name;
        res["id"] = playerData.playerID;
        let img = await axios.get(
          helpers.api + "getProfilePictureByEmail/" + playerData.email
        );
        if (img.data) {
          res["src"] = `data:${img.data.img.contentType};base64,${Buffer.from(
            img.data.img.data,
            "utf-8"
          ).toString("base64")}`;
        } else {
          res["src"] = "";
        }
        return res;
      });
      await Promise.all(T1P).then((results) => {
        this.TeamOne = results;
      });
      let T2P = this.reservationInfo.teamTwoIds.map(async (id) => {
        let res = {};
        let playerInfo = await axios.get(helpers.api + "getPlayer/" + id);
        let playerData = playerInfo.data;
        res["name"] = playerData.name;
        res["id"] = playerData.playerID;
        let img = await axios.get(
          helpers.api + "getProfilePictureByEmail/" + playerData.email
        );
        if (img.data) {
          res["src"] = `data:${img.data.img.contentType};base64,${Buffer.from(
            img.data.img.data,
            "utf-8"
          ).toString("base64")}`;
        } else {
          res["src"] = "";
        }
        return res;
      });
      await Promise.all(T2P).then((results) => {
        this.TeamTwo = results;
      });
      this.$store.dispatch("stopLoading");
    },
    async cancelReservation() {
      this.$store.dispatch("setLoading");
      await axios.delete(
        helpers.api + "deleteReservation/" + this.$route.params.id
      );
      if (this.$store.state.playerInfo) {
        this.$router.push("/");
      } else {
        this.$router.push("/manager-home-page");
      }
      this.$store.dispatch("stopLoading");
    },
    async goToSportCenter() {
      this.$store.dispatch("setLoading");
      let res = await helpers.isSportCenterAuthenticated(
        this.reservationInfo.sportCenterName
      );
      if (!res) {
        this.$router.push(
          "/sport-center-view/" +
            this.reservationInfo.sportCenterName +
            "/false"
        );
      } else {
        this.$router.push(
          "/sport-center-view/" + this.reservationInfo.sportCenterName + "/true"
        );
      }
    },
  },
  computed: {
    isOwner() {
      if (this.isManagerAuth) {
        return true;
      } else {
        if (this.$store.state.playerInfo) {
          if (
            this.reservationInfo.reserverEmail ===
            this.$store.state.playerInfo.email
          ) {
            return true;
          }
        } else {
          return false;
        }
      }
      return false;
    },
    isLoading() {
      return this.$store.state.isLoading;
    },
    time() {
      return (
        this.reservationInfo.reservationTime.startTime +
        "-" +
        this.reservationInfo.reservationTime.endTime
      );
    },
  },
};
</script>
<style lang="scss" scoped>
* {
  color: #45a049;
}
.hidden {
  opacity: 0.07;
}
.reservation-view {
  margin: 20px;
}

.reservation-info {
  background-color: #f0f0f0;
  padding: 20px;
  margin-bottom: 20px;
}

.info-row {
  display: flex;
  margin-bottom: 10px;
}

.label {
  font-weight: bold;
  width: 150px;
}
.sport-center {
  text-decoration: underline;
}

.team-players {
  display: flex;
  justify-content: space-between;
  margin-bottom: 20px;
}

.team {
  width: 45%;
  background-color: #f0f0f0;
  padding: 20px;
}

.team h3 {
  margin-bottom: 10px;
}

ul {
  padding: 0;
}

li {
  list-style-type: none;
  margin-bottom: 5px;
}

.button-div {
  display: flex;
  justify-content: center;
}

.button {
  background-color: #45a049;
  color: #fff;
  padding: 10px 20px;
  border: none;
  border-radius: 4px;
  font-size: 16px;
  cursor: pointer;
}

.button:hover {
  background-color: #45a049;
}
</style>
