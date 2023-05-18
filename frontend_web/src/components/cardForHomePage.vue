<template>
  <div class="all">
    <div class="column">
      <div class="card">
        <div class="image">
          <img
            class="player-image"
            src="../assets/images/background.jpg"
            alt="John"
            style="width: 100%"
            v-if="isSportCenter"
          />
          <img
            class="player-image"
            src="../assets/images/matches.jpg"
            alt="John"
            style="width: 100%"
            v-else-if="isPublicMatches"
          />
          <img
            class="player-image"
            src="../assets/images/friends.webp"
            alt="John"
            style="width: 100%"
            v-else-if="isFriends"
          />
          <img
            class="player-image"
            src="../assets/images/team.webp"
            alt="John"
            style="width: 100%"
            v-else
          />
        </div>

        <div class="container">
          <h2 v-if="isSportCenter">View and Reserve Sport Centers</h2>
          <h2 v-else-if="isPublicMatches">View World Wide public Matches</h2>
          <h2 v-else-if="isFriends">View Your Friends</h2>
          <h2 v-else>Create Your Team</h2>

          <p>
            <button class="button" @click="goToProfile()">Check Details</button>
          </p>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  name: "sportCenterCardComponent",
  props: ["isSportCenter", "isPublicMatches", "isFriends", "isCreateTeam"],
  methods: {
    goToProfile() {
      if (this.isSportCenter) {
        this.$emit("pressed", "sportCenter");
      } else if (this.isPublicMatches) {
        this.$emit("pressed", "isPublicMatches");
      } else if (this.isFriends) {
        this.$emit("pressed", "isFriends");
      } else {
        this.$emit("pressed", "isCreateTeam");
      }
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
