<template>
  <loader v-if="isLoading" />
  <div class="all" v-if="!isLoading">
    <nav class="navbar">
      <div class="navbar-left">
        <h1>Best Pitches To Play Football</h1>
      </div>
      <div class="navbar-right">
        <form class="navbar-form">
          <div class="form-group">
            <div class="input-group">
              <input type="text" class="form-control" placeholder="Search" />
              <div class="input-group-append">
                <i class="fa fa-search" style="color: green"></i>
              </div>
            </div>
          </div>
        </form>
        <div class="navbar-select">
          <label for="sort-select">Sort by:</label>
          <select id="sort-select" class="form-control">
            <option value="">Select an option</option>
            <option value="name">Name</option>
            <option value="rating">rating</option>
            <option value="distance-ascending">distance-ascending</option>
            <option value="distance-descending">distance-descending</option>
          </select>
        </div>
        <div class="navbar-select">
          <label for="filter-select">Filter by:</label>
          <select id="filter-select" class="form-control">
            <option value="">Select an option</option>
            <option value="turf">Turf Grass</option>
            <option value="grass">Grass</option>
          </select>
        </div>
      </div>
    </nav>
    <div class="sps">
      <spCard
        v-for="(sp, index) in objects"
        :sportCenterInfo="sp"
        :key="index"
      />
    </div>
  </div>
</template>
<script>
import axios from "axios";
const helpers = require("../../helpers/authentication");
import loader from "./loader.vue";
import spCard from "./sportCenterCard.vue";
import { Buffer } from "buffer";
//var _ = require("lodash");
export default {
  name: "sportCenters",
  components: {
    loader,
    spCard,
  },
  async beforeMount() {
    this.$store.dispatch("setLoading");
    let sps = await axios.get(helpers.api + "getAllSportCenters");
    await Promise.all(
      sps.data.map(async (sp) => {
        let img = await axios.get(
          helpers.api + "getSportCenterProfilePictureByName/" + sp.name
        );
        if (img.data) {
          sp["src"] = `data:${img.data.img.contentType};base64,${Buffer.from(
            img.data.img.data,
            "utf-8"
          ).toString("base64")}`;
        } else {
          sp["imgsrc"] = "";
        }
        this.objects.push(sp);
      })
    );
    this.$store.dispatch("stopLoading");
  },
  data() {
    return {
      objects: [],
    };
  },
  computed: {
    isLoading() {
      return this.$store.state.isLoading;
    },
  },
};
</script>
<style lang="scss" scoped>
// #sort-bar {
//   // width: 80%;
//   // height: 80px;
//   // margin-left: 10px;
//   background-color: green;
//   display: flex;
//   flex-wrap: wrap;
//   padding: 10px;
// }
.navbar {
  background-color: #1e9600;
  color: white;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 20px;
  font-size: 24px;
}

.navbar h1 {
  margin: 0;
}

.navbar-right {
  display: flex;
  align-items: center;
}

.navbar-form {
  display: flex;
  align-items: center;
}

.form-group {
  margin: 0;
}

.input-group {
  position: relative;
}

.input-group .form-control {
  border-radius: 0;
  border: none;
  background-color: transparent;
  color: white;
  padding-right: 40px;
}

.input-group .form-control:focus {
  box-shadow: none;
}

.input-group-append {
  position: absolute;
  top: 0;
  right: 0;
  height: 100%;
  display: flex;
  align-items: center;
}

.sps {
  display: grid;
  gap: 5px;
  grid-template-columns: repeat(3, 1fr);
  @media (max-width: 768px) {
    grid-template-columns: repeat(1, 1fr);
  }
  padding: 20px;
}

.navbar-select {
  margin-left: 20px;
  display: flex;
  align-items: center;
}

label {
  margin-right: 5px;
}

.form-control {
  border-radius: 0;
  border: none;
  background-color: #e8f0de;
  color: #1e9600;
}

.form-control:focus {
  box-shadow: none;
}

select {
  width: 150px;
  padding: 5px;
}
input[type="text"] {
  padding: 5px;
  border: 3px solid white !important;
  background-color: #e8f0de !important;
}
input[type="text"]::placeholder {
  color: green;
}
@media only screen and (max-width: 600px) {
  .navbar {
    flex-direction: column;
  }
  .navbar-left,
  .navbar-right {
    width: 100%;
    text-align: center;
  }
  .navbar-right {
    margin-top: 10px;
    justify-content: center;
  }
  .navbar-select {
    margin: 10px 0;
  }
  .form-control {
    width: 100%;
  }
  select {
    width: 100%;
  }
}
</style>
