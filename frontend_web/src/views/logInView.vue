<template>
  <logo />
  <logInBody />
</template>

<script>
import logInBody from "@/components/logInBody.vue";
import logo from "../components/logo.vue";
export default {
  name: "logInView",
  components: {
    logInBody,
    logo,
  },
};
</script>
