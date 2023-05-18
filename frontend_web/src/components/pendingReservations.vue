<template>
  <loader v-if="this.$store.state.isLoading" />
  <div class="all" v-if="!this.$store.state.isLoading">
    <h1 class="t">Pending Requests</h1>
    <resCard
      v-for="res in reservations"
      :reservationInfo="res"
      :fromManager="true"
      :key="res._id"
      @accepted="accept"
      @rejected="reject"
    />
  </div>
</template>
<script>
import loader from "./loader.vue";
const helpers = require("../../helpers/authentication");
import resCard from "./reservationCard.vue";
import axios from "axios";
export default {
  name: "pendingReservations",
  components: {
    loader,
    resCard,
  },
  async beforeMount() {
    this.$store.dispatch("setLoading");
    let res = await axios.get(
      helpers.api +
        "getAllPendingReservationsBySportCenterForTodayAndAfter/" +
        this.$store.state.sportCenterInfo.name
    );
    this.reservations = res.data;
    this.$store.dispatch("stopLoading");
  },
  data() {
    return {
      reservations: null,
    };
  },
  methods: {
    async accept(_id) {
      console.log(_id);
      this.$store.dispatch("setLoading");
      await axios.patch(helpers.api + "editReservationStatus", {
        reservationId: _id,
        status: "accepted",
      });
      this.$store.dispatch("stopLoading");
      this.$router.push("/manager-home-page");
    },
    async reject(_id) {
      this.$store.dispatch("setLoading");
      await axios.patch(helpers.api + "editReservationStatus", {
        reservationId: _id,
        status: "rejected",
      });
      this.$store.dispatch("stopLoading");
      this.$router.push("/manager-home-page");
    },
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
