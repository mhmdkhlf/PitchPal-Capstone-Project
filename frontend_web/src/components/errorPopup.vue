<template>
  <div class="error-popup" v-if="on">
    <p>{{ errorMessage }}</p>
    <button @click="dismissError">OK</button>
  </div>
</template>

<script>
export default {
  name: "ErrorPopup",
  props: ["errorMessage"],
  data() {
    return {
      on: true,
    };
  },
  methods: {
    dismissError() {
      this.on = false;
      this.$parent.error = null;
    },
  },
};
</script>

<style scoped>
.error-popup {
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 400px;
  max-width: 80%;
  background-color: #f44336;
  color: white;
  padding: 20px;
  border-radius: 10px;
  text-align: center;
  z-index: 9999;
}
.error-popup p {
  margin: 0;
}
.error-popup button {
  background-color: white;
  color: #f44336;
  border: none;
  padding: 10px 20px;
  border-radius: 5px;
  cursor: pointer;
  margin-top: 10px;
}
</style>
