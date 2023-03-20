<template>
  <!-- <loader /> -->
  <router-view />
  <!-- <p>hello</p>
  <img :src="src" alt="failed" ref="test" v-if="done" /> -->
  <!-- <pf /> -->
</template>
<script>
//import loader from "./components/loader.vue";
// import axios from "axios";
// import { Buffer } from "buffer";
//import pf from "@/components/profilePicture.vue";
export default {
  // mounted() {
  //   axios
  //     .get("http://localhost:5000/api/getProfilePictureByEmail/s@gmail.com")
  //     .then((res) => {
  //       console.log(res.data);
  //       this.obj = res.data.img;
  //       this.done = true;
  //     });
  //   // this.$refs.test.setAttribute("src");
  // },
  // data() {
  //   return {
  //     obj: null,
  //     done: false,
  //   };
  // },
  // components: {
  //   //loader,
  //   pf,
  // },
  // computed: {
  //   src() {
  //     // const contentType = this.obj.img.contentType;
  //     // console.log(contentType);
  //     // const data = new Buffer(
  //     //   new Buffer(this.obj.img.data.data).toString("base64"),
  //     //   "base64"
  //     // );
  //     // console.log(data);
  //     // return `data:image/${contentType};base64,${data}`;
  //     return `data:${this.obj.contentType};base64,${Buffer.from(
  //       this.obj.data,
  //       "utf-8"
  //     ).toString("base64")}`;
  //   },
  // },
};
</script>

<style lang="scss"></style>
