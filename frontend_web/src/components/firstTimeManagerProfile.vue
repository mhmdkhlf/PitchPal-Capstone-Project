<template>
  <div class="field-manager-form-container">
    <h2 class="form-title">Field Manager Information</h2>
    <form class="field-manager-form" @submit.prevent="submitForm">
      <div class="form-group">
        <label for="name">Profile Picture</label>
        <profilePicture />
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
      <button type="submit" class="submit-button">Submit</button>
    </form>
  </div>
</template>

<script>
import profilePicture from "./profilePicture.vue";
export default {
  name: "ManagerProfile",
  components: {
    profilePicture,
  },
  data() {
    return {
      name: "",
      email: "",
      phone: "",
      centerName: "",
    };
  },
  methods: {
    submitForm() {
      // Do something with the form data, e.g. send it to the server
    },
    goToSportCenterCreation() {
      this.$router.push("/sport-center-form");
    },
  },
};
</script>
<style lang="scss" scoped>
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
