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
        <profilePicture @pictureUploaded="getImage" />
      </div>

      <div class="form-group">
        <label for="name" class="required">Name:</label>
        <input type="text" id="name" v-model="name" />
      </div>

      <div class="form-group">
        <label for="email" class="required">Email:</label>
        <input type="email" id="email" v-model="email" />
      </div>

      <div class="form-group">
        <label for="phone" class="required">Phone Number:</label>
        <input type="tel" id="phone" v-model="phone" />
      </div>

      <div class="form-group">
        <label for="center-name" class="required">Sport Center Name:</label>
        <input type="text" id="center-name" v-model="centerName" />
      </div>
      <div class="form-group">
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
        type="button"
        class="submit-button"
        @click="createManager($event)"
      >
        Submit
      </button>
    </form>
  </div>
</template>

<script>
import profilePicture from "./profilePicture.vue";
import errorPopup from "./errorPopup.vue";
import loader from "./loader.vue";
import axios from "axios";
export default {
  name: "ManagerProfile",
  components: {
    profilePicture,
    errorPopup,
    loader,
  },
  data() {
    return {
      name: "",
      email: sessionStorage.getItem("user")
        ? sessionStorage.getItem("user")
        : "",
      phone: "",
      centerName: "",
      error: null,
      image: null,
    };
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
    goToSportCenterCreation() {
      this.$router.push("/sport-center-form");
    },
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

.field-title {
  margin-top: 20px;
  margin-bottom: 10px;
  color: green;
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
