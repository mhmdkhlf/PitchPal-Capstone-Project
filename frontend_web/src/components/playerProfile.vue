<template>
  <link
    href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700"
    rel="stylesheet"
  />
  <!-- <logo /> -->
  <loader v-if="isLoading && !done" />
  <confirmPopup :Message="confirmationMessage" v-if="confirmationMessage" />
  <rate
    v-if="rate"
    :for="`player`"
    :ratingOne="rateOne"
    :ratingTwo="rateTwo"
    :text="reviewText"
    @done="getRateData"
  />
  <div
    class="body"
    v-if="done && !isLoading && !rate"
    :class="{ hidden: confirmationMessage || rate }"
  >
    <div class="main-content">
      <div class="container-fluid mt--7">
        <div class="row">
          <div class="col-xl-4 order-xl-2 mb-5 mb-xl-0">
            <div class="card card-profile shadow">
              <div class="row justify-content-center">
                <div class="col-lg-3 order-lg-2">
                  <div class="card-profile-image">
                    <a href="#">
                      <img
                        :src="src"
                        class="rounded-circle"
                        ref="image"
                        v-if="src"
                      />
                      <img
                        src="../assets/images/image.jpg"
                        class="rounded-circle"
                        ref="image"
                        v-if="!src"
                      />
                    </a>
                  </div>
                </div>
              </div>
              <div
                class="card-header text-center border-0 pt-8 pt-md-4 pb-0 pb-md-4"
              >
                <div class="d-flex justify-content-between">
                  <a
                    @click="followPlayer($event)"
                    class="btn btn-sm btn-info mr-4 common"
                    v-if="!isSelfVisit"
                    ref="connectBtn"
                    :disabled="isButtonDisabled"
                    >{{ buttonState }}</a
                  >
                  <a
                    href="#"
                    class="btn btn-sm btn-default float-right common"
                    v-if="!isSelfVisit"
                    @click="rateMethod()"
                    >Rate</a
                  >
                </div>
              </div>
              <div class="card-body pt-0 pt-md-4">
                <div class="row">
                  <div class="col">
                    <div
                      class="card-profile-stats d-flex justify-content-center mt-md-5"
                    >
                      <div>
                        <span class="heading">{{ numberOfFriends }}</span>
                        <span class="description">Friends</span>
                      </div>
                      <div>
                        <span class="heading">{{
                          playerInfo.averageMoralityRating
                        }}</span>
                        <span class="description">Morality Rating</span>
                      </div>
                      <div>
                        <span class="heading">{{
                          playerInfo.averageSkillRating
                        }}</span>
                        <span class="description">Skill Rating</span>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="text-center">
                  <h3>
                    {{ playerInfo.name
                    }}<span class="font-weight-light">, {{ Age }}</span>
                  </h3>
                  <div class="h5 font-weight-300">
                    <i class="ni location_pin mr-2"></i
                    >{{ playerInfo.location.place }}
                  </div>
                  <div>
                    <i class="ni education_hat mr-2"></i
                    >{{ playerInfo.position }}
                  </div>
                  <hr class="my-4" />
                  <p>
                    {{ playerInfo.description }}
                  </p>
                  <div class="flex-links">
                    <a @click="editProfile()" v-if="isSelfVisit"
                      >Edit Your Profile</a
                    >
                    <a @click="rmvPlayer()" id="rmv" v-if="isSelfVisit"
                      >Deactivate Your Account</a
                    >
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="col-xl-8 order-xl-1">
            <div class="card bg-secondary shadow">
              <div class="card-header bg-white border-0">
                <div class="row align-items-center">
                  <div class="col-8">
                    <h3 class="mb-0" v-if="isSelfVisit">My Account</h3>
                    <h3 class="mb-0" v-if="!isSelfVisit">User Account</h3>
                  </div>
                  <div class="col-4 text-right">
                    <h4 v-if="isSelfVisit">
                      Your ID: {{ playerInfo.playerID }}
                    </h4>
                    <h4 v-if="!isSelfVisit">
                      User ID: {{ playerInfo.playerID }}
                    </h4>
                  </div>
                </div>
              </div>
              <div class="card-body">
                <form>
                  <h6 class="heading-small text-muted mb-4">
                    User information
                  </h6>
                  <div class="pl-lg-4">
                    <div class="row">
                      <div class="col-lg-6">
                        <div class="form-group focused">
                          <label class="form-control-label" for="input-username"
                            >Name</label
                          >
                          <input
                            type="text"
                            id="input-username"
                            class="form-control form-control-alternative"
                            :value="playerInfo.name"
                            disabled
                          />
                        </div>
                      </div>
                      <div class="col-lg-6" v-if="Age">
                        <div class="form-group focused">
                          <label class="form-control-label" for="age"
                            >Age</label
                          >
                          <input
                            type="text"
                            id="age"
                            class="form-control form-control-alternative"
                            :value="Age"
                            disabled
                          />
                        </div>
                      </div>
                    </div>
                    <div class="row">
                      <div class="col-lg-6">
                        <div class="form-group focused">
                          <label class="form-control-label" for="sex"
                            >Sex</label
                          >
                          <input
                            type="text"
                            id="sex"
                            class="form-control form-control-alternative"
                            disabled
                            :value="playerInfo.sex"
                          />
                        </div>
                      </div>
                      <div class="col-lg-6">
                        <div class="form-group focused">
                          <label class="form-control-label" for="pos"
                            >Position</label
                          >
                          <input
                            type="text"
                            id="pos"
                            class="form-control form-control-alternative"
                            :value="playerInfo.position"
                            disabled
                          />
                        </div>
                      </div>
                    </div>
                    <div class="row">
                      <div class="col-lg-6" v-if="playerInfo.weight !== 0">
                        <div class="form-group focused">
                          <label class="form-control-label" for="weight"
                            >weight</label
                          >
                          <input
                            type="text"
                            id="weight"
                            class="form-control form-control-alternative"
                            disabled
                            :value="playerInfo.weight"
                          />
                        </div>
                      </div>
                      <div class="col-lg-6" v-if="playerInfo.height !== 0">
                        <div class="form-group focused">
                          <label class="form-control-label" for="height"
                            >Height</label
                          >
                          <input
                            type="text"
                            id="height"
                            class="form-control form-control-alternative"
                            :value="playerInfo.height"
                            disabled
                          />
                        </div>
                      </div>
                    </div>
                  </div>
                  <hr class="my-4" />
                  <!-- Address -->
                  <h6 class="heading-small text-muted mb-4">
                    Contact information
                  </h6>
                  <div class="pl-lg-4">
                    <div class="row">
                      <div class="col-md-12">
                        <div class="form-group focused">
                          <label class="form-control-label" for="input-address"
                            >Address</label
                          >
                          <input
                            id="input-address"
                            class="form-control form-control-alternative"
                            disabled
                            :value="playerInfo.location.place"
                            type="text"
                          />
                        </div>
                      </div>
                    </div>
                    <div class="row">
                      <div class="col-md-12">
                        <div class="form-group focused">
                          <label class="form-control-label" for="phoneNumber"
                            >PhoneNumber</label
                          >
                          <input
                            id="phoneNumber"
                            class="form-control form-control-alternative"
                            disabled
                            :value="playerInfo.phoneNumber"
                            type="text"
                          />
                        </div>
                      </div>
                    </div>
                    <div class="row">
                      <div class="col-md-12">
                        <div class="form-group">
                          <label class="form-control-label" for="input-email"
                            >Email address</label
                          >
                          <input
                            id="input-email"
                            type="email"
                            class="form-control form-control-alternative"
                            :value="playerInfo.email"
                            disabled
                          />
                        </div>
                      </div>
                    </div>
                  </div>

                  <!-- Description -->
                </form>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import axios from "axios";
