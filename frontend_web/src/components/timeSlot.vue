<template>
  <div
    class="body"
    :class="{ black: isReserved, green: isFree, yellow: isPending }"
  >
    <p>{{ startTime }} -{{ endTime }}</p>
  </div>
</template>
<script>
export default {
  name: "time-slot",
  props: ["startTime", "endTime", "type"],
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
};
</script>
<style scoped lang="scss">
.body {
  width: 160px;
  height: 80px;
  display: flex;
  justify-content: center;
  align-items: center;
}
.green {
  border: 2px solid green;
}
.yellow {
  border: 2px solid yellow;
}
.black {
  border: 2px solid black;
}
</style>
