<template>
  <div></div>
  <!-- <loader /> -->
  <!-- <router-view /> -->
  <!-- <p>hello</p>
  <img :src="src" alt="failed" ref="test" v-if="done" /> -->
  <!-- <pf /> -->
  <!-- <profile :player-info="obj" :isSelfVisit="true" :imageSrc="src" v-if="done" /> -->
</template>
<script>
//import profile from "./components/Profile.vue";
//import loader from "./components/loader.vue";
// import axios from "axios";
// import { Buffer } from "buffer";
//import pf from "@/components/profilePicture.vue";
export default {
  mounted() {
    this.$router.push({
      name: "Profile",
      params: {
        playerInfo: {
          playerID: "123-456",
          name: "Ali Solh",
          email: "mytest@gmail.com",
          phoneNumber: "71913710",
          location: {
            longitude: 35.481674,
            latitude: 33.8932763,
            place: "Ra’s Bayrut, Beirut, Lebanon",
          },
          dateOfBirth: "2003-01-12T00:00:00.000+00:00",
          height: 0,
          weight: 0,
          sex: "M",
          averageMoralityRating: 0,
          averageSkillRating: 0,
          numberOfReviews: 0,
          position: "defender",
          description: "abadayy",
        },
        isSelfVisit: true,
      },
    });
  },

  // computed: {
  //   src() {
  //     return `data:${this.obj.contentType};base64,${Buffer.from(
  //       this.obj.data,
  //       "utf-8"
  //     ).toString("base64")}`;
  //   },
  // },
};
</script>

<style lang="scss">
button,
input[type="submit"] {
  cursor: pointer;
}
</style>
