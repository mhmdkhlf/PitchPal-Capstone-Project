<template>
  <div
    class="body"
    :class="{
      black: isReserved,
      green: isFree,
      yellow: isPending,
      bgBlack: isSelected,
    }"
    @click="selectTime()"
  >
    <p>{{ startTime }} -{{ endTime }}</p>
  </div>
</template>
<script>
export default {
  name: "time-slot",
  props: ["startTime", "endTime", "type", "isSelected"],
  computed: {
    isReserved() {
      return this.type === "reserved";
    },
    isFree() {
      return this.type === "free";
    },
    isPending() {
      return this.type === "pending";
    },
  },
  //   data() {
  //     return {
  //        false,
  //     };
  //   },
  methods: {
    selectTime() {
      let send = {
        startTime: this.startTime,
        endTime: this.endTime,
      };
      //   this.isSelected = true;
      this.$emit("selected", send);
    },
  },
};
</script>
<style scoped lang="scss">
.body {
  width: 160px;
  height: 80px;
  display: flex;
  justify-content: center;
  align-items: center;
  cursor: pointer !important;
}
.body :hover {
  background-color: green !important    ;
  color: white;
}
.bgBlack {
  background-color: green;
  color: white;
}
.green {
  border: 2px solid green;
}
.yellow {
  border: 2px solid yellow;
}
.black {
  border: 2px solid black !important;
}
</style>
