<template>
  <loader v-if="isLoading && !error" />
  <errorPopup v-if="error" :errorMessage="error" />
  <div class="body-content" :class="{ hidden: error }" v-if="!isLoading">
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
      <div class="form-field login">
        <button class="btn" type="submit" @click="logIn($event)">Log in</button>
      </div>
      <div class="button-seperator-text">
        <h2>Don't Have An Account?</h2>
      </div>
      <div class="form-field">
        <button class="btn" type="button" @click="signUp()">Sign Up</button>
      </div>
    </form>
  </div>
</template>

<script>
import axios from "axios";
import errorPopup from "./errorPopup.vue";
import loader from "./loader.vue";
export default {
  name: "logInBody",
  data() {
    return {
      email: "",
      password: "",
      error: null,
      role: null,
    };
  },
  components: {
    errorPopup,
    loader,
  },
  mounted() {
    // this.$root.on("signUpDone", (email) => {
    //   // here you need to use the arrow function
    //   this.email = email;
    // });
    this.email = this.$route.params.email ? this.$route.params.email : "";
  },
  computed: {
    isLoading() {
      return this.$store.state.isLoading;
    },
  },
  methods: {
    // sleep(ms) {
    //   return new Promise((resolve) => setTimeout(resolve, ms));
    // },
    signUp() {
      this.$router.push("/signUp");
    },
    logIn(e) {
      e.preventDefault();
      this.$store.dispatch("setLoading");
      let data = {
        email: this.email,
        password: this.password,
      };
      if (!this.email || !this.password) {
        this.error = "All fields must be filled";
        this.$store.dispatch("stopLoading");
      } else {
        axios.post("http://localhost:5000/api/logIn", data).then(
          (res) => {
            if (res.status === 200) {
              sessionStorage.setItem("user", res.data.email);
              this.role = res.data.user.role;
              if (this.role === "player") {
                axios
                  .post("http://localhost:5000/api/isFirstTimeLogIn", {
                    userType: "player",
                    userEmail: this.email,
                  })
                  .then((res) => {
                    if (res.data.result) {
                      this.$store.dispatch("stopLoading");
                      this.$router.push("/first-player-profile");
                    } else {
                      this.$store.dispatch("stopLoading");
                      this.$router.push("/");
                    }
                  });
              } else {
                axios
                  .post("http://localhost:5000/api/isFirstTimeLogIn", {
                    userType: "manager",
                    userEmail: this.email,
                  })
                  .then((res) => {
                    if (res.data.result) {
                      this.$store.dispatch("stopLoading");
                      this.$router.push("/first-manager-profile");
                    } else {
                      this.$store.dispatch("stopLoading");
                      this.$router.push("/manager-home-page");
                    }
                  });
              }
            }
          },
          (err) => {
            this.$store.dispatch("stopLoading");
            this.error = err.response.data.error;
          }
        );
      }
    },
    // logout() {
    //   sessionStorage.clear();
    //   this.$router.push('/login');
    // }
  },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped lang="scss">
@import url("https://fonts.googleapis.com/css?family=Lato:400,700");
.hidden {
  opacity: 0.07;
}
.login {
  margin-bottom: 0 !important;
}
.button-seperator-text {
  display: flex;
  justify-content: center;
  align-items: center;
  text-align: center;
  margin: 0;
  color: #fff;
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
