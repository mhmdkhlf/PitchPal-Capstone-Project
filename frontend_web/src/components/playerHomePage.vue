<template>
  <loader v-if="this.$store.state.isLoading" />
  <div class="all" v-if="!this.$store.state.isLoading">
    <div class="nav">
      <h1>Welcome {{ playerInfo.name }}</h1>
      <a @click="playerProfile()">Your Profile</a>
      <a @click="myteams()">Your teams</a>
      <a @click="reservations()">Your Reservations</a>
      <a @click="logOut()">Log Out</a>
    </div>
    <div class="grid">
      <card :isSportCenter="true" @pressed="go" />
      <card :isPublicMatches="true" @pressed="go" />
      <card :isFriends="true" @pressed="go" />
      <card :isCreateTeam="true" @pressed="go" />
    </div>
  </div>
</template>
<script>
import loader from "./loader.vue";
import card from "../components/cardForHomePage.vue";
const helpers = require("../../helpers/authentication");
export default {
  name: "homePage",
  components: {
    loader,
    card,
  },
  data() {
    return {
      playerInfo: this.$store.state.playerInfo,
    };
  },
  beforeMount() {
    let auth = helpers.isLoggedIn();
    if (!auth) {
      this.$router.push("/logIn");
    }
  },
  methods: {
    playerProfile() {
      this.$router.push("player-profile/" + this.playerInfo.playerID + "/true");
    },
    myteams() {
      this.$router.push("my-teams/" + this.playerInfo.playerID);
    },
    logOut() {
      this.$store.dispatch("setPlayerInfo", null);
      sessionStorage.clear();
      this.$router.push("/logIn");
    },
    reservations() {
      this.$router.push("/myReservations");
    },
    go(type) {
      if (type === "sportCenter") {
        this.$router.push("/sport-centers");
      } else if (type === "isPublicMatches") {
        this.$router.push("/publicMatches");
      } else if (type === "isFriends") {
        this.$router.push("/friends/" + this.playerInfo.playerID);
      } else {
        this.$router.push("/team-form");
      }
    },
  },
};
</script>
<style lang="scss" scoped>
.nav {
  background-color: green;
  color: white;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-left: 10px;
  padding-right: 10px;
}
a {
  text-decoration: underline;
}
.time-slots {
  display: grid;
  gap: 15px;
  grid-template-columns: repeat(5, 1fr);
  @media (max-width: 768px) {
    grid-template-columns: repeat(2, 1fr);
  }
  padding: 20px;
}
.form-container {
  margin: 30px;
}
input,
select {
  margin-left: 5px;
}
.grid {
  display: grid;
  gap: 15px;
  grid-template-columns: repeat(2, 1fr);
  @media (max-width: 768px) {
    grid-template-columns: repeat(1, 1fr);
  }
  padding: 20px;
}
</style>
