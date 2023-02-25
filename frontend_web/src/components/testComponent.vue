<template>
  <div class="hello">
    <div>{{ data }}</div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "testComponent",
  data() {
    return {
      data: null,
    };
  },
  mounted() {
    axios
      .get("http://localhost:5000/api/getPlayer/277-612")
      .then((response) => (this.data = response.data));
  },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped lang="scss"></style>
