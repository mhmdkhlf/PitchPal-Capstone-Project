<template>
  <loader v-if="this.$store.state.isLoading" />
  <div class="all" v-if="!this.$store.state.isLoading">
    <h1 class="t">Today Public Matches</h1>
    <resCard
      v-for="res in reservations"
      :reservationInfo="res"
      :key="res._id"
      :fromManager="false"
    />
  </div>
</template>
<script>
import loader from "./loader.vue";
const helpers = require("../../helpers/authentication");
import resCard from "./reservationCard.vue";
import axios from "axios";
export default {
  name: "publicMatches",
  components: {
    loader,
    resCard,
  },
  async beforeMount() {
    this.$store.dispatch("setLoading");
    let res = await axios.get(helpers.api + "getAllPublicReservationsOfToday");
    this.reservations = res.data;
    this.$store.dispatch("stopLoading");
  },
  data() {
    return {
      reservations: null,
    };
  },
};
</script>
<style lang="scss" scoped>
.all {
  .t {
    text-align: center;
    background-color: green;
    color: white;
    margin: 0;
    margin-bottom: 7px;
  }
}
</style>
