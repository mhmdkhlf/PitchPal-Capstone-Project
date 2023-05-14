<template>
  <errorPopup v-if="error" :errorMessage="error" />
  <loader v-if="isLoading && !error" />
  <div
    class="field-manager-form-container"
    v-if="!isLoading"
    :class="{ hidden: error }"
  >
    <h2 class="form-title">Field Manager Information</h2>
    <form class="field-manager-form">
      <div class="form-group">
        <label for="name">Profile Picture</label>
        <profilePicture
          @pictureUploaded="getImage"
          v-if="!this.$store.state.managerInfo"
        />
        <profilePicture
          :editvalue="imgEditValue"
          @pictureUploaded="getImage"
          v-else
        />
        <h3 v-if="imgEditValue" class="rmv-image" @click="rmvProfile()">
          Remove Profile Picture
        </h3>
      </div>

      <div class="form-group">
        <label for="name" class="required">Name:</label>
        <input type="text" id="name" v-model="name" />
      </div>

      <div class="form-group">
        <label for="email" class="required">Email:</label>
        <input
          type="email"
          id="email"
          v-model="email"
          :disabled="this.$store.state.managerInfo"
        />
      </div>

      <div class="form-group">
        <label for="phone" class="required">Phone Number:</label>
        <input type="tel" id="phone" v-model="phone" />
      </div>

      <div class="form-group">
        <label for="center-name" class="required">Sport Center Name:</label>
        <input
          type="text"
          id="center-name"
          v-model="centerName"
          :disabled="this.$store.state.managerInfo"
        />
      </div>
      <div class="form-group" v-if="!this.$store.state.managerInfo">
        <h3>
          If the sport center is not registered before in the system. Please
          Register it
          <button class="here-button" @click="goToSportCenterCreation">
            Here
          </button>
          and then create your profile
        </h3>
      </div>
      <button
        v-if="!this.$store.state.managerInfo"
        class="submit-button"
        type="button"
        @click="createManager($event)"
      >
        Contniue
      </button>
      <button
        v-if="this.$store.state.managerInfo"
        class="submit-button"
        type="button"
        @click="updateManager($event)"
      >
        Update
      </button>
    </form>
  </div>
</template>

