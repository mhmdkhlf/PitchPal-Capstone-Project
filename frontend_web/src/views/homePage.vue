<template>
  <div class="home">Welcome Ali Solh</div>
  <button @click="go()">team Profile</button>
  <button @click="goToForm()">team Form</button>
  <button @click="sportCenters()">sportCenters</button>
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
      this.$router.push("/team-profile/majd team/true");
    },
    goToForm() {
      this.$router.push("/team-form");
    },
    sportCenters() {
      this.$router.push("/sport-centers");
    },
  },
};
</script>
