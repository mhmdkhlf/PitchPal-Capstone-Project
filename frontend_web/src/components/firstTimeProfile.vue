<template>
  <link
    href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700"
    rel="stylesheet"
  />
  <!-- <logo /> -->
  <errorPopUp v-if="error" :errorMessage="error" />
  <loader v-if="isLoading && !error" />
  <div class="body" v-if="!isLoading && done" :class="{ hidden: error }">
    <div class="main-content">
      <div class="container-fluid">
        <div class="row">
          <div class="card-body">
            <form>
              <h6 class="heading-small text-muted header-nav">
                User information
              </h6>
              <div class="pl-lg-4">
                <div class="row pf">
                  <div class="col-lg-6">
                    <div class="form-group focused">
                      <label class="form-control-label">Profile Picture</label>
                      <profilePicture
                        @pictureUploaded="getImage"
                        v-if="!name"
                      />
                      <profilePicture
                        :editvalue="imgEditValue"
                        @pictureUploaded="getImage"
                        v-else
                      />
                      <h4
                        v-if="imgEditValue"
                        class="rmv-image"
                        @click="rmvProfile()"
                      >
                        Remove Profile Picture
                      </h4>
                    </div>
                  </div>
                </div>
                <div class="row">
                  <div class="col-lg-6">
                    <div class="form-group focused">
                      <label
                        class="form-control-label required"
                        for="input-username"
                        >Name</label
                      >
                      <input
                        type="text"
                        id="input-username"
                        class="form-control form-control-alternative"
                        v-model="name"
                        required
                      />
                    </div>
                  </div>
                  <div class="col-lg-6">
                    <div class="form-group">
                      <label
                        class="form-control-label required"
                        for="input-email"
                        >Email address</label
                      >
                      <input
                        type="email"
                        id="input-email"
                        class="form-control form-control-alternative"
                        v-model="email"
                        required
                        :disabled="this.$store.state.playerInfo"
                      />
                    </div>
                  </div>
                </div>

                <div class="row">
                  <div class="col-lg-6">
                    <div class="form-group focused">
                      <label class="form-control-label" for="input-first-name"
                        >Date Of Birth</label
                      >
                      <input
                        type="date"
                        id="input-first-name"
                        class="form-control form-control-alternative"
                        v-model="dateOfBirth"
                      />
                    </div>
                  </div>
                  <div class="col-lg-6">
                    <div class="form-group focused">
                      <label
                        class="form-control-label required"
                        for="input-last-name"
                        >Sex</label
                      >
                      <select
                        name="sex"
                        required
                        v-model="sex"
                        class="form-control form-control-alternative"
                      >
                        <option value="">Sex</option>
                        <option value="M">Male</option>
                        <option value="F">FeMale</option>
                      </select>
                    </div>
                  </div>
                </div>
                <div class="row">
                  <div class="col-lg-6">
                    <div class="form-group focused">
                      <label
                        class="form-control-label required"
                        for="input-first-name"
                        >Position</label
                      >
                      <select
                        name="position"
                        required
                        v-model="position"
                        class="form-control form-control-alternative"
                      >
                        <option value="">position</option>
                        <option value="attacker">Attacker</option>
                        <option value="defender">Defender</option>
                        <option value="goal keeper">goal keeper</option>
                        <option value="midfielder">midfielder</option>
                      </select>
                    </div>
                  </div>
                  <div class="col-lg-6">
                    <div class="form-group focused">
                      <label class="form-control-label" for="input-first-name"
                        >Weight</label
                      >
                      <input
                        type="text"
                        id="input-first-name"
                        class="form-control form-control-alternative"
                        v-model="weight"
                      />
                    </div>
                  </div>
                </div>
                <div class="row">
                  <div class="col-lg-6">
                    <div class="form-group focused">
                      <label class="form-control-label" for="input-last-name"
                        >Height</label
                      >
                      <input
                        type="text"
                        id="input-last-name"
                        class="form-control form-control-alternative"
                        v-model="height"
                      />
                    </div>
                  </div>
                </div>
              </div>
              <hr class="my-4" />
              <!-- Address -->
              <h6 class="heading-small text-muted mb-4">Contact information</h6>
              <div class="pl-lg-4">
                <div class="row">
                  <div class="col-md-12">
                    <div class="form-group focused">
                      <label
                        class="form-control-label required block"
                        for="input-address"
                        >Address</label
                      >
                      <div class="flex-address">
                        <button
                          class="btn address-btn"
                          @click="getLocation($event)"
                        >
                          Get My Location
                        </button>
                        <textLoader v-if="locationLoader && !this.address" />
                        <p
                          class="adress-result"
                          v-if="!locationLoader && this.address"
                        >
                          {{ address }}
                        </p>
                      </div>

                      <!-- <input
                        id="input-address"
                        class="form-control form-control-alternative"
                        v-model="location"
                        type="text"
                        required
                      /> -->
                    </div>
                  </div>
                </div>
                <div class="row">
                  <div class="col-md-12">
                    <div class="form-group focused">
                      <label
                        class="form-control-label required"
                        for="input-address"
                        >Phone Number</label
                      >
                      <input
                        id="input-address"
                        class="form-control form-control-alternative"
                        v-model="phoneNumber"
                        type="text"
                        required
                      />
                    </div>
                  </div>
                </div>
              </div>
              <hr class="my-4" />
              <!-- Description -->
              <h6 class="heading-small text-muted mb-4">About me</h6>
              <div class="pl-lg-4">
                <div class="form-group focused">
                  <label>About Me</label>
                  <textarea
                    rows="4"
                    class="form-control form-control-alternative"
                    v-model="description"
                  >
  A beautiful Dashboard for Bootstrap 4. It is Free and Open Source.</textarea
                  >
                </div>
              </div>
              <button
                v-if="!this.$store.state.playerInfo"
                class="continue-button"
                type="submit"
                @click="createPlayer($event)"
              >
                Contniue
              </button>
              <button
                v-if="this.$store.state.playerInfo"
                class="continue-button"
                type="submit"
                @click="updatePlayer($event)"
              >
                Update
              </button>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import profilePicture from "./profilePicture.vue";
