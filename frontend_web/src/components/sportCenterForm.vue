<template>
  <div class="field-manager-form-container">
    <h2 class="form-title">Field Manager Information</h2>
    <form class="field-manager-form" @submit.prevent="submitForm">
      <div class="form-group">
        <label for="name">Sport Center Profile Picture</label>
        <profilePicture />
      </div>
      <div class="form-group">
        <label for="name" class="required">Name:</label>
        <input type="text" id="name" v-model="name" />
      </div>
      <div class="form-group">
        <label for="email" class="required"
          >Location Link (open google maps from your laptop, mark your court,
          copy the link and paste it here)</label
        >
        <input type="text" id="email" v-model="locationLink" />
      </div>
      <div class="form-group">
        <label for="phone" class="required">Phone Number:</label>
        <input type="tel" id="phone" v-model="phoneNumber" />
      </div>

      <div class="form-group">
        <label for="center-name">Link To Facebook</label>
        <input type="text" id="center-name" v-model="linkToFB" />
      </div>
      <div class="form-group">
        <label for="center-name">Link To Instagram</label>
        <input type="text" id="center-name" v-model="linkToInsta" />
      </div>
      <div class="form-group">
        <label for="center-name" class="required">Working Hours</label>
        <input type="text" id="center-name" v-model="workingHours" />
      </div>
      <h3 class="field-title">Facilities Avaialable</h3>
      <div
        v-for="(facility, index) in facilities"
        :key="index"
        class="field-group"
      >
        <h3>Facility {{ index + 1 }}</h3>
        <div class="form-group">
          <label for="dimensions">Facility Name</label>
          <input type="text" id="dimensions" v-model="facility.name" />
        </div>
        <div class="form-group">
          <label for="dimensions">Facility Description</label>
          <input type="text" id="dimensions" v-model="facility.decription" />
        </div>
        <button
          type="button"
          class="remove-field-button"
          @click="removeFacility(index)"
        >
          Remove Facility
        </button>
      </div>
      <button type="button" class="add-field-button" @click="addFacility">
        Add Facility
      </button>
      <h3 class="field-title">Fields</h3>
      <div v-for="(field, index) in fields" :key="index" class="field-group">
        <h3>Field {{ index + 1 }}</h3>
        <div class="form-group">
          <label for="dimensions">Dimensions:</label>
          <input type="text" id="dimensions" v-model="field.dimensions" />
        </div>

        <div class="form-group">
          <label for="field-number">Field Number:</label>
          <input type="text" id="field-number" v-model="field.fieldNumber" />
        </div>
        <div class="form-group">
          <label for="field-number">Field Length:</label>
          <input type="text" id="field-number" v-model="field.length" />
        </div>
        <div class="form-group">
          <label for="field-number">Field Width:</label>
          <input type="text" id="field-number" v-model="field.width" />
        </div>
        <div class="form-group">
          <label for="field-number">Reservation Price:</label>
          <input
            type="text"
            id="field-number"
            v-model="field.reservation_price"
          />
        </div>
        <div class="form-group">
          <label for="field-number">Grass Type:</label>
          <input type="text" id="field-number" v-model="field.grassType" />
        </div>
        <div class="form-group">
          <label for="field-number">Recommended Team Size:</label>
          <input
            type="text"
            id="field-number"
            v-model="field.recommendedTeamSize"
          />
        </div>

        <button
          type="button"
          class="remove-field-button"
          @click="removeField(index)"
        >
          Remove Field
        </button>
      </div>

      <button type="button" class="add-field-button" @click="addField">
        Add Field
      </button>

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
      locationLink: "",
      phoneNumber: "",
      linkToFB: "",
      linkToInsta: "",
      workingHours: "",
      fields: [
        {
          dimensions: "",
          fieldNumber: "",
          grassType: "",
          length: "",
          width: "",
          recommendedTeamSize: 0,
          reservation_price: 0,
        },
      ],
      facilities: [{ name: "", decription: "" }],
    };
  },
  methods: {
    addField() {
      this.fields.push({
        dimensions: "",
        fieldNumber: "",
      });
    },
    addFacility() {
      this.facilities.push({
        name: "",
        desciption: "",
      });
    },
    removeField(index) {
      this.fields.splice(index, 1);
    },
    removeFacility(index) {
      this.facilities.splice(index, 1);
    },
    submitForm() {
      // Do something with the form data, e.g. send it to the server
    },
  },
};
</script>

<style lang="scss" scoped>
.required:after {
  content: " *";
  color: red;
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

.add-field-button,
.remove-field-button {
  padding: 10px;
  border: none;
  border-radius: 5px;
  font-size: 16px;
  cursor: pointer;
}

.add-field-button {
  background-color: transparent;
  color: green;
  margin-bottom: 20px;
  transition: all 0.2s ease-in-out;
}

.add-field-button:hover {
  background-color: #2dce89;
  color: #fff;
}

.remove-field-button {
  background-color: #f5f5f5;
  color: #2dce89;
  transition: all 0.2s ease-in-out;
}

/* .remove-field-button:hover {
    background-color: #333;
    color: #fff;
  } */

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