import loader from "./loader.vue";
import confirmPopup from "./confirmationPopup.vue";
import { Buffer } from "buffer";
import rate from "./ratingPopup.vue";
const helpers = require("../../helpers/authentication.js");
export default {
  name: "playerProfileComponent",
  components: {
    loader,
    confirmPopup,
    rate,
  },
  data() {
    return {
      playerInfo: null,
      numberOfFriends: 0,
      done: false,
      isSelfVisit: this.$route.params.isSelfVisit === "true" ? true : false,
      src: "",
      playerdata: null,
      isConfirmed: false,
      confirmationMessage: null,
      buttonState: "Connect",
      isButtonDisabled: false,
      rate: false,
      rateData: null,
      rateOne: 0,
      rateTwo: 0,
      reviewText: "",
      firstRate: true,
      rateId: "",
    };
  },
  watch: {
    // whenever question changes, this function will run
    isConfirmed(newA) {
      if (newA) {
        this.remover();
      }
    },
  },
  methods: {
    async getRateData(done) {
      this.$store.dispatch("setLoading");
      this.rateData = done;
      console.log(done);
      let date = new Date();
      if (this.firstRate) {
        await axios.post(helpers.api + "newPlayerReview", {
          playerID: this.playerInfo.playerID,
          reviewerID: this.$store.state.playerInfo.playerID,
          moralityScore: {
            value: this.rateData.newRateTwo,
          },
          skillScore: {
            value: this.rateData.newRateOne,
          },
          commentText: this.rateData.text,
          submissionDate: date.toJSON(),
        });
        await axios.patch(
          helpers.api + "updatePlayerAverageRatingInCaseOfNewReview",
          {
            playerID: this.playerInfo.playerID,
            newSkillReviewValue: this.rateData.newRateOne,
            newMoralReviewValue: this.rateData.newRateTwo,
          }
        );
      } else {
        await axios.patch(helpers.api + "updateReview/" + this.rateId, {
          moralityScore: { value: this.rateData.newRateTwo },
          skillScore: { value: this.rateData.newRateOne },
          commentText: this.rateData.text,
          submissionDate: date.toJSON(),
        });
        await axios.patch(
          helpers.api + "updatePlayerAverageRatingInCaseOfNewEdit",
          {
            playerID: this.playerInfo.playerID,
            oldSkillReviewValue: this.rateOne,
            oldMoralReviewValue: this.rateTwo,
            newSkillReviewValue: this.rateData.newRateOne,
            newMoralReviewValue: this.rateData.newRateTwo,
          }
        );
      }
      this.rate = false;
      this.$forceUpdate();
      // this.$router.push(this.$router.currentRoute);
      this.$store.dispatch("stopLoading");
    },
    async followPlayer(e) {
      e.preventDefault();
      if (!this.isButtonDisabled) {
        this.$store.dispatch("setLoading");
        await axios.post(helpers.api + "addFriend", {
          playerID1: this.$store.state.playerInfo.playerID,
          playerID2: this.playerInfo.playerID,
        });
        this.buttonState = "connected";
        this.isButtonDisabled = true;
        this.$store.dispatch("stopLoading");
      }
    },
    editProfile() {
      this.$router.push({
        path: "/first-player-profile",
        query: {
          info: JSON.stringify({
            playerInfo: this.playerInfo,
          }),
        },
      });
    },
    rmvPlayer() {
      this.confirmationMessage = "Are you sure to de activate your Account?";
    },
    rateMethod() {
      this.rate = true;
    },
    async remover() {
      this.$store.dispatch("setLoading");
      if (this.isConfirmed) {
        await axios.delete(
          "http://localhost:5000/api/deleteUser/" +
            sessionStorage.getItem("user")
        );
        await axios.delete(
          "http://localhost:5000/api/deletePlayer/" +
            sessionStorage.getItem("user")
        );
        await axios.delete(
          "http://localhost:5000/api/deletePicture/" +
            sessionStorage.getItem("user")
        );
        this.$router.push("/login");
        this.$store.dispatch("stopLoading");
      }
    },
  },
  async mounted() {
    this.$store.dispatch("setLoading");
    if (!this.isSelfVisit) {
      let arefriends = await axios.post(helpers.api + "areFriends", {
        playerID1: this.$store.state.playerInfo.playerID,
        playerID2: this.$route.params.id,
      });
      if (arefriends.data.status) {
        this.buttonState = "Connected";
        this.isButtonDisabled = true;
      }
      let review = await axios.post(
        helpers.api + "getReviewByPlayerIdandReviewerId",
        {
          playerID: this.$route.params.id,
          reviewerID: this.$store.state.playerInfo.playerID,
        }
      );
      if (review.data) {
        this.rateOne = review.data.skillScore.value;
        this.rateTwo = review.data.moralityScore.value;
        this.reviewText = review.data.commentText;
        this.rateId = review.data._id;
        this.firstRate = false;
      }
    }
    let res = await helpers.isPlayerAuthenticated(this.$route.params.id);
    if (this.isSelfVisit) {
      if (!helpers.isLoggedIn() || !res) {
        this.$store.dispatch("stopLoading");
        this.$router.push("/login");
      }
    }

    axios
      .get("http://localhost:5000/api/getPlayer/" + this.$route.params.id)
      .then((res) => {
        this.playerInfo = res.data;
        axios
          .get(
            "http://localhost:5000/api/getProfilePictureByEmail/" +
              res.data.email
          )
          .then((res2) => {
            if (res2.data) {
              //no image
              this.src = `data:${
                res2.data.img.contentType
              };base64,${Buffer.from(res2.data.img.data, "utf-8").toString(
                "base64"
              )}`;
            }

            axios
              .get(
                "http://localhost:5000/api/getNumberOfFriends/" +
                  this.playerInfo.playerID
              )
              .then((res3) => {
                this.numberOfFriends = res3.data.numberOfFriends;

                this.done = true;

                this.$store.dispatch("stopLoading");
              });
          });
      });
  },

  computed: {
    Age() {
      if (this.playerInfo.dateOfBirth) {
        const dob = new Date(this.playerInfo.dateOfBirth);
        const ageInMs = Date.now() - dob.getTime();
        const ageInDate = new Date(ageInMs);
        return Math.abs(ageInDate.getUTCFullYear() - 1970).toString();
      }
      return null;
    },
    isLoading() {
      return this.$store.state.isLoading;
    },
  },
};
</script>
<style lang="scss" scoped>
* {
  color: #2dce89 !important;
}
.common {
  color: white !important;
}
#rmv {
  color: red !important;
}
.flex-links {
  display: flex;
  flex-direction: column;
  justify-content: center;
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
nav,
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

h1 {
  font-size: 1.625rem;
}

h3 {
  font-size: 1.0625rem;
}

h4 {
  font-size: 0.9375rem;
}

h5 {
  font-size: 0.8125rem;
}

h6 {
  font-size: 0.625rem;
}

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
  width: 100%;
  margin-right: auto;
  margin-left: auto;
  padding-right: 15px;
  padding-left: 15px;
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

.col {
  max-width: 100%;
  flex-basis: 0;
  flex-grow: 1;
}

.col-4 {
  max-width: 33.33333%;
  flex: 0 0 33.33333%;
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
  .col-lg-3 {
    max-width: 25%;
    flex: 0 0 25%;
  }

  .col-lg-6 {
    max-width: 50%;
    flex: 0 0 50%;
  }

  .order-lg-2 {
    order: 2;
  }
}

@media (min-width: 1200px) {
  .col-xl-4 {
    max-width: 33.33333%;
    flex: 0 0 33.33333%;
  }

  .col-xl-8 {
    max-width: 66.66667%;
    flex: 0 0 66.66667%;
  }

  .order-xl-1 {
    order: 1;
  }

  .order-xl-2 {
    order: 2;
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

.btn {
  font-size: 1rem;
  font-weight: 600;
  line-height: 1.5;
  display: inline-block;
  padding: 0.625rem 1.25rem;
  -webkit-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
  user-select: none;
  transition: color 0.15s ease-in-out, background-color 0.15s ease-in-out,
    border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
  text-align: center;
  vertical-align: middle;
  white-space: nowrap;
  border: 1px solid transparent;
  border-radius: 0.375rem;
}

@media screen and (prefers-reduced-motion: reduce) {
  .btn {
    transition: none;
  }
}

.btn:hover,
.btn:focus {
  text-decoration: none;
}

.btn:focus {
  outline: 0;
  box-shadow: 0 7px 14px rgba(50, 50, 93, 0.1), 0 3px 6px rgba(0, 0, 0, 0.08);
}

.btn:disabled {
  opacity: 0.65;
  box-shadow: none;
}

.btn:not(:disabled):not(.disabled) {
  cursor: pointer;
}

.btn:not(:disabled):not(.disabled):active {
  box-shadow: none;
}

.btn:not(:disabled):not(.disabled):active:focus {
  box-shadow: 0 7px 14px rgba(50, 50, 93, 0.1), 0 3px 6px rgba(0, 0, 0, 0.08),
    none;
}

.btn-info {
  color: #fff;
  border-color: #11cdef;
  background-color: #11cdef;
  box-shadow: 0 4px 6px rgba(50, 50, 93, 0.11), 0 1px 3px rgba(0, 0, 0, 0.08);
}

.btn-info:hover {
  color: #fff;
  border-color: #11cdef;
  background-color: #11cdef;
}

.btn-info:focus {
  box-shadow: 0 4px 6px rgba(50, 50, 93, 0.11), 0 1px 3px rgba(0, 0, 0, 0.08),
    0 0 0 0 rgba(17, 205, 239, 0.5);
}

.btn-info:disabled {
  color: #fff;
  border-color: #11cdef;
  background-color: #11cdef;
}

.btn-info:not(:disabled):not(.disabled):active {
  color: #fff;
  border-color: #11cdef;
  background-color: #0da5c0;
}

.btn-info:not(:disabled):not(.disabled):active:focus {
  box-shadow: none, 0 0 0 0 rgba(17, 205, 239, 0.5);
}

.btn-default {
  color: #fff;
  border-color: #172b4d;
  background-color: #172b4d;
  box-shadow: 0 4px 6px rgba(50, 50, 93, 0.11), 0 1px 3px rgba(0, 0, 0, 0.08);
}

.btn-default:hover {
  color: #fff;
  border-color: #172b4d;
  background-color: #172b4d;
}

.btn-default:focus {
  box-shadow: 0 4px 6px rgba(50, 50, 93, 0.11), 0 1px 3px rgba(0, 0, 0, 0.08),
    0 0 0 0 rgba(23, 43, 77, 0.5);
}

.btn-default:disabled {
  color: #fff;
  border-color: #172b4d;
  background-color: #172b4d;
}

.btn-default:not(:disabled):not(.disabled):active {
  color: #fff;
  border-color: #172b4d;
  background-color: #0b1526;
}

.btn-default:not(:disabled):not(.disabled):active:focus {
  box-shadow: none, 0 0 0 0 rgba(23, 43, 77, 0.5);
}

.btn-sm {
  font-size: 0.875rem;
  line-height: 1.5;
  padding: 0.25rem 0.5rem;
  border-radius: 0.375rem;
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

.bg-secondary {
  background-color: #f7fafc !important;
}

a.bg-secondary:hover,
a.bg-secondary:focus,
button.bg-secondary:hover,
button.bg-secondary:focus {
  background-color: #d2e3ee !important;
}

.bg-white {
  background-color: #fff !important;
}

a.bg-white:hover,
a.bg-white:focus,
button.bg-white:hover,
button.bg-white:focus {
  background-color: #e6e6e6 !important;
}

.bg-white {
  background-color: #fff !important;
}

.border-0 {
  border: 0 !important;
}

.rounded-circle {
  border-radius: 50% !important;
}

.d-flex {
  display: flex !important;
}

.justify-content-center {
  justify-content: center !important;
}

.justify-content-between {
  justify-content: space-between !important;
}

.align-items-center {
  align-items: center !important;
}

@media (min-width: 1200px) {
  .justify-content-xl-between {
    justify-content: space-between !important;
  }
}

.float-right {
  float: right !important;
}

.shadow,
.card-profile-image img {
  box-shadow: 0 0 2rem 0 rgba(136, 152, 170, 0.15) !important;
}
.card-profile-image img {
  height: 185px !important;
}

.mb-0 {
  margin-bottom: 0 !important;
}

.mr-2 {
  margin-right: 0.5rem !important;
}

.mt-4,
.my-4 {
  margin-top: 1.5rem !important;
}

.mr-4 {
  margin-right: 1.5rem !important;
}

.mb-4,
.my-4 {
  margin-bottom: 1.5rem !important;
}

.mb-5 {
  margin-bottom: 3rem !important;
}

.mt--7 {
  margin-top: 3.5rem !important;
}

.pt-0 {
  padding-top: 0 !important;
}

.pb-0 {
  padding-bottom: 0 !important;
}

.pt-8 {
  padding-top: 8rem !important;
}

@media (min-width: 768px) {
  .mt-md-5 {
    margin-top: 3rem !important;
  }

  .pt-md-4 {
    padding-top: 1.5rem !important;
  }

  .pb-md-4 {
    padding-bottom: 1.5rem !important;
  }
}

@media (min-width: 992px) {
  .pl-lg-4 {
    padding-left: 1.5rem !important;
  }
}

@media (min-width: 1200px) {
  .mb-xl-0 {
    margin-bottom: 0 !important;
  }
}

.text-right {
  text-align: right !important;
}

.text-center {
  text-align: center !important;
}

.font-weight-light {
  font-weight: 300 !important;
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

.bg-white {
  background-color: #fff !important;
}

a.bg-white:hover,
a.bg-white:focus,
button.bg-white:hover,
button.bg-white:focus {
  background-color: #e6e6e6 !important;
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

.font-weight-300 {
  font-weight: 300 !important;
}

.btn {
  font-size: 0.875rem;
  position: relative;
  transition: all 0.15s ease;
  letter-spacing: 0.025em;
  text-transform: none;
  will-change: transform;
}

.btn:hover {
  transform: translateY(-1px);
  box-shadow: 0 7px 14px rgba(50, 50, 93, 0.1), 0 3px 6px rgba(0, 0, 0, 0.08);
}

.btn:not(:last-child) {
  margin-right: 0.5rem;
}

.btn i:not(:first-child) {
  margin-left: 0.5rem;
}

.btn i:not(:last-child) {
  margin-right: 0.5rem;
}

.btn-sm {
  font-size: 0.75rem;
}

[class*="btn-outline-"] {
  border-width: 1px;
}
.hidden {
  opacity: 0.07;
}
.card-profile-image {
  position: relative;
}

.card-profile-image img {
  position: absolute;
  left: 50%;
  max-width: 180px;
  transition: all 0.15s ease;
  transform: translate(-50%, -30%);
  border-radius: 0.375rem;
}

.card-profile-image img:hover {
  transform: translate(-50%, -33%);
}

.card-profile-stats {
  padding: 1rem 0;
}

.card-profile-stats > div {
  margin-right: 1rem;
  padding: 0.875rem;
  text-align: center;
}

.card-profile-stats > div:last-child {
  margin-right: 0;
}

.card-profile-stats > div .heading {
  font-size: 1.1rem;
  font-weight: bold;
  display: block;
}

.card-profile-stats > div .description {
  font-size: 0.875rem;
  color: #adb5bd;
}

.main-content {
  position: relative;
}

.main-content .navbar-top {
  position: absolute;
  z-index: 1;
  top: 0;
  left: 0;
  width: 100%;
  padding-right: 0 !important;
  padding-left: 0 !important;
  background-color: transparent;
}

@media (min-width: 768px) {
  .main-content .container-fluid {
    padding-right: 39px !important;
    padding-left: 39px !important;
  }
}

.footer {
  padding: 2.5rem 0;
  background: #f7fafc;
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

.focused .input-group-alternative {
  box-shadow: 0 4px 6px rgba(50, 50, 93, 0.11), 0 1px 3px rgba(0, 0, 0, 0.08) !important;
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

.description {
  font-size: 0.875rem;
}

.heading {
  font-size: 0.95rem;
  font-weight: 600;
  letter-spacing: 0.025em;
  text-transform: uppercase;
}

.heading-small {
  font-size: 0.75rem;
  padding-top: 0.25rem;
  padding-bottom: 0.25rem;
  letter-spacing: 0.04em;
  text-transform: uppercase;
}

@media (max-width: 768px) {
  .btn {
    margin-bottom: 10px;
  }
}
</style>
