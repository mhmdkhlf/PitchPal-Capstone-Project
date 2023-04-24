<template>
  <logo />
  <div class="form-container">
    <h1 class="form-title">Create Your Team</h1>
    <form action="" class="team-form">
      <div class="form-group">
        <input type="text" placeholder="Team Name" />
      </div>
      <div>
        <div>
          <input type="text" placeholder="Add Player" />
          <button id="push">Add</button>
        </div>
        <div id="tasks"></div>
      </div>
    </form>
  </div>
</template>
<script>
import logo from "./logo.vue";
export default {
  name: "TeamForm",
  components: {
    logo,
  },
  data() {
    return {
      teamIds: [],
    };
  },
};
</script>
<style lang="scss" scoped>
*,
*:before,
*:after {
  padding: 0;
  margin: 0;
  box-sizing: border-box;
}
body {
  height: 100vh;
  background: #066acd;
}
// .form-group {
//   margin-bottom: 20px;
// }
.form-container {
  /* display: flex;
    justify-content: center;
    align-items: center; */
  padding: 13px !important;
  height: 100%;
  /* Add this line */
  overflow-x: hidden !important;
  /* Fix scrolling issue */
}
.form-title {
  margin-top: 0;
  margin-bottom: 20px;
  color: #0a870ac7;
  text-align: center;
}

.team-form {
  display: flex;
  flex-direction: column;
  padding: 20px;
  background-color: #fff;
  border-radius: 10px;
  box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
}
#newtask {
  position: relative;
  padding: 30px 20px;
}
input {
  width: 75%;
  height: 45px;
  padding: 12px;
  color: #0a870ac7;
  font-weight: 500;
  position: relative;
  border-radius: 5px;
  font-family: "Poppins", sans-serif;
  font-size: 15px;
  border: 2px solid #d1d3d4;
  margin-bottom: 20px;
}
input:focus {
  outline: none;
  border-color: #0a870ac7;
}
button {
  position: relative;
  float: right;
  font-weight: 500;
  font-size: 16px;
  background-color: #0a870ac7;
  border: none;
  color: #ffffff;
  cursor: pointer;
  outline: none;
  width: 20%;
  height: 45px;
  border-radius: 5px;
  font-family: "Poppins", sans-serif;
}
#tasks {
  border-radius: 10px;
  width: 100%;
  position: relative;
  background-color: #ffffff;
  padding: 30px 20px;
  margin-top: 10px;
}

.task {
  border-radius: 5px;
  align-items: center;
  justify-content: space-between;
  border: 1px solid #939697;
  cursor: pointer;
  background-color: #c5e1e6;
  height: 50px;
  margin-bottom: 8px;
  padding: 5px 10px;
  display: flex;
}
.task span {
  font-family: "Poppins", sans-serif;
  font-size: 15px;
  font-weight: 400;
}
.task button {
  background-color: #0a870ac7;
  color: #ffffff;
  border: none;
  cursor: pointer;
  outline: none;
  height: 100%;
  width: 40px;
  border-radius: 5px;
}
</style>
