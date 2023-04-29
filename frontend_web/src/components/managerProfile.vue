<template>
  <link
    href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700"
    rel="stylesheet"
  />
  <!-- <logo /> -->
  <loader v-if="isLoading && !done" />
  <confirmPopup :Message="confirmationMessage" v-if="confirmationMessage" />
  <div
    class="body"
    v-if="done && !isLoading"
    :class="{ hidden: confirmationMessage }"
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
                  <div class="card-body card-body-center">
                    <div class="text-center">
                      <h3 id="go-to-sport-center" @click="goToSportCenter()">
                        {{ managerInfo.sportCenterName }}
                      </h3>
                      <div class="flex-links">
                        <a @click="editManager()" v-if="isSelfVisit"
                          >Edit Your Profile</a
                        >
                        <a @click="rmvManager()" id="rmv" v-if="isSelfVisit"
                          >Deactivate Your Account</a
                        >
                      </div>
                    </div>
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
                </div>
              </div>
              <div class="card-body">
                <form>
                  <h6 class="heading-small text-muted mb-4">
                    User information
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
                            :value="managerInfo.name"
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
                      <div class="col-lg-6">
                        <div class="form-group focused">
                          <label class="form-control-label" for="phoneNumber"
                            >PhoneNumber</label
                          >
                          <input
                            id="phoneNumber"
                            class="form-control form-control-alternative"
                            disabled
                            :value="managerInfo.mobileNumber"
                            type="text"
                          />
                        </div>
                      </div>
                      <div class="col-lg-6">
                        <div class="form-group">
                          <label class="form-control-label" for="input-email"
                            >Email address</label
                          >
                          <input
                            id="input-email"
                            type="email"
                            class="form-control form-control-alternative"
                            :value="managerInfo.email"
                            disabled
                          />
                        </div>
                      </div>
                    </div>
                  </div>
                  <hr class="my-4" />
                  <!-- Address -->
                  <h6 class="heading-small text-muted mb-4">
                    Sport Center information
                  </h6>
                  <div class="pl-lg-4">
                    <div class="row">
                      <div class="col-md-12">
                        <div class="form-group focused">
                          <label
                            class="form-control-label"
                            for="sportCenterName"
                            >Sport Center Name</label
                          >
                          <input
                            id="sportCenterName"
                            class="form-control form-control-alternative"
                            disabled
                            :value="managerInfo.sportCenterName"
                            type="text"
                          />
                        </div>
                      </div>
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
const helpers = require("../../helpers/authentication.js");
export default {
  name: "playerProfileComponent",
  components: {
    loader,
    confirmPopup,
  },
  data() {
    return {
      managerInfo: null,
      done: false,
      isSelfVisit: this.$route.params.isSelfVisit === "true" ? true : false,
      src: "",
      managerData: null,
      isConfirmed: false,
      confirmationMessage: null,
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
    goToSportCenter() {
      this.$router.push("/sport-center-view");
    },
    editManager() {
      this.$router.push({
        path: "/first-manager-profile",
        query: {
          info: JSON.stringify({
            managerInfo: this.managerInfo,
          }),
        },
      });
    },
    rmvManager() {
      this.confirmationMessage = "Are you sure to de activate your Account?";
    },
    async remover() {
      this.$store.dispatch("setLoading");
      if (this.isConfirmed) {
        await axios.delete(
          "http://localhost:5000/api/deleteUser/" +
            sessionStorage.getItem("user")
        );
        await axios.delete(
          "http://localhost:5000/api/deleteManager/" +
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
    if (this.isSelfVisit) {
      if (
        !helpers.isLoggedIn &&
        !helpers.isManagerAuthenticated(this.$route.params.email)
      ) {
        this.$store.dispatch("stopLoading");
        this.$router.push("/login");
      }
    }

    axios
      .get("http://localhost:5000/api/getManager/" + this.$route.params.email)
      .then((res) => {
        this.managerInfo = res.data;
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
            this.done = true;

            this.$store.dispatch("stopLoading");
          });
      });
  },

  computed: {
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
#rmv {
  color: red !important;
}
.flex-links {
  display: flex;
  flex-direction: column;
  justify-content: center;
}
#go-to-sport-center {
  cursor: pointer;
}
.common {
  color: white !important;
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
.hidden {
  opacity: 0.07;
}

*,
*::before,
*::after {
  box-sizing: border-box;
}
.card-body-center {
  margin-top: 120px;
  display: flex !important;
  justify-content: center !important;
  align-items: center !important;
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

@media (min-width: 576px) {
  .form-inline .form-group {
    display: flex;
    margin-bottom: 0;
    flex: 0 0 auto;
    flex-flow: row wrap;
    align-items: center;
  }

  .form-inline .form-control {
    display: inline-block;
    width: auto;
    vertical-align: middle;
  }
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

.heading-small {
  font-size: 0.75rem;
  padding-top: 0.25rem;
  padding-bottom: 0.25rem;
  letter-spacing: 0.04em;
  text-transform: uppercase;
}
</style>
