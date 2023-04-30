<template>
  <loader v-if="isLoading" />
  <div v-if="!isLoading">
    <h1 class="title">{{ teamInfo.name }}</h1>
    <div class="players-cards">
      <playerCard
        v-for="(player, index) in players"
        :player-info="player"
        :key="index"
      />
    </div>
  </div>
</template>
<script>
import axios from "axios";
const helpers = require("../../helpers/authentication.js");
import loader from "./loader.vue";
import playerCard from "./playerCard.vue";
import { Buffer } from "buffer";
export default {
  name: "teamView",
  components: {
    loader,
    playerCard,
  },
  beforeMount() {
    // if (this.isSelfVisit){
    //   if (!helpers.isPlayerAuthenticated())
    // }
    this.$store.dispatch("setLoading");
    axios
      .get(helpers.api + "getTeamByName/" + this.$route.params.name)
      .then(async (res) => {
        this.teamInfo = res.data;
        await Promise.all(
          this.teamInfo.playerIds.map(async (id) => {
            axios
              .get("http://localhost:5000/api/getPlayer/" + id)
              .then((res) => {
                axios
                  .get(
                    "http://localhost:5000/api/getProfilePictureByEmail/" +
                      res.data.email
                  )
                  .then((res2) => {
                    if (res2.data) {
                      res.data["src"] = `data:${
                        res2.data.img.contentType
                      };base64,${Buffer.from(
                        res2.data.img.data,
                        "utf-8"
                      ).toString("base64")}`;
                      this.players.push(res.data);
                    } else {
                      this.players.push(res.data);
                    }
                  });
              });
          })
        );
        this.$store.dispatch("stopLoading");
      });
  },
  data() {
    return {
      teamInfo: null,
      // isSelfVisit: this.$route.params.captainVisit === "true" ? true : false,
      players: [],
    };
  },
  computed: {
    isLoading() {
      return this.$store.state.isLoading;
    },
  },
};
</script>
<style lang="scss" scoped>
.title {
  text-align: center;
}
.players-cards {
  display: flex;
  flex-wrap: wrap;
}
</style>
