<template>
  <div class="home">Welcome Ali Solh</div>
  <button @click="go()">team Profile</button>
  <button @click="goToForm()">team Form</button>
  <button @click="sportCenters()">sportCenters</button>
  <button @click="profile()">Your profile</button>
  <button @click="oprofile()">other</button>
  <button @click="oprofileT()">other True</button>
  <button @click="friends()">friends</button>
</template>

<script>
export default {
  name: "HomeView",
  created() {
    //console.log(JSON.parse(localStorage.getItem("user")));
    //user is not authorized
    if (sessionStorage.getItem("user") === null) {
      this.$router.push("/login");
    }
  },
  methods: {
    go() {
      this.$router.push("/team-profile/majd team/false");
    },
    goToForm() {
      this.$router.push("/team-form");
    },
    sportCenters() {
      this.$router.push("/sport-centers");
    },
    profile() {
      this.$router.push("player-profile/262-887/true");
    },
    oprofile() {
      this.$router.push("/player-profile/971-754/false");
    },
    oprofileT() {
      this.$router.push("/player-profile/971-754/true");
    },
    friends() {
      this.$router.push("/friends");
    },
  },
};
</script>