import textLoader from "./loaderText.vue";
import errorPopUp from "./errorPopup.vue";
import { Buffer } from "buffer";
import loader from "./loader.vue";
import axios from "axios";
const helpers = require("../../helpers/authentication.js");
export default {
  name: "FirstprofileComponent",
  //props: ["test"],
  components: {
    profilePicture,
    textLoader,
    loader,
    errorPopUp,
  },
  data() {
    return {
      name: this.$store.state.playerInfo
        ? this.$store.state.playerInfo.name
        : "",
      email: sessionStorage.getItem("user")
        ? sessionStorage.getItem("user")
        : "",
      phoneNumber: this.$store.state.playerInfo
        ? this.$store.state.playerInfo.phoneNumber
        : "",
      location: this.$store.state.playerInfo
        ? this.$store.state.playerInfo.location
        : null,
      dateOfBirth: this.$store.state.playerInfo
        ? this.$store.state.playerInfo.dateOfBirth.substring(0, 10)
        : "",
      height: this.$store.state.playerInfo
        ? this.$store.state.playerInfo.height
        : 0,
      weight: this.$store.state.playerInfo
        ? this.$store.state.playerInfo.weight
        : 0,
      sex: this.$store.state.playerInfo
        ? this.$store.state.playerInfo.sex
        : "M",
      position: this.$store.state.playerInfo
        ? this.$store.state.playerInfo.position
        : "",
      description: this.$store.state.playerInfo
        ? this.$store.state.playerInfo.description
        : "",
      locationLoader: false,
      address: this.$store.state.playerInfo
        ? this.$store.state.playerInfo.location.place
        : "",
      error: null,
      image: null,
      done: false,
      imgEditValue: "",
      rmvPicture: false,
    };
  },
  watch: {
    // whenever question changes, this function will run
    image() {
      this.imgEditValue = null;
    },
  },
  computed: {
    isLoading() {
      return this.$store.state.isLoading;
    },
  },
  async mounted() {
    this.$store.dispatch("setLoading");
    if (this.$store.state.playerInfo) {
      axios
        .get(helpers.api + "getProfilePictureByEmail/" + this.email)
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
      this.done = true;
      this.$store.dispatch("stopLoading");
    }
  },
  //should take email as prop or access it from session
  methods: {
    getImage(value) {
      this.image = value;
    },
    rmvProfile() {
      this.imgEditValue = null;
      this.rmvPicture = true;
    },
    getLocation(e) {
      e.preventDefault();
      if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(
          (position) => {
            this.locationLoader = true;
            let { latitude, longitude } = position.coords;
            fetch(
              `https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=${latitude}&longitude=${longitude}&localityLanguage=en`
            )
              .then((response) => response.json())
              .then((response) => {
                let { countryName, city, locality } = response;
                this.address = `${locality}, ${city}, ${countryName}`;
                this.location = {
                  longitude,
                  latitude,
                  place: this.address,
                };
                this.locationLoader = false;
              })
              .catch(() => {
                this.locationLoader = false;
                this.address = "Something went wrong";
              });
          },
          (error) => {
            if (error.code == 1) {
              this.locationLoader = false;
              this.address = "You denied the request";
            } else if (error.code == 2) {
              this.locationLoader = false;
              this.address = "Location is unavailable";
            } else {
              this.locationLoader = false;
              this.address = "Something went wrong";
            }
            //button.setAttribute("disabled", "true");
          }
        );
      } else {
        this.locationLoader = false;
        this.address = "Your browser not support";
      }
    },

    createPlayer(e) {
      e.preventDefault();
      this.$store.dispatch("setLoading");
      let {
        name,
        email,
        phoneNumber,
        location,
        dateOfBirth,
        height,
        weight,
        sex,
        position,
        description,
      } = this;
      if (
        !name ||
        !email ||
        !phoneNumber ||
        !location ||
        !dateOfBirth ||
        !sex ||
        !position
      ) {
        this.error = "All Required fields must be filled";
        this.$store.dispatch("stopLoading");
      } else {
        axios
          .post("http://localhost:5000/api/newPlayerProfile", {
            name,
            email,
            phoneNumber,
            location,
            dateOfBirth,
            height,
            weight,
            sex,
            position,
            description,
          })
          .then(
            (res) => {
              if (res.status === 200) {
                this.$store.dispatch("setPlayerInfo", res.data);
                sessionStorage.setItem("playerInfo", JSON.stringify(res.data));
                var bodyFormData = new FormData();
                if (this.image) {
                  bodyFormData.append("image", this.image);
                  bodyFormData.append("email", email);
                  axios({
                    url: "http://localhost:5000/api/uploadPicture",
                    method: "POST",
                    data: bodyFormData,
                  });
                }

                this.$store.dispatch("stopLoading");
                this.$router.push("/");
              }
            },
            (err) => {
              this.$store.dispatch("stopLoading");
              this.error = err.response.data.message;
            }
          );
      }
    },
    updatePlayer(e) {
      e.preventDefault();
      this.$store.dispatch("setLoading");
      let {
        name,
        email,
        phoneNumber,
        location,
        dateOfBirth,
        height,
        weight,
        sex,
        position,
        description,
      } = this;
      if (
        !name ||
        !email ||
        !phoneNumber ||
        !location ||
        !dateOfBirth ||
        !sex ||
        !position
      ) {
        this.error = "All Required fields must be filled";
        this.$store.dispatch("stopLoading");
      } else {
        axios
          .patch(
            "http://localhost:5000/api/updatePlayerInformation/" +
              this.$store.state.playerInfo._id,
            {
              name,
              phoneNumber,
              location,
              dateOfBirth,
              height,
              weight,
              sex,
              position,
              description,
            }
          )
          .then(
            (res) => {
              if (res.status === 200) {
                this.$store.dispatch("setPlayerInfo", res.data);
                sessionStorage.setItem("playerInfo", JSON.stringify(res.data));
                var bodyFormData = new FormData();
                if (this.image) {
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
                this.$router.push("/");
              }
            },
            (err) => {
              this.$store.dispatch("stopLoading");
              this.error = err.response.data.message;
            }
          );
      }
    },
  },
};
</script>
<style lang="css" scoped>
.continue-button {
  position: absolute;
  bottom: 1rem;
  right: 0;
  margin-top: 10px;
  margin-right: 10px;
  border: #2dce89;
  height: 40px;
  border-radius: 30%;
}
.flex-address {
  display: flex;
  justify-content: space-around;
  align-items: center;
}
.hidden {
  opacity: 0.07;
}
:root {
  --blue: #5e72e4;
  --indigo: #5603ad;
  --purple: #8965e0;
  --pink: #f3a4b5;
  --red: #f5365c;
  --orange: #fb6340;
  --yellow: #ffd600;
  --green: #2dce89;
  --teal: #11cdef;
  --cyan: #2bffc6;
  --white: #fff;
  --gray: #8898aa;
  --gray-dark: #32325d;
  --light: #ced4da;
  --lighter: #e9ecef;
  --primary: #5e72e4;
  --secondary: #f7fafc;
  --success: #2dce89;
  --info: #11cdef;
  --warning: #fb6340;
  --danger: #f5365c;
  --light: #adb5bd;
  --dark: #212529;
  --default: #172b4d;
  --white: #fff;
  --neutral: #fff;
  --darker: black;
  --breakpoint-xs: 0;
  --breakpoint-sm: 576px;
  --breakpoint-md: 768px;
  --breakpoint-lg: 992px;
  --breakpoint-xl: 1200px;
  --font-family-sans-serif: Open Sans, sans-serif;
  --font-family-monospace: SFMono-Regular, Menlo, Monaco, Consolas,
    "Liberation Mono", "Courier New", monospace;
}
*,
*::before,
*::after {
  box-sizing: border-box;
}
* {
  color: #0a870ac7 !important;
}
.address-btn {
  /* margin-top: 10px;
  margin-right: 10px; */
  border: #2dce89;
  height: 40px;
  border-radius: 30%;
}
.header-nav {
  margin-bottom: 16px !important;
  margin-left: 0 !important;
  margin-right: 0 !important;
  margin-top: 0 !important;
}
.block {
  display: block !important;
}
.required:after {
  content: " *";
  color: red;
}
.pf {
  height: auto;
  margin: 0 auto;
  position: relative;
}
.rmv-image {
  text-align: center;
  margin: 0 !important;
  color: red !important;
  cursor: pointer;
}
html {
  font-family: sans-serif;
  line-height: 1.15;
  -webkit-text-size-adjust: 100%;
  -ms-text-size-adjust: 100%;
  -ms-overflow-style: scrollbar;
  -webkit-tap-highlight-color: rgba(0, 0, 0, 0);
}
@-ms-viewport {
  width: device-width;
}
figcaption,
footer,
header,
main,
section {
  display: block;
}
.body {
  font-family: Open Sans, sans-serif;
  font-size: 1rem;
  font-weight: 400;
  line-height: 1.5;
  margin: 0;
  text-align: left;
  color: #525f7f;
  background-color: #f8f9fe;
  overflow-x: hidden !important;
}
[tabindex="-1"]:focus {
  outline: 0 !important;
}
hr {
  overflow: visible;
  box-sizing: content-box;
  height: 0;
}
h1,
h3,
h4,
h5,
h6 {
  margin-top: 0;
  margin-bottom: 0.5rem;
}
p {
  margin-top: 0;
  margin-bottom: 1rem;
}
address {
  font-style: normal;
  line-height: inherit;
  margin-bottom: 1rem;
}
ul {
  margin-top: 0;
  margin-bottom: 1rem;
}
ul ul {
  margin-bottom: 0;
}
dfn {
  font-style: italic;
}
strong {
  font-weight: bolder;
}
a {
  text-decoration: none;
  color: #5e72e4;
  background-color: transparent;
  -webkit-text-decoration-skip: objects;
}
a:hover {
  text-decoration: none;
  color: #233dd2;
}
a:not([href]):not([tabindex]) {
  text-decoration: none;
  color: inherit;
}
a:not([href]):not([tabindex]):hover,
a:not([href]):not([tabindex]):focus {
  text-decoration: none;
  color: inherit;
}
a:not([href]):not([tabindex]):focus {
  outline: 0;
}
code {
  font-family: SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono",
    "Courier New", monospace;
  font-size: 1em;
}
img {
  vertical-align: middle;
  border-style: none;
}
caption {
  padding-top: 1rem;
  padding-bottom: 1rem;
  caption-side: bottom;
  text-align: left;
  color: #8898aa;
}
label {
  display: inline-block;
  margin-bottom: 0.5rem;
}
button {
  border-radius: 0;
}
button:focus {
  outline: 1px dotted;
  outline: 5px auto -webkit-focus-ring-color;
}
input,
button,
textarea {
  font-family: inherit;
  font-size: inherit;
  line-height: inherit;
  margin: 0;
}
button,
input {
  overflow: visible;
}
button {
  text-transform: none;
}
button,
html [type="button"],
[type="reset"],
[type="submit"] {
  -webkit-appearance: button;
}
button::-moz-focus-inner,
[type="button"]::-moz-focus-inner,
[type="reset"]::-moz-focus-inner,
[type="submit"]::-moz-focus-inner {
  padding: 0;
  border-style: none;
}
input[type="radio"],
input[type="checkbox"] {
  box-sizing: border-box;
  padding: 0;
}
input[type="date"],
input[type="time"],
input[type="datetime-local"],
input[type="month"] {
  -webkit-appearance: listbox;
}
textarea {
  overflow: auto;
  resize: vertical;
}
legend {
  font-size: 1.5rem;
  line-height: inherit;
  display: block;
  width: 100%;
  max-width: 100%;
  margin-bottom: 0.5rem;
  padding: 0;
  white-space: normal;
  color: inherit;
}
progress {
  vertical-align: baseline;
}
[type="number"]::-webkit-inner-spin-button,
[type="number"]::-webkit-outer-spin-button {
  height: auto;
}
[type="search"] {
  outline-offset: -2px;
  -webkit-appearance: none;
}
[type="search"]::-webkit-search-cancel-button,
[type="search"]::-webkit-search-decoration {
  -webkit-appearance: none;
}
::-webkit-file-upload-button {
  font: inherit;
  -webkit-appearance: button;
}
[hidden] {
  display: none !important;
}
h1,
h3,
h4,
h5,
h6 {
  font-family: inherit;
  font-weight: 600;
  line-height: 1.5;
  margin-bottom: 0.5rem;
  color: #32325d;
}
h1,
h3,
h5,
h6,
hr {
  margin-top: 2rem;
  margin-bottom: 2rem;
  border: 0;
  border-top: 1px solid rgba(0, 0, 0, 0.1);
}
code {
  font-size: 87.5%;
  word-break: break-word;
  color: #f3a4b5;
}
a > code {
  color: inherit;
}
.container-fluid {
  height: 100% !important;
  width: 100%;
  margin-right: auto;
  margin-left: auto;
  /* padding-right: 15px;
  padding-left: 15px; */
}
.row {
  display: flex;
  margin-right: -15px;
  margin-left: -15px;
  flex-wrap: wrap;
}
.col-4,
.col-8,
.col,
.col-md-10,
.col-md-12,
.col-lg-3,
.col-lg-4,
.col-lg-6,
.col-lg-7,
.col-xl-4,
.col-xl-6,
.col-xl-8 {
  position: relative;
  width: 100%;
  min-height: 1px;
  padding-right: 15px;
  padding-left: 15px;
}
.col-8 {
  max-width: 66.66667%;
  flex: 0 0 66.66667%;
}
@media (min-width: 768px) {
  .col-md-12 {
    max-width: 100%;
    flex: 0 0 100%;
  }
}
@media (min-width: 992px) {
  .col-lg-6 {
    max-width: 50%;
    flex: 0 0 50%;
  }
}
@media (min-width: 1200px) {
  .order-xl-1 {
    order: 1;
  }
}
.form-control {
  font-size: 1rem;
  line-height: 1.5;
  display: block;
  width: 100%;
  height: calc(2.75rem + 2px);
  padding: 0.625rem 0.75rem;
  transition: all 0.2s cubic-bezier(0.68, -0.55, 0.265, 1.55);
  color: #8898aa;
  border: 1px solid #cad1d7;
  border-radius: 0.375rem;
  background-color: #fff;
  background-clip: padding-box;
  box-shadow: none;
}
@media screen and (prefers-reduced-motion: reduce) {
  .form-control {
    transition: none;
  }
}
.form-control::-ms-expand {
  border: 0;
  background-color: transparent;
}
.form-control:focus {
  color: #8898aa;
  border-color: rgba(50, 151, 211, 0.25);
  outline: 0;
  background-color: #fff;
  box-shadow: none, none;
}
.form-control:-ms-input-placeholder {
  opacity: 1;
  color: #adb5bd;
}
.form-control::-ms-input-placeholder {
  opacity: 1;
  color: #adb5bd;
}
.form-control::placeholder {
  opacity: 1;
  color: #adb5bd;
}
.form-control:disabled,
.form-control[readonly] {
  opacity: 1;
  background-color: #e9ecef;
}
textarea.form-control {
  height: auto;
}
.form-group {
  margin-bottom: 1.5rem;
}
.card {
  position: relative;
  display: flex;
  flex-direction: column;
  min-width: 0;
  word-wrap: break-word;
  border: 1px solid rgba(0, 0, 0, 0.05);
  border-radius: 0.375rem;
  background-color: #fff;
  background-clip: border-box;
}
.card > hr {
  margin-right: 0;
  margin-left: 0;
}
.card-body {
  padding: 1.5rem;
  margin-bottom: 2.5rem;
  flex: 1 1 auto;
}
.card-header {
  margin-bottom: 0;
  padding: 1.25rem 1.5rem;
  border-bottom: 1px solid rgba(0, 0, 0, 0.05);
  background-color: #fff;
}
.card-header:first-child {
  border-radius: calc(0.375rem - 1px) calc(0.375rem - 1px) 0 0;
}
@keyframes progress-bar-stripes {
  from {
    background-position: 1rem 0;
  }
  to {
    background-position: 0 0;
  }
}

