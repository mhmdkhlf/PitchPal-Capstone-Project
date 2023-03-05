<template>
  <div class="home">Welcome Ali Solh</div>
</template>

<script>
export default {
  name: "HomeView",
  created() {
    //console.log(localStorage.getItem("user").data);
    //user is not authorized
    if (localStorage.getItem("user") === null) {
      this.$router.push("/login");
    }
  },
};
</script>
