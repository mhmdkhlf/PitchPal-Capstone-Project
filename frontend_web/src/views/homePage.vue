<template>
  <div class="home">Welcome Ali Solh</div>
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
};
</script>
