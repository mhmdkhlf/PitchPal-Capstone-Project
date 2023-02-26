<template>
  <div class="home">
    <testComponent msg="Welcome to Your Vue.js App" />
  </div>
</template>

<script>
// @ is an alias to /src
import testComponent from "@/components/testComponent.vue";

export default {
  name: "HomeView",
  components: {
    testComponent,
  },
};
</script>
