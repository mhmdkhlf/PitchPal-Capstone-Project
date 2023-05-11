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
    :for="`sportCenter`"
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
                        src="../assets/images/background.jpg"
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
                    href="#"
                    class="btn btn-sm btn-info mr-4 common"
                    v-if="!isManager"
                    >Play</a
                  >
                  <a
                    href="#"
                    class="btn btn-sm btn-info float-right common"
                    v-if="!isManager"
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
                      <!-- <div>
                        <span class="heading">{{ numberOfFriends }}</span>
                        <span class="description">Friends</span>
                      </div> -->
                      <div>
                        <span class="heading">{{
                          sportCenterInfo.staffServiceAverageRating
                        }}</span>
                        <span class="description">Staff Rating</span>
                      </div>
                      <div>
                        <span class="heading">{{
                          sportCenterInfo.facilityQualityAverageRating
                        }}</span>
                        <span class="description">Facilities Rating</span>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="text-center">
                  <h3>
                    {{ sportCenterInfo.name }}
                  </h3>
                  <div class="h5 font-weight-300">
                    <i class="ni location_pin mr-2"></i
                    >{{ sportCenterInfo.location.place }}
                  </div>
                  <hr class="my-4" />
                  <!-- <p>
                    {{ sportCenterInfo.description }}
                  </p> -->
                  <div class="flex-links">
                    <a @click="editSportCenter()" v-if="isManager"
                      >Edit Sport Center</a
                    >
                    <a @click="rmvSportCenter()" id="rmv" v-if="isManager"
                      >Remove Sport Center</a
                    >
                  </div>
                  <hr class="my-4" v-if="isManager" />
                  <div class="reviews-comments">
                    <h4>Sport Center Reviews</h4>

                    <viewReviews :reviews="reviews" />
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
                    <h3 class="mb-0">Sport Center Information</h3>
                  </div>
                </div>
              </div>
              <div class="card-body">
                <form>
                  <h6 class="heading-small text-muted mb-4">
                    General Information
                  </h6>
                  <div class="pl-lg-4">
                    <div class="row">
                      <div class="col-md-12">
                        <div class="form-group focused">
                          <label class="form-control-label" for="input-username"
                            >Name</label
                          >
                          <input
                            type="text"
                            id="input-username"
                            class="form-control form-control-alternative"
                            :value="sportCenterInfo.name"
                            disabled
                          />
                        </div>
                      </div>
                      <div class="col-md-12">
                        <div class="form-group focused">
                          <label class="form-control-label" for="input-username"
                            >Working Hours</label
                          >
                          <input
                            type="text"
                            id="input-username"
                            class="form-control form-control-alternative"
                            :value="workingHours"
                            disabled
                          />
                        </div>
                      </div>
                    </div>
                    <div class="row">
                      <div class="col-lg-6" v-if="sportCenterInfo.linkToFB">
                        <div class="form-group focused">
                          <a :href="sportCenterInfo.linkToFB">Facebook</a>
                        </div>
                      </div>
                      <div class="col-lg-6" v-if="sportCenterInfo.linkToInsta">
                        <div class="form-group focused">
                          <a :href="sportCenterInfo.linkToInsta">Instagram</a>
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
                            :value="sportCenterInfo.location.place"
                            type="text"
                          />
                        </div>
                      </div>
                    </div>
                    <div class="row">
                      <div class="col-md-12">
                        <div class="form-group">
                          <a :href="sportCenterInfo.locationLink"
                            >Location Link</a
                          >
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
                            :value="sportCenterInfo.phoneNumber"
                            type="text"
                          />
                        </div>
                      </div>
                    </div>
                  </div>
                  <hr class="my-4" />
                  <!-- Address -->
                  <h6 class="heading-small text-muted mb-4">
                    Facilities Available
                  </h6>
                  <div class="pl-lg-4">
                    <div
                      v-for="(
                        facility, index
                      ) in sportCenterInfo.facilitiesAvailable"
                      :key="index"
                      class="field-group"
                    >
                      <h3>Facility {{ index + 1 }}</h3>
                      <div class="form-group focused">
                        <label for="dimensions" class="required"
                          >Facility Name</label
                        >
                        <input
                          disabled
                          type="text"
                          id="dimensions"
                          :value="facility.name"
                          class="form-control form-control-alternative"
                        />
                      </div>
                      <div class="form-group focused">
                        <label for="dimensions" class="required"
                          >Facility Description</label
                        >
                        <input
                          disabled
                          type="text"
                          id="dimensions"
                          :value="facility.description"
                          class="form-control form-control-alternative"
                        />
                      </div>
                    </div>
                  </div>
                  <hr class="my-4" />
                  <!-- Address -->
                  <h6 class="heading-small text-muted mb-4">
                    Fields Available
                  </h6>
                  <div class="pl-lg-4">
                    <div
                      v-for="(field, index) in fields"
                      :key="index"
                      class="field-group"
                    >
                      <h3>Field {{ index + 1 }}</h3>
                      <div class="form-group">
                        <label for="field-number" class="required"
                          >Field Number:</label
                        >
                        <input
                          disabled
                          type="number"
                          id="field-number"
                          @change="checkValidity(index)"
                          :value="field.fieldNumber"
                          class="form-control form-control-alternative"
                        />
                      </div>
                      <div class="form-group">
                        <label for="field-number" class="required"
                          >Field Length (in km):</label
                        >
                        <input
                          disabled
                          type="number"
                          id="field-number"
                          :value="field.fieldLength"
                          class="form-control form-control-alternative"
                        />
                      </div>
                      <div class="form-group">
                        <label for="field-number" class="required"
                          >Field Width (in km):</label
                        >
                        <input
                          disabled
                          type="number"
                          id="field-number"
                          :value="field.fieldWidth"
                          class="form-control form-control-alternative"
                        />
                      </div>
                      <div class="form-group">
                        <label for="field-number" class="required"
                          >Reservation Price (in $):</label
                        >
                        <input
                          disabled
                          type="number"
                          id="field-number"
                          :value="field.reservationPrice"
                          class="form-control form-control-alternative"
                        />
                      </div>
                      <div class="form-group">
                        <label for="field-number" class="required"
                          >Grass Type</label
                        >
                        <input
                          disabled
                          type="text"
                          id="field-number"
                          :value="field.grassType"
                          class="form-control form-control-alternative"
                        />
                      </div>
                      <div class="form-group">
                        <label for="field-number" class="required"
                          >Recommended Team Size:</label
                        >
                        <input
                          disabled
                          type="number"
                          id="field-number"
                          :value="field.recommendedTeamSize"
                          class="form-control form-control-alternative"
                        />
                      </div>
                    </div>
                  </div>
                  <hr class="my-4" />
                  <h6 class="heading-small text-muted mb-4">
                    Managers Available
                  </h6>
                  <div class="pl-lg-4">
                    <div class="field-group">
                      <table>
                        <tr>
                          <th>Name</th>
                          <th>Phone Number</th>
                          <th>Email</th>
                        </tr>
                        <tr
                          v-for="(manager, index) in this.managers"
                          :key="index"
                        >
                          <td>{{ manager.name }}</td>
                          <td>{{ manager.mobileNumber }}</td>
                          <td>{{ manager.email }}</td>
                        </tr>
                      </table>
                    </div>
                  </div>
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
import viewReviews from "./viewReviews.vue";
const helpers = require("../../helpers/authentication");
export default {
  name: "sportCenterProfileComponent",
  components: {
    loader,
    confirmPopup,
    rate,
    viewReviews,
  },
  data() {
    return {
      sportCenterInfo: null,
      done: false,
      isManager: this.$route.params.isManager === "true" ? true : false,
      src: "",
      fields: [],
      managers: [],
      validManagerVisit: false,
      isConfirmed: false,
      confirmationMessage: null,
      rate: false,
      rateData: null,
      rateOne: 0,
      rateTwo: 0,
      reviewText: "",
      firstRate: true,
      rateId: "",
      reviews: null,
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
  async mounted() {
    await this.getManagers();
    let isAuth = await helpers.isSportCenterAuthenticated(
      this.$route.params.name
    );
    if (this.isManager && !isAuth) {
      this.$router.push("/login");
    } else {
      this.$store.dispatch("setLoading");
      axios
        .get(
          "http://localhost:5000/api/getSportCenter/" + this.$route.params.name
        )
        .then((res) => {
          this.sportCenterInfo = res.data;
          this.$store.dispatch("setSportCenterInfo", this.sportCenterInfo);

          axios
            .get(
              "http://localhost:5000/api/getFields/" + this.$route.params.name
            )
            .then(
              (ress) => {
                this.fields = ress.data;
                this.$store.dispatch("setSportCenterFields", this.fields);
                axios
                  .get(
                    "http://localhost:5000/api/getSportCenterProfilePictureByName/" +
                      res.data.name
                  )
                  .then((res2) => {
                    if (res2.data) {
                      //no image
                      this.src = `data:${
                        res2.data.img.contentType
                      };base64,${Buffer.from(
                        res2.data.img.data,
                        "utf-8"
                      ).toString("base64")}`;
                    }
                  });
              },
              (errr) => {
                this.error = errr.response.data.message;
                this.$store.dispatch("stopLoading");
              }
            );
        });
      let review = await axios.post(
        helpers.api + "getReviewBySportCenterNameAndReviewerId",
        {
          sportCenterName: this.$route.params.name,
          reviewerID: this.$store.state.playerInfo.playerID,
        }
      );
      if (review.data) {
        this.rateOne = review.data.facilityQualityScore.value;
        this.rateTwo = review.data.staffServiceScore.value;
        this.reviewText = review.data.reviewText;
        this.rateId = review.data._id;
        this.firstRate = false;
      }
    }
    let reviews = await axios.get(
      helpers.api + "getASportCentersReviews/" + this.$route.params.name
    );

    this.reviews = reviews.data.map((review) => {
      return {
        description: review.reviewText,
        date: review.submissionDate.substring(0, 10),
      };
    });
    this.done = true;

    this.$store.dispatch("stopLoading");
  },

  computed: {
    isLoading() {
      return this.$store.state.isLoading;
    },
    workingHours() {
      const t1 = this.sportCenterInfo.workingHours.startTime;
      const t2 = this.sportCenterInfo.workingHours.endTime;
      let start = t1.split(":");
      let end = t2.split(":");
      var startDate = new Date(0, 0, 0, start[0], start[1], 0);
      var endDate = new Date(0, 0, 0, end[0], end[1], 0);
      var diff = endDate.getTime() - startDate.getTime();
      var hours = Math.floor(diff / 1000 / 60 / 60);
      diff -= hours * 1000 * 60 * 60;
      var minutes = Math.floor(diff / 1000 / 60);
      if (hours < 0) hours = hours + 24;

      return (
        (hours <= 9 ? "0" : "") +
        hours +
        ":" +
        (minutes <= 9 ? "0" : "") +
        minutes +
        " (From " +
        t1 +
        " to " +
        t2 +
        ")"
      );
    },
  },
  methods: {
    async getManagers() {
      const firstRequest = await axios.get(
        "http://localhost:5000/api/getManagersBySportCenterName/" +
          this.$route.params.name
      );
      let data = firstRequest.data;
      this.managers = data;
    },
    async getRateData(done) {
      this.$store.dispatch("setLoading");
      this.rateData = done;
      console.log(done);
      let date = new Date();
      if (this.firstRate) {
        await axios.post(helpers.api + "newSportCenterReview", {
          sportCenterName: this.sportCenterInfo.name,
          reviewerID: this.$store.state.playerInfo.playerID,
          staffServiceScore: {
            value: this.rateData.newRateTwo,
          },
          facilityQualityScore: {
            value: this.rateData.newRateOne,
          },
          reviewText: this.rateData.text,
          submissionDate: date.toJSON(),
        });
        await axios.patch(
          helpers.api +
            "updateSportCenterFacilityAverageRatingInCaseOfNewReview",
          {
            sportCenterName: this.sportCenterInfo.name,
            newQualityReviewValue: this.rateData.newRateOne,
            newStaffReviewValue: this.rateData.newRateTwo,
          }
        );
      } else {
        await axios.patch(
          helpers.api + "updateSportCenterReview/" + this.rateId,
          {
            staffServiceScore: { value: this.rateData.newRateTwo },
            facilityQualityScore: { value: this.rateData.newRateOne },
            reviewText: this.rateData.text,
            submissionDate: date.toJSON(),
          }
        );
        await axios.patch(
          helpers.api + "updateSportCenterQualityAverageRatingInCaseOfNewEdit",
          {
            sportCenterName: this.sportCenterInfo.name,
            oldQualityReviewValue: this.rateOne,
            oldStaffReviewValue: this.rateTwo,
            newQualityReviewValue: this.rateData.newRateOne,
            newStaffReviewValue: this.rateData.newRateTwo,
          }
        );
      }
      this.rate = false;
      this.$forceUpdate();
      // this.$router.push(this.$router.currentRoute);
      this.$store.dispatch("stopLoading");
    },
    rateMethod() {
      this.rate = true;
    },
    editSportCenter() {
      this.$router.push("/sport-center-form");
    },
    rmvSportCenter() {
      this.confirmationMessage =
        "Are you sure to delete this sport center? This will delete all managers and fields related to this sport center";
    },
    async remover() {
      this.$store.dispatch("setLoading");
      if (this.isConfirmed) {
        let managersEmails = this.managers.map((manager) => {
          return manager.email;
        });
        await Promise.all(
          managersEmails.map(async (email) => {
            await axios.delete("http://localhost:5000/api/deleteUser/" + email);
            await axios.delete(
              "http://localhost:5000/api/deletePicture/" + email
            );
          })
        );
        await axios.delete(
          "http://localhost:5000/api/deleteSportCenter/" +
            this.$store.state.sportCenterInfo._id
        );
        await axios.delete(
          "http://localhost:5000/api/deleteSportCenterPicture/" +
            this.sportCenterInfo.name
        );
        this.$router.push("/login");
        this.$store.dispatch("stopLoading");
      }
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
.reviews-comments {
  overflow: auto;
  height: 260px;
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
table {
  border-collapse: collapse;
  width: 100%;
  td,
  th {
    border: 1px solid #ddd;
    padding: 8px;
  }
}
table tr:nth-child(even) {
  background-color: #f2f2f2;
}

#table tr:hover {
  background-color: #ddd;
}
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

.flex-links {
  display: flex;
  flex-direction: column;
  justify-content: center;
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

.col-8 {
  max-width: 66.66667%;
  flex: 0 0 66.66667%;
}

@media (min-width: 768px) {
  .col-md-12 {
    max-width: 100%;
    flex: 0 0 100%;
  }
  .pb-md-4 {
    padding-bottom: 1.5rem !important;
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
.pt-8 {
  padding-top: 8rem !important;
}
.pb-0 {
  padding-bottom: 0 !important;
}
.justify-content-between {
  justify-content: space-between !important;
}
.btn-sm {
  font-size: 0.75rem;
}
.btn-info {
  color: #fff;
  border-color: green;
  background-color: green;
  box-shadow: 0 4px 6px rgba(50, 50, 93, 0.11), 0 1px 3px rgba(0, 0, 0, 0.08);
}

.btn-info:hover {
  color: #fff;
  border-color: green;
  background-color: green;
}

.btn-info:focus {
  box-shadow: 0 4px 6px rgba(50, 50, 93, 0.11), 0 1px 3px rgba(0, 0, 0, 0.08),
    0 0 0 0 rgba(17, 205, 239, 0.5);
}

.btn-info:disabled {
  color: #fff;
  border-color: green;
  background-color: green;
}
.btn-info:not(:disabled):not(.disabled):active {
  color: #fff;
  border-color: green;
  background-color: green;
}

.btn-info:not(:disabled):not(.disabled):active:focus {
  box-shadow: none, 0 0 0 0 rgba(17, 205, 239, 0.5);
}
.mr-4 {
  margin-right: 1.5rem !important;
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

.align-items-center {
  align-items: center !important;
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

@media (min-width: 768px) {
  .mt-md-5 {
    margin-top: 6rem !important;
  }

  .pt-md-4 {
    padding-top: 1.5rem !important;
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

.text-center {
  text-align: center !important;
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

[class*="btn-outline-"] {
  border-width: 1px;
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

@media (min-width: 768px) {
  .main-content .container-fluid {
    padding-right: 39px !important;
    padding-left: 39px !important;
  }
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
</style>
