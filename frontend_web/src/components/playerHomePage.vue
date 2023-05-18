<template>
  <loader v-if="this.$store.state.isLoading" />
  <div class="all" v-if="!this.$store.state.isLoading">
    <div class="nav">
      <h1>Welcome {{ managerInfo.name }}</h1>
      <a @click="playerProfile()">Your Profile</a>
      <a @click="myteams()">Your teams</a>
      <a @click="reservations()">{{ sportCenterInfo.name }}</a>
      <a @click="logOut()">Log Out</a>
    </div>
  </div>
</template>
<script>
const helpers = require("../../helpers/authentication");
import loader from "./loader.vue";
import axios from "axios";
export default {
  name: "homePage",
  components: {
    loader,
  },
  beforeMount() {},
};
</script>
<style lang=""></style>
