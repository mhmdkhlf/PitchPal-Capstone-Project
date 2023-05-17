<template>
  <div class="row">
    <div class="user-info" @click="goToProfile()">
      <h2 class="user-name">{{ teamName }}</h2>

      <p class="user-id">CAPTAIN ID: {{ captainId }}</p>
    </div>
  </div>
</template>
<script>
const helpers = require("../../helpers/authentication");
export default {
  name: "tCard",
  props: {
    teamName: {
      type: String,
      required: true,
    },
    captainId: {
      type: String,
      required: true,
    },
    forSelection: {
      type: Boolean,
    },
  },
  methods: {
    async goToProfile() {
      this.$store.dispatch("setLoading");
      let auth = await helpers.isTeamAuthenticated(this.teamName);
      if (auth) {
        this.$router.push("/team-profile/" + this.teamName + "/true");
      } else {
        this.$router.push("/team-profile/" + this.teamName + "/false");
      }
      this.$store.dispatch("stopLoading");
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
</style>
