<template>
  <div class="popup" v-if="on">
    <div class="popup-content">
      <h2>{{ title1 }}</h2>
      <vue3StarRatings v-model="rate1" />

      <h2>{{ title2 }}</h2>
      <vue3StarRatings v-model="rate2" />
      <h2>Review Text</h2>
      <textarea v-model="textInput"></textarea>
      <div class="flex">
        <button type="submit" @click="close()">Done</button>
        <button type="button" @click="cancel()">cancel</button>
      </div>
    </div>
  </div>
</template>
<script>
import vue3StarRatings from "vue3-star-ratings";
//import rating from "./ratingComponent.vue";
export default {
  name: "ratingPopup",
  props: ["ratingOne", "ratingTwo", "for", "text"],
  data() {
    return {
      rate1: this.ratingOne,
      rate2: this.ratingTwo,
      textInput: this.text,
      on: true,
      title1: "",
      title2: "",
    };
  },
  components: {
    vue3StarRatings,
  },
  beforeMount() {
    if (this.for === "sportCenter") {
      (this.title1 = "Facility Quality Rating"),
        (this.title2 = "Staff Service Rating");
    } else if (this.for === "team") {
      (this.title1 = "Team Skill Rating"),
        (this.title2 = "Team Morality Rating");
    } else {
      //player
      (this.title1 = "Player Skill Rating"),
        (this.title2 = "Player Morality Rating");
    }
  },
  methods: {
    close() {
      this.on = false;
      let res = {
        newRateOne: this.rate1,
        newRateTwo: this.rate2,
        text: this.textInput,
      };
      this.$emit("done", res);
    },
    cancel() {
      this.$parent.rate = false;
      this.on = false;
    },
  },
};
</script>
<style lang="scss" scoped>
* {
  color: green !important;
}
textarea {
  width: 80%;
  margin-bottom: 20px;
}
::v-deep .stars-inner {
  svg {
    color: green !important;
  }
}
.flex {
  display: flex;
  flex-direction: row;
  justify-content: space-evenly;
}
.popup {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: rgba(0, 0, 0, 0.5);
}

.popup-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 20px;
  background-color: #fff;
  border-radius: 5px;
  box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.5);
}

h2 {
  margin-top: 0;
  margin-bottom: 10px;
}
</style>
