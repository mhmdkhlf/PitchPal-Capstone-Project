<template>
  <errorPopup v-if="error" :errorMessage="error" />
  <loader v-if="isLoading && !error" />
  <div class="body-content" v-if="!isLoading" :class="{ hidden: error }">
    <div id="bg"></div>
    <form>
      <!-- <div class="form-field">
        <input type="text" v-model="name" placeholder="Name" required />
      </div> -->
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
      <div class="form-field">
        <input
          type="password"
          v-model="rePassword"
          placeholder="Confirm Password"
          required
        />
      </div>
      <div class="select-menu form-field">
        <select name="role" required v-model="role">
          <option value="">role</option>
          <option value="admin">admin</option>
          <option value="player">player</option>
          <option value="field manager">field manager</option>
        </select>
      </div>
      <div class="form-field rmv-margin">
        <button class="btn" type="submit" @click="signUp($event)">
          Sign Up
        </button>
      </div>
      <div class="button-seperator-text">
        <h2>Having An Account?</h2>
      </div>
      <div class="form-field">
        <button class="btn" type="button" @click="logIn()">Log In</button>
      </div>
    </form>
  </div>
</template>

<script>
import axios from "axios";
import errorPopup from "./errorPopup.vue";
import loader from "./loader.vue";
export default {
  name: "signUpBody",
  data() {
    return {
      // name: "",
      email: "",
      password: "",
      rePassword: "",
      role: "",
      error: null,
    };
  },
  components: {
    errorPopup,
    loader,
  },
  mounted() {
    console.log(this.$store.state.isLoading);
  },
  computed: {
    isLoading() {
      return this.$store.state.isLoading;
    },
  },
  methods: {
    logIn() {
      this.$router.push("/login");
    },
    signUp(e) {
      e.preventDefault();
      this.$store.dispatch("setLoading");
      let { password, role, rePassword, email } = this;
      if (password !== rePassword) {
        this.error = "Passwords are not Compatible.Please try again";
      } else {
        axios
          .post("http://localhost:5000/api/signUp", {
            email,
            role,
            password,
          })
          .then(
            (res) => {
              if (res.status === 200) {
                this.$store.dispatch("stopLoading");
                this.$router.push("/logIn/" + this.email);
              }
            },
            (err) => {
              this.$store.dispatch("stopLoading");
              this.error = err.response.data.error;
            }
          );
      }
    },
  },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped lang="scss">
@import url("https://fonts.googleapis.com/css?family=Lato:400,700");
.button-seperator-text {
  display: flex;
  justify-content: center;
  align-items: center;
  text-align: center;
  margin: 0;
  color: #fff;
}
.hidden {
  opacity: 0.07;
}
.rmv-margin {
  margin-bottom: 0 !important;
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
  width: 100%;
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
  // .form-field:nth-child(1)::before {
  //   background-image: url(../assets/images/user-icon.png);
  //   width: 20px;
  //   height: 20px;
  //   top: 15px;
  // }
  .form-field:nth-child(1)::before {
    background-image: url(../assets/images/email-icon.png);
    width: 20px;
    height: 20px;
    top: 15px;
  }
  .form-field:nth-child(2)::before {
    background-image: url(../assets/images/lock-icon.png);
    width: 16px;
    height: 16px;
  }
  .form-field:nth-child(3)::before {
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
