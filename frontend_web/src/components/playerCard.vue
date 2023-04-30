<template>
  <div class="all">
    <div class="column">
      <div class="card">
        <div class="image">
          <img
            class="player-image"
            :src="playerInfo.src"
            alt="John"
            style="width: 100%"
            v-if="playerInfo.src"
          />
          <img
            class="player-image"
            src="../assets/images/image.jpg"
            alt="John"
            style="width: 100%"
            v-else
          />
        </div>

        <div class="container">
          <h2>{{ playerInfo.name }}</h2>
          <p class="title">{{ playerInfo.position }}</p>
          <p>{{ playerInfo.description }}</p>
          <p>{{ playerInfo.email }}</p>
          <p>
            <button class="button" @click="goToProfile()">View Profile</button>
          </p>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  name: "playerCardComponent",
  props: ["playerInfo"],
  methods: {
    goToProfile() {
      if (!this.$store.playerInfo) {
        this.$router.push(
          "/player-profile/" + this.playerInfo.playerID + "/false"
        );
      } else {
        if (this.$store.playerInfo.playerID === this.playerInfo.playerID) {
          this.$router.push(
            "/player-profile/" + this.playerInfo.playerID + "/true"
          );
        } else {
          this.$router.push(
            "/player-profile/" + this.playerInfo.playerID + "/false"
          );
        }
      }
    },
  },
};
</script>
<style lang="scss" scoped>
.all {
  box-sizing: border-box;
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

@media screen and (max-width: 650px) {
  .column {
    width: 100%;
    display: block;
  }
}

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
  width: 400px;
  height: 400px;
  img {
    width: 100%;
    height: 100%;
  }
}
</style>
