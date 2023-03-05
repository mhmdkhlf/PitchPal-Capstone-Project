<template>
  <div class="logo-div">
    <img src="../assets/images/logo.png" alt="failed" />
    <h1 class="logo">itchPal</h1>
  </div>
</template>

<script>
export default {
  name: "logoComponent",
};
</script>

<style scoped lang="scss">
.logo-div {
  display: flex;
  justify-content: space-between;
  align-items: center;
  position: absolute;
  top: 0;
  left: 0;
  img {
    width: 50px;
    height: 50px;
    z-index: 1;
    mix-blend-mode: multiply;
  }
  .logo {
    font-size: 40px;
    font-weight: bold;
    color: #0a870ac7; /* Change to green color code */
    margin: 0;
    // padding: 20px;
    text-shadow: 2px 2px 2px rgba(0, 0, 0, 0.5);
    letter-spacing: 2px;
    //background-color: #fff;
    border-radius: 10px;
    //box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.2);
    //transform: rotate(-15deg);
    z-index: 1;
  }
}
</style>
