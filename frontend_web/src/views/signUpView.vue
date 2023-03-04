<template>
  <logo />
  <signUpBody />
</template>
<script>
import signUpBody from "@/components/signUpBody.vue";
import logo from "@/components/logo.vue";

export default {
  name: "signUpView",
  components: {
    logo,
    signUpBody,
  },
};
</script>
