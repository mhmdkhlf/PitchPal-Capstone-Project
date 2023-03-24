<template>
  <!-- <loader /> -->
  <!-- <router-view /> -->
  <!-- <p>hello</p>
  <img :src="src" alt="failed" ref="test" v-if="done" /> -->
  <!-- <pf /> -->
  <profile :player-info="obj" :isSelfVisit="true" :imageSrc="src" v-if="done" />
</template>
<script>
import profile from "./components/Profile.vue";
//import loader from "./components/loader.vue";
import axios from "axios";
import { Buffer } from "buffer";
//import pf from "@/components/profilePicture.vue";
export default {
  mounted() {
    axios.get("http://localhost:5000/api/getPlayer/343-791").then((res) => {
      console.log(res.data);
      this.obj = res.data;
      axios
        .get(
          "http://localhost:5000/api/getProfilePictureByEmail/mytest@gmail.com"
        )
        .then((res2) => {
          this.src = `data:${res2.data.img.contentType};base64,${Buffer.from(
            res2.data.img.data,
            "utf-8"
          ).toString("base64")}`;
          this.done = true;
        });
    });

    // this.$refs.test.setAttribute("src");
  },
  data() {
    return {
      obj: null,
      done: false,
      src: null,
    };
  },
  components: {
    profile,
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
