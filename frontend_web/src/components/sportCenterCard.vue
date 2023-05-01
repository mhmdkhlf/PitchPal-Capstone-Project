<template>
  <div class="all">
    <div class="column">
      <div class="card">
        <div class="image">
          <img
            class="player-image"
            :src="sportCenterInfo.src"
            alt="John"
            style="width: 100%"
            v-if="sportCenterInfo.src"
          />
          <img
            class="player-image"
            src="../assets/images/background.jpg"
            alt="John"
            style="width: 100%"
            v-else
          />
        </div>

        <div class="container">
          <h2>{{ sportCenterInfo.name }}</h2>
          <p class="title">{{ sportCenterInfo.location.place }}</p>
          <!-- <p>{{ playerInfo.description }}</p> -->
          <p>{{ sportCenterInfo.phoneNumber }}</p>
          <p>
            <button class="button" @click="goToProfile()">View Details</button>
          </p>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  name: "sportCenterCardComponent",
  props: ["sportCenterInfo"],
  methods: {
    goToProfile() {
      // if (!this.$store.state.managerInfo) {
      //   this.$router.push(
      //     "/player-profile/" + this.managerInfo.email + "/false"
      //   );
      // } else {
      //   if (
      //     this.$store.state.playerInfo.playerID === this.playerInfo.playerID
      //   ) {
      //     this.$router.push(
      //       "/player-profile/" + this.playerInfo.playerID + "/true"
      //     );
      //   } else {
      //     this.$router.push(
      //       "/player-profile/" + this.playerInfo.playerID + "/false"
      //     );
      //   }
      // }
    },
  },
};
</script>
<style lang="scss" scoped>
.all {
  //box-sizing: border-box;
  color: green !important;
}

*,
*:before,
*:after {
  box-sizing: inherit;
}

.column {
  // width: 33.3%;
  margin-bottom: 16px;
  padding: 0 8px;
}

// @media screen and (max-width: 650px) {
//   .column {
//     width: 100%;
//     display: block;
//   }
// }

.card {
  box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);
}

.container {
  padding: 0 16px;
}

.container::after {
  content: "";
  clear: both;
  display: table;
}

.title {
  color: grey;
}

.button {
  border: none;
  outline: 0;
  display: inline-block;
  padding: 8px;
  color: white;
  background-color: #000;
  text-align: center;
  cursor: pointer;
  width: 100%;
  background-color: green;
}
.image {
  box-sizing: border-box;
  // width: 380px;
  height: 60vh;
  @media (max-width: 768px) {
    width: 100%;
    height: 100%;
  }
  img {
    width: 100%;
    height: 100%;
  }
}
</style>
