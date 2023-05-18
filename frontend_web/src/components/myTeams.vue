<template>
  <loader v-if="this.$store.state.isLoading" />

  <div class="all" v-if="!this.$store.state.isLoading">
    <h1>Your Teams</h1>
    <tC
      v-for="team in teamInfo"
      :teamName="team.name"
      :captainId="team.captainId"
      :key="team._id"
    />
  </div>
</template>
<script>
import tC from "./teamCard.vue";
import loader from "./loader.vue";
import axios from "axios";
let helpers = require("../../helpers/authentication");
export default {
  name: "myTeamComponent",

  components: {
    tC,
    loader,
  },
  data() {
    return {
      teamInfo: null,
    };
  },
  async beforeMount() {
    this.$store.dispatch("setLoading");
    let team = await axios.get(
      helpers.api + "getAPlayersTeams/" + this.$route.params.id
    );
    this.teamInfo = team.data;
    this.$store.dispatch("stopLoading");
  },
};
</script>
<style lang="scss" scoped>
.all {
  border: 3px solid green;
  height: 100%;
  padding: 30px;
}
h1 {
  text-align: center;
  color: green;
}
</style>