<script>
import profilePicture from "./profilePicture.vue";
import errorPopup from "./errorPopup.vue";
import loader from "./loader.vue";
import { Buffer } from "buffer";
import axios from "axios";
const helpers = require("../../helpers/authentication.js");
export default {
  name: "ManagerProfile",
  components: {
    profilePicture,
    errorPopup,
    loader,
  },
  data() {
    return {
      name: this.$store.state.managerInfo
        ? this.$store.state.managerInfo.name
        : "",
      email: sessionStorage.getItem("user")
        ? sessionStorage.getItem("user")
        : "",
      phone: this.$store.state.managerInfo
        ? this.$store.state.managerInfo.mobileNumber
        : "",
      centerName: this.$store.state.managerInfo
        ? this.$store.state.managerInfo.sportCenterName
        : "",
      error: null,
      image: null,
      imgEditValue: "",
      done: false,
      rmvPicture: false,
    };
  },
  watch: {
    // whenever question changes, this function will run
    image() {
      this.imgEditValue = null;
    },
  },
  methods: {
    getImage(value) {
      this.image = value;
    },
    createManager(e) {
      e.preventDefault();
      this.$store.dispatch("setLoading");
      let { name, email, phone, centerName } = this;
      if (!name || !email || !phone || !centerName) {
        this.error = "All fields must be filled";
        this.$store.dispatch("stopLoading");
      } else {
        axios
          .post("http://localhost:5000/api/newManagerProfile", {
            email,
            mobileNumber: phone,
            name,
            sportCenterName: centerName,
          })
          .then(
            (res) => {
              if (res.status === 200) {
                if (this.image) {
                  var bodyFormData = new FormData();
                  bodyFormData.append("image", this.image);
                  bodyFormData.append("email", email);
                  axios({
                    url: "http://localhost:5000/api/uploadPicture",
                    method: "POST",
                    data: bodyFormData,
                  });
                }
                this.$store.dispatch("stopLoading");
                this.$router.push("/manager-home-page");
              }
            },
            (err) => {
              this.$store.dispatch("stopLoading");
              this.error = err.response.data.error;
            }
          );
      }
    },
    rmvProfile() {
      this.imgEditValue = null;
      this.rmvPicture = true;
    },
    updateManager(e) {
      e.preventDefault();
      this.$store.dispatch("setLoading");
      let { name, email, phone, centerName } = this;
      if (!name || !email || !phone || !centerName) {
        this.error = "All fields must be filled";
        this.$store.dispatch("stopLoading");
      } else {
        axios
          .patch(
            "http://localhost:5000/api/updateManager/" +
              this.$store.state.managerInfo._id,
            {
              mobileNumber: phone,
              name,
            }
          )
          .then(
            (res) => {
              if (res.status === 200) {
                this.$store.dispatch("setManagerInfo", res.data);
                sessionStorage.setItem("managerInfo", JSON.stringify(res.data));
                if (this.image) {
                  var bodyFormData = new FormData();
                  bodyFormData.append("image", this.image);
                  bodyFormData.append("email", email);
                  axios({
                    url: "http://localhost:5000/api/updateProfilePicture",
                    method: "POST",
                    data: bodyFormData,
                  });
                } else {
                  if (this.rmvPicture) {
                    axios.delete(
                      "http://localhost:5000/api/deletePicture/" +
                        sessionStorage.getItem("user")
                    );
                  }
                }
                this.$store.dispatch("stopLoading");
                this.$router.push("/manager-home-page");
              }
            },
            (err) => {
              this.$store.dispatch("stopLoading");
              this.error = err.response.data.error;
            }
          );
      }
    },
    goToSportCenterCreation() {
      this.$router.push("/sport-center-form");
    },
  },
  async mounted() {
    this.$store.dispatch("setLoading");
    if (this.$store.state.managerInfo) {
      axios
        .get("http://localhost:5000/api/getProfilePictureByEmail/" + this.email)
        .then((res2) => {
          if (res2.data) {
            this.imgEditValue = `data:${
              res2.data.img.contentType
            };base64,${Buffer.from(res2.data.img.data, "utf-8").toString(
              "base64"
            )}`;
          }
          this.done = true;
          this.$store.dispatch("stopLoading");
        });
    } else {
      const valid = await helpers.isManagerAuthenticated(
        sessionStorage.getItem("user")
      );
      if (!valid) {
        this.$router.push("/logIn");
        this.$store.dispatch("stopLoading");
      } else {
        this.done = true;
        this.$store.dispatch("stopLoading");
      }
    }
  },
  computed: {
    isLoading() {
      return this.$store.state.isLoading;
    },
  },
};
</script>
<style lang="scss" scoped>
.hidden {
  opacity: 0.07;
}
.rmv-image {
  text-align: center;
  margin: 0 !important;
  color: red;
  cursor: pointer;
}
.required:after {
  content: " *";
  color: red;
}
.here-button {
  border: #2dce89;
  height: 40px;
  border-radius: 30%;
}
* {
  color: #2dce89;
}
::v-deep .profile-pic-div {
  position: relative !important;
}
::v-deep .all {
  padding-bottom: 0 !important;
}
.field-manager-form-container {
  /* display: flex;
  justify-content: center;
  align-items: center; */
  padding: 20px !important;
  height: 100%;
  /* Add this line */
  overflow-x: hidden !important;
  /* Fix scrolling issue */
}

.field-manager-form {
  display: flex;
  flex-direction: column;
  padding: 20px;
  background-color: #fff;
  border-radius: 10px;
  box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
}

.form-title {
  margin-top: 0;
  margin-bottom: 20px;
  color: #2dce89;
}

.form-group {
  display: flex;
  flex-direction: column;
  margin-bottom: 20px;
}

.form-group label {
  margin-bottom: 5px;
}

.form-group input[type="text"],
.form-group input[type="email"],
.form-group input[type="tel"] {
  padding: 10px;
  border: none;
  border-radius: 5px;
  background-color: #f5f5f5;
  font-size: 16px;
}

.submit-button {
  padding: 10px;
  border: none;
  border-radius: 5px;
  background-color: #2dce89;
  color: #fff;
  font-size: 16px;
  cursor: pointer;
  margin-top: 20px;
  transition: all 0.2s ease-in-out;
}

.submit-button:hover {
  background-color: #fff;
  color: #2dce89;
  border: 1px solid #2dce89;
}
</style>