.mt-4,
.my-4 {
  margin-top: 1.5rem !important;
}
.mb-4,
.my-4 {
  margin-bottom: 1.5rem !important;
}
@media (min-width: 992px) {
  .pl-lg-4 {
    padding-left: 1.5rem !important;
  }
}
.text-muted {
  color: #8898aa !important;
}
@media print {
  *,
  *::before,
  *::after {
    box-shadow: none !important;
    text-shadow: none !important;
  }
  a:not(.btn) {
    text-decoration: underline;
  }
  img {
    page-break-inside: avoid;
  }
  p,
  h3 {
    orphans: 3;
    widows: 3;
  }
  h3 {
    page-break-after: avoid;
  }
  .body {
    min-width: 992px !important;
  }
}
figcaption,
main {
  display: block;
}
main {
  overflow: hidden;
}

@keyframes floating-lg {
  0% {
    transform: translateY(0px);
  }
  50% {
    transform: translateY(15px);
  }
  100% {
    transform: translateY(0px);
  }
}
@keyframes floating {
  0% {
    transform: translateY(0px);
  }
  50% {
    transform: translateY(10px);
  }
  100% {
    transform: translateY(0px);
  }
}
@keyframes floating-sm {
  0% {
    transform: translateY(0px);
  }
  50% {
    transform: translateY(5px);
  }
  100% {
    transform: translateY(0px);
  }
}
[class*="shadow"] {
  transition: all 0.15s ease;
}
[class*="btn-outline-"] {
  border-width: 1px;
}
.main-content {
  position: relative;
  height: 100% !important;
}
.form-control-label {
  font-size: 0.875rem;
  font-weight: 600;
  color: #525f7f;
}
.form-control {
  font-size: 0.875rem;
}
.form-control:focus:-ms-input-placeholder {
  color: #adb5bd;
}
.form-control:focus::-ms-input-placeholder {
  color: #adb5bd;
}
.form-control:focus::placeholder {
  color: #adb5bd;
}
textarea[resize="none"] {
  resize: none !important;
}
textarea[resize="both"] {
  resize: both !important;
}
textarea[resize="vertical"] {
  resize: vertical !important;
}
textarea[resize="horizontal"] {
  resize: horizontal !important;
}
.form-control-alternative {
  transition: box-shadow 0.15s ease;
  border: 0;
  box-shadow: 0 1px 3px rgba(50, 50, 93, 0.15), 0 1px 0 rgba(0, 0, 0, 0.02);
}
.form-control-alternative:focus {
  box-shadow: 0 4px 6px rgba(50, 50, 93, 0.11), 0 1px 3px rgba(0, 0, 0, 0.08);
}
.focused .form-control {
  border-color: rgba(50, 151, 211, 0.25);
}
.focused .form-control {
  border-color: rgba(50, 151, 211, 0.25);
}
@keyframes show-navbar-collapse {
  0% {
    transform: scale(0.95);
    transform-origin: 100% 0;
    opacity: 0;
  }
  100% {
    transform: scale(1);
    opacity: 1;
  }
}
@keyframes hide-navbar-collapse {
  from {
    transform: scale(1);
    transform-origin: 100% 0;
    opacity: 1;
  }
  to {
    transform: scale(0.95);
    opacity: 0;
  }
}
p {
  font-size: 1rem;
  font-weight: 300;
  line-height: 1.7;
}
.heading-small {
  font-size: 0.75rem;
  /* padding-top: 0.25rem;
  padding-bottom: 0.25rem; */
  letter-spacing: 0.04em;
  text-transform: uppercase;
}
</style>
