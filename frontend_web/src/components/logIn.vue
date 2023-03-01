<template>
  <button class="btn sign-up-button" type="button" @click="signUp()">
    Sign Up
  </button>
  <div class="logo-div">
    <img src="../assets/images/logo.png" alt="failed" />
    <h1 class="logo">itchPal</h1>
  </div>
  <div class="body-content">
    <div id="bg"></div>
    <form>
      <div class="form-field">
        <input type="email" v-model="email" placeholder="Email" required />
      </div>

      <div class="form-field">
        <input
          type="password"
          v-model="password"
          placeholder="Password"
          required
        />
      </div>
      <div class="select-menu">
        <select name="role" required v-model="role">
          <option value="">role</option>
          <option value="admin">admin</option>
          <option value="player">player</option>
          <option value="field manager">field manager</option>
        </select>
      </div>

      <div class="form-field">
        <button class="btn" type="submit">Log in</button>
      </div>
    </form>
  </div>
</template>

<script>
export default {
  name: "logInComponent",
  data() {
    return {
      email: "",
      password: "",
      role: "",
    };
  },
  methods: {
    signUp() {
      //e.preventDefault();

      this.$router.push("/signUp");
    },
  },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped lang="scss">
@import url("https://fonts.googleapis.com/css?family=Lato:400,700");
.sign-up-button {
  position: absolute;
  top: 5px;
  right: 5px;
  z-index: 1;
}
.btn {
  outline: none;
  border: none;
  cursor: pointer;
  display: inline-block;
  margin: 0 auto;
  padding: 0.9rem 2.5rem;
  text-align: center;
  background-color: #47ab11;
  color: #fff;
  border-radius: 4px;
  box-shadow: 0px 3px 6px rgba(0, 0, 0, 0.16);
  font-size: 17px;
}
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

#bg {
  background-image: url("../assets/images/background.jpg");
  position: fixed;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  background-size: cover;
}

.body-content {
  font-family: "Lato", sans-serif;
  color: #4a4a4a;
  display: flex;
  justify-content: center;
  flex-direction: column;
  align-items: center;
  min-height: 90vh;
  overflow: hidden;
  margin: 0;
  padding: 0;
}
form {
  width: 350px;
  position: relative;
  .select-menu {
    width: 100%;
    margin-bottom: 8px;
    select {
      width: 100%;
    }
  }
  .form-field::before {
    font-size: 20px;
    position: absolute;
    left: 15px;
    top: 17px;
    color: #888888;
    content: " ";
    display: block;
    background-size: cover;
    background-repeat: no-repeat;
  }
  .form-field:nth-child(1)::before {
    background-image: url(../assets/images/user-icon.png);
    width: 20px;
    height: 20px;
    top: 15px;
  }
  .form-field:nth-child(2)::before {
    background-image: url(../assets/images/lock-icon.png);
    width: 16px;
    height: 16px;
  }
  .form-field {
    display: -webkit-box;
    display: -ms-flexbox;
    display: flex;
    -webkit-box-pack: justify;
    -ms-flex-pack: justify;
    justify-content: space-between;
    -webkit-box-align: center;
    -ms-flex-align: center;
    align-items: center;
    margin-bottom: 1rem;
    position: relative;
  }
  input {
    font-family: inherit;
    width: 100%;
    outline: none;
    background-color: #fff;
    border-radius: 4px;
    border: none;
    display: block;
    padding: 0.9rem 0.7rem;
    box-shadow: 0px 3px 6px rgba(0, 0, 0, 0.16);
    font-size: 17px;
    color: #4a4a4a;
    text-indent: 40px;
  }
}
</style>
