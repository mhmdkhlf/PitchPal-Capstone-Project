<template lang="">
  <div class="all">
    <div
      class="profile-pic-div"
      @mouseenter="showButton()"
      @mouseleave="rmvButton()"
    >
      <img :src="editvalue" id="photo" ref="img" v-if="editvalue" />
      <img
        src="../assets/images/image.jpg"
        id="photo"
        ref="img"
        v-else-if="!fromSportCenter"
      />
      <img src="../assets/images/background.jpg" id="photo" ref="img" v-else />

      <input type="file" ref="image" @change="imageSelect()" id="file" />
      <label for="file" id="uploadBtn" ref="button">Choose Photo</label>
    </div>
  </div>
</template>
<script>
export default {
  name: "profilePicture",
  props: ["fromSportCenter", "editvalue"],
  methods: {
    showButton() {
      this.$refs.button.style.display = "block";
    },
    rmvButton() {
      this.$refs.button.style.display = "none";
    },
    imageSelect() {
      const image = this.$refs.image.files[0];

      if (image) {
        const reader = new FileReader(); //FileReader is a predefined function of JS
        this.$emit("pictureUploaded", image);
        reader.addEventListener("load", () => {
          this.$refs.img.setAttribute("src", reader.result);
        });

        reader.readAsDataURL(image);
      }
    },
  },
};
</script>
<style lang="css" scoped>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

.all {
  padding: 100px;
  width: 100%;
}

h1 {
  font-family: sans-serif;
  text-align: center;
  font-size: 30px;
  color: #222;
}

.profile-pic-div {
  height: 160px;
  width: 160px;
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  border-radius: 50%;
  overflow: hidden;
  border: 1px solid grey;
}

#photo {
  height: 100%;
  width: 100%;
}

#file {
  display: none;
}

#uploadBtn {
  height: 40px;
  width: 100%;
  position: absolute;
  bottom: 0;
  left: 50%;
  transform: translateX(-50%);
  text-align: center;
  background: rgba(0, 0, 0, 0.7);
  color: wheat;
  line-height: 30px;
  font-family: sans-serif;
  font-size: 15px;
  cursor: pointer;
  display: none;
}
</style>
