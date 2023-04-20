<template>
  <div class="error-popup" v-if="on">
    <p>{{ Message }}</p>
    <div class="flex">
      <button @click="confirm()">YES</button>
      <button @click="cancel()">NO</button>
    </div>
  </div>
</template>

<script>
export default {
  name: "ConfirmationPopup",
  props: ["Message"],
  data() {
    return {
      on: true,
    };
  },
  methods: {
    confirm() {
      this.on = false;
      this.$parent.isConfirmed = true;
      this.$parent.confirmationMessage = null;
    },
    cancel() {
      this.on = false;
      this.$parent.isConfirmed = false;
      this.$parent.confirmationMessage = null;
    },
  },
};
</script>

<style scoped lang="scss">
.flex {
  display: flex;
  flex-direction: row;
  justify-content: space-evenly;
}
.error-popup {
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 400px;
  max-width: 80%;
  background-color: #47ab11;
  color: white !important;
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
  color: #47ab11;
  border: none;
  padding: 10px 20px;
  border-radius: 5px;
  cursor: pointer;
  margin-top: 10px;
}
</style>
