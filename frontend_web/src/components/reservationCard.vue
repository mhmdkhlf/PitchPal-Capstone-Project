<template>
  <div class="row" :class="{ between: fromManager }">
    <div class="user-info" @click="goToProfile()">
      <h2 class="user-name">
        {{ reservationInfo.sportCenterName }}, field:
        {{ reservationInfo.fieldNumber }}, time
        {{ reservationInfo.reservationTime.startTime }}-{{
          reservationInfo.reservationTime.endTime
        }}
      </h2>

      <p class="user-id">status: {{ reservationInfo.reservationStatus }}</p>
    </div>
    <div class="button" v-if="fromManager">
      <button class="accept" @click="accept()">Accept</button>
      <button class="reject" @click="reject()">Reject</button>
    </div>
  </div>
</template>
<script>
export default {
  name: "rCard",
  props: ["reservationInfo", "fromManager"],
  methods: {
    goToProfile() {
      this.$store.dispatch("setLoading");
      this.$router.push("/reservation/" + this.reservationInfo._id);
      this.$store.dispatch("stopLoading");
    },
    accept() {
      this.$emit("accepted", this.reservationInfo._id);
    },
    reject() {
      this.$emit("rejected", this.reservationInfo._id);
    },
  },
};
</script>
<style lang="scss" scoped>
.row {
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0px 1px 2px rgba(0, 0, 0, 0.2);
  border: 1px solid #4caf50;
  border-radius: 5px;
  padding: 10px;
  margin-bottom: 10px;
}
.between {
  justify-content: space-between !important;
}

* {
  cursor: pointer;
}

.user-info {
  display: flex;
  flex-direction: column;
  justify-content: center;
  text-align: center;
  align-items: center;
}

.user-name {
  margin: 0;
  font-size: 16px;
  color: #4caf50;
}

.user-id {
  margin: 0;
  font-size: 14px;
  color: #4caf50;
}
.button {
  //   display: flex;
  //   //align-items: center;
  //   justify-content: space-around;

  .accept {
    background-color: green;
    margin-right: 10px;
  }
  .reject {
    background-color: red;
  }
  color: white;
}
</style>
