<template>
  <loader v-if="isLoading" />
  <div class="all" v-if="!isLoading">
    <nav class="navbar">
      <div class="navbar-left">
        <h1>Your Friends</h1>
      </div>
    </nav>
    <div class="cards">
      <div class="players-cards">
        <playerCard
          v-for="(player, index) in players"
          :player-info="player"
          :key="index"
        />
      </div>
    </div>
  </div>
</template>
<script>
import axios from "axios";
import playerCard from "./playerCard.vue";
import { Buffer } from "buffer";
import loader from "./loader.vue";
const helpers = require("../../helpers/authentication");
export default {
  name: "friendsView",
  components: {
    playerCard,
    loader,
  },
  data() {
    return {
      players: [],
    };
  },
  computed: {
    isLoading() {
      return this.$store.state.isLoading;
    },
  },
  async beforeMount() {
    let playerId = this.$store.state.playerInfo.playerID;
    this.$store.dispatch("setLoading");
    let friends = await axios.get(helpers.api + "getFriends/" + playerId);
    await Promise.all(
      friends.data.map(async (id) => {
        let playerI = await axios.get(
          "http://localhost:5000/api/getPlayer/" + id
        );

        let img = await axios.get(
          "http://localhost:5000/api/getProfilePictureByEmail/" +
            playerI.data.email
        );

        if (img.data) {
          playerI.data["src"] = `data:${
            img.data.img.contentType
          };base64,${Buffer.from(img.data.img.data, "utf-8").toString(
            "base64"
          )}`;
          this.players.push(playerI.data);
        } else {
          this.players.push(playerI.data);
        }
      })
    );
    this.$store.dispatch("stopLoading");
  },
};
</script>
<style lang="scss" scoped>
.players-cards {
  // display: flex;
  // flex-wrap: wrap;
  // padding: 4px;
  // margin: 0 auto;
  // max-width: 1000px;
  display: grid;
  gap: 5px;
  grid-template-columns: repeat(3, 1fr);
  @media (max-width: 768px) {
    grid-template-columns: repeat(1, 1fr);
  }
  // grid-template-columns: repeat(auto-fill, minmax(225px, 1fr));
}
.navbar {
  background-color: #1e9600;
  color: white;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 20px;
  font-size: 24px;
}
@media only screen and (max-width: 600px) {
  .navbar {
    flex-direction: column;
  }
  .navbar-left {
    width: 100%;
    text-align: center;
  }
}
.navbar h1 {
  margin: 0;
}
</style>
