<template>
  <link
    rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"
  />
  <loader v-if="isLoading && !error" />
  <div
    class="field-manager-form-container"
    v-if="!isLoading"
    :class="{ hidden: error }"
  >
    <h2 class="form-title">Sport Center Information</h2>
    <form class="field-manager-form">
      <div class="form-group">
        <!-- <label for="name">Sport Center photo and social media links</label> -->
        <div class="flex">
          <img src="../assets/images/background.jpg" alt="" id="img" />
          <a href="#" class="fa fa-facebook"></a>
          <a href="#" class="fa fa-instagram"></a>
        </div>
      </div>
      <div class="form-group">
        <label for="name">Name:</label>
        <input disabled type="text" id="name" v-model="name" />
      </div>
      <div class="form-group">
        <label for="phone">Phone Number:</label>
        <input disabled type="tel" id="phone" v-model="phoneNumber" />
      </div>

      <!-- <div class="form-group">
          <label for="center-name" >Working Hours</label>
          <input disabled type="number" id="center-name" v-model="workingHours" />
        </div> -->
      <h3 class="field-title">Facilities Avaialable</h3>
      <div
        v-for="(facility, index) in facilities"
        :key="index"
        class="field-group"
      >
        <h3>Facility {{ index + 1 }}</h3>
        <div class="form-group">
          <label for="dimensions">Facility Name</label>
          <input disabled type="text" id="dimensions" v-model="facility.name" />
        </div>
        <div class="form-group">
          <label for="dimensions">Facility Description</label>
          <input
            disabled
            type="text"
            id="dimensions"
            v-model="facility.description"
          />
        </div>
      </div>

      <h3 class="field-title">Fields</h3>
      <div v-for="(field, index) in fields" :key="index" class="field-group">
        <h3>Field {{ index + 1 }}</h3>
        <div class="form-group">
          <label for="field-number">Field Number:</label>
          <input
            disabled
            type="number"
            id="field-number"
            v-model="field.fieldNumber"
          />
        </div>
        <div class="form-group">
          <label for="field-number">Field Length:</label>
          <input
            disabled
            type="number"
            id="field-number"
            v-model="field.length"
          />
        </div>
        <div class="form-group">
          <label for="field-number">Field Width:</label>
          <input
            disabled
            type="number"
            id="field-number"
            v-model="field.width"
          />
        </div>
        <div class="form-group">
          <label for="field-number">Reservation Price:</label>
          <input
            disabled
            type="number"
            id="field-number"
            v-model="field.reservationPrice"
          />
        </div>
        <div class="form-group">
          <label for="field-number">Grass Type: (turf or grass )</label>
          <input
            disabled
            type="text"
            id="field-number"
            v-model="field.grassType"
          />
        </div>
        <div class="form-group">
          <label for="field-number">Recommended Team Size:</label>
          <input
            disabled
            type="number"
            id="field-number"
            v-model="field.recommendedTeamSize"
          />
        </div>
      </div>
    </form>
  </div>
</template>

<script>
import loader from "./loader.vue";
//import axios from "axios";
export default {
  name: "sportCenterProfile",
  components: {
    loader,
  },
  data() {
    return {
      name: "",
      locationLink: "",
      phoneNumber: "",
      linkToFB: "",
      linkToInsta: "",
      location: null,
      fields: [],
      facilities: [],
    };
  },
  computed: {
    isLoading() {
      return this.$store.state.isLoading;
    },
  },
};
</script>

<style lang="scss" scoped>
// #img{

// }
.flex {
  display: flex;
  justify-content: space-evenly;
  align-items: center;
}
.hidden {
  opacity: 0.07;
}
* {
  color: #2dce89;
}
::v-deep .profile-pic-div {
  position: relative !important;
  height: 180px !important;
  width: 251px !important;
  border-radius: 1% !important;
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
.form-group input[type="tel"],
.form-group input[type="number"],
.form-group input[type="time"] {
  padding: 10px;
  border: none;
  border-radius: 5px;
  background-color: #f5f5f5;
  font-size: 16px;
}
/* input {
      width: 100%;
    } */

.field-group {
  padding: 20px;
  border: 1px solid #ccc;
  border-radius: 5px;
  margin-bottom: 20px;
}

.field-group h4 {
  margin-top: 0;
}

.field-group .form-group {
  margin-bottom: 10px;
}
</style>
