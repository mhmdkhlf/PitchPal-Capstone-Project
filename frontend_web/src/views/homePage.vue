<template>
  <div class="home">Welcome Ali Solh</div>
  <button @click="go()">team</button>
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
      this.$router.push("/team-profile/majed team/true");
    },
  },
};
</script>
