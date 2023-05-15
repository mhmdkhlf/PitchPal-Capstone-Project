<template>
  <loader v-if="isLoading" />
  <div class="all" v-if="!isLoading">
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
          <span class="label">Reservation Date:</span>
          <span class="value">{{ reservationInfo.reservationDate }}</span>
        </div>
        <div class="info-row">
          <span class="label">Reservation Type:</span>
          <span class="value">{{ reservationInfo.reserverType }}</span>
        </div>
        <div class="info-row">
          <span class="label">Comments:</span>
          <span class="value">{{ reservationInfo.comment }}</span>
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
          <button class="button" @click="includeMeInTeam(1)" v-if="!isOwner">
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
          <button class="button" @click="includeMeInTeam(2)" v-if="!isOwner">
            Include Me in the Team
          </button>
        </div>
      </div>

      <div class="button-div" v-if="isOwner">
        <button @click="cancelReservation" class="button">
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
import playerRow from "./userRow.vue";
export default {
  name: "ReservationView",
  //props: ["isOwner"],
  components: {
    loader,
    playerRow,
  },
  data() {
    return {
      reservationInfo: null,
      TeamOne: [],
      TeamTwo: [],
      // sportCenterName: "Green Sports Center",
      // reserverEmail: "john@example.com",
      // fieldNumber: 1,
      // reservationDate: "2023-05-20",
      // reservationType: "Player",
      // comments: "Please bring your own equipment.",
      // team1Players: [
      //   { id: 1, name: "John Doe" },
      //   { id: 2, name: "Jane Smith" },
      //   { id: 3, name: "Mike Johnson" },
      // ],
      // team2Players: [
      //   { id: 4, name: "Sarah Davis" },
      //   { id: 5, name: "Robert Williams" },
      //   { id: 6, name: "Emily Brown" },
      // ],
    };
  },
  async beforeMount() {
    this.$store.dispatch("setLoading");
    let _id = this.$route.params.id;
    let reservation = await axios.get(
      helpers.api + "getReservationById/" + _id
    );
    this.reservationInfo = reservation.data;
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
    this.$store.dispatch("stopLoading");
  },
  methods: {
    includeMeInTeam(teamNumber) {
      // Logic to include the current user in the selected team
      // You can implement your own logic here
      console.log("Included in Team:", teamNumber);
    },
    cancelReservation() {
      // Logic to cancel the reservation
      // You can implement your own logic here
      console.log("Reservation canceled");
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
      //return this.isOwner === "true";
      return true;
    },
    isLoading() {
      return this.$store.state.isLoading;
    },
  },
};
</script>
<style lang="scss" scoped>
* {
  color: #45a049;
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
