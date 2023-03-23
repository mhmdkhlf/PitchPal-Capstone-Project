<template>
  <div class="loader">
    <h4>Loading</h4>
    <span class="dot dot-1"></span>
    <span class="dot dot-2"></span>
    <span class="dot dot-3"></span>
  </div>
</template>
<script>
export default {
  name: "TextLoader",
};
</script>
<style lang="scss" scoped>
h4 {
  color: #0a870ac7;
}
.loader {
  display: flex;
  justify-content: center;
  align-items: center;
  //   height: 100vh;
}

.dot {
  height: 12px;
  width: 12px;
  background-color: #0a870ac7;
  border-radius: 50%;
  margin: 0 8px;
  animation: fade 1.5s ease-in-out infinite;
}

.dot-1 {
  animation-delay: 0s;
}

.dot-2 {
  animation-delay: 0.5s;
}

.dot-3 {
  animation-delay: 1s;
}

@keyframes fade {
  0% {
    opacity: 0.4;
    transform: scale(0.8);
  }
  50% {
    opacity: 1;
    transform: scale(1);
  }
  100% {
    opacity: 0.4;
    transform: scale(0.8);
  }
}
</style>
