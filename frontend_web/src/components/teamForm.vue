<template>
  <logo />
  <errorPopup v-if="error" :errorMessage="error" />
  <loader v-if="isLoading && !error" />
  <div class="form-container" v-if="!isLoading" :class="{ hidden: error }">
    <h1 class="form-title">Create Your Team</h1>
    <form action="" class="team-form">
      <div class="form-group">
        <input type="text" placeholder="Team Name" v-model="name" />
      </div>
      <div>
        <div>
          <input type="text" placeholder="Add Player" v-model="inputId" />
          <button id="push" @click="addPlayer($event)">Add</button>
        </div>
      </div>
      <userRow
        :userName="captainInfo.name"
        :userId="captainInfo.playerID"
        :imageSrc="captainImgSrc"
        :isCaptain="true"
      />
      <userRow
        v-for="(player, index) in players"
        :userName="player.name"
        :userId="player.id"
        :imageSrc="player.src"
        :key="index"
        @delete="deletePlayer(index)"
        :isCaptain="false"
      />
      <button id="create-btn" @click="createTeam($event)">Create</button>
    </form>
  </div>
</template>
<script>
import axios from "axios";
import logo from "./logo.vue";
import { Buffer } from "buffer";
import errorPopup from "./errorPopup.vue";
import loader from "./loader.vue";
import userRow from "./userRow.vue";
export default {
  name: "TeamForm",
  components: {
    logo,
    errorPopup,
    loader,
    userRow,
  },
  beforeMount() {
    this.teamIds.push(this.captainInfo.playerID);
    this.$store.dispatch("setLoading");
    axios
      .get(
        "http://localhost:5000/api/getProfilePictureByEmail/" +
          sessionStorage.getItem("user")
      )
      .then((res) => {
        if (res.data) {
          this.captainImgSrc = `data:${
            res.data.img.contentType
          };base64,${Buffer.from(res.data.img.data, "utf-8").toString(
            "base64"
          )}`;
        }
        this.$store.dispatch("stopLoading");
      });
  },
  data() {
    return {
      name: "",
      teamIds: [],
      inputId: "",
      players: [],
      error: null,
      pattern: /^\d{3}-\d{3}$/,
      captainInfo: this.$store.state.playerInfo,
      captainImgSrc: "",
    };
  },
  methods: {
    createTeam(e) {
      e.preventDefault();
      this.$store.dispatch("setLoading");
      if (!this.name || this.players.length == 0) {
        this.error =
          "all fields must be filled and at least two players should be in the team";
        this.$store.dispatch("stopLoading");
      } else {
        axios
          .post("http://localhost:5000/api/newTeam", {
            name: this.name,
            captainId: this.$store.state.playerInfo.playerID,
            playerIds: this.teamIds,
          })
          .then((res) => {
            if (res.status === 200) this.$store.dispatch("stopLoading");
          });
      }
    },
    addPlayer(e) {
      e.preventDefault();
      if (this.pattern.test(this.inputId)) {
        let obj = {};
        this.$store.dispatch("setLoading");
        axios.get("http://localhost:5000/api/getPlayer/" + this.inputId).then(
          (res) => {
            if (res.data) {
              (obj.id = res.data.playerID), (obj.name = res.data.name);
              axios
                .get(
                  "http://localhost:5000/api/getProfilePictureByEmail/" +
                    res.data.email
                )
                .then(
                  (res2) => {
                    if (res2.data) {
                      obj.src = `data:${
                        res2.data.img.contentType
                      };base64,${Buffer.from(
                        res2.data.img.data,
                        "utf-8"
                      ).toString("base64")}`;
                    } else {
                      obj.src = "";
                    }

                    this.$store.dispatch("stopLoading");
                    if (
                      this.players.find(
                        (obj_added) =>
                          obj_added.id === obj.id &&
                          obj_added.name === obj.name &&
                          obj_added.src === obj.src
                      )
                    ) {
                      this.error = "The player already exists in the team";
                    } else {
                      this.players.push(obj);
                      this.teamIds.push(obj.id);
                    }
                  },
                  (err2) => {
                    this.error = err2.response.data.error;
                    obj.src = "";

                    this.$store.dispatch("stopLoading");
                  }
                );
            } else {
              this.error = "no player found with this id";
              this.$store.dispatch("stopLoading");
            }
          },
          (err) => {
            this.$store.dispatch("stopLoading");
            this.error = err.response.data.error;
          }
        );
      } else {
        this.error =
          "The Id should consists of six number seperated by -. Example 123-456";
      }
    },
    deletePlayer(i) {
      this.players.splice(i, 1);
      this.teamIds.splice(i, 1);
    },
  },
  computed: {
    isLoading() {
      return this.$store.state.isLoading;
    },
  },
};
</script>
<style lang="scss" scoped>
*,
*:before,
*:after {
  padding: 0;
  margin: 0;
  box-sizing: border-box;
}
body {
  height: 100vh;
  background: #066acd;
}
// .form-group {
//   margin-bottom: 20px;
// }
.form-container {
  /* display: flex;
    justify-content: center;
    align-items: center; */
  padding: 13px !important;
  height: 100%;
  /* Add this line */
  overflow-x: hidden !important;
  /* Fix scrolling issue */
}
#create-btn {
  padding: 10px;
  border: none;
  border-radius: 5px;
  background-color: #2dce89;
  color: #fff;
  font-size: 16px;
  cursor: pointer;
  margin-top: 20px;
  transition: all 0.2s ease-in-out;
}

#create-btn:hover {
  background-color: #fff;
  color: #2dce89;
  border: 1px solid #2dce89;
}
.form-title {
  margin-top: 0;
  margin-bottom: 20px;
  color: #0a870ac7;
  text-align: center;
}
.hidden {
  opacity: 0.07;
}

.team-form {
  display: flex;
  flex-direction: column;
  padding: 20px;
  background-color: #fff;
  border-radius: 10px;
  box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
}
#newtask {
  position: relative;
  padding: 30px 20px;
}
input {
  width: 75%;
  height: 45px;
  padding: 12px;
  color: #0a870ac7;
  font-weight: 500;
  position: relative;
  border-radius: 5px;
  font-family: "Poppins", sans-serif;
  font-size: 15px;
  border: 2px solid #d1d3d4;
  margin-bottom: 20px;
}
input:focus {
  outline: none;
  border-color: #0a870ac7;
}
button {
  position: relative;
  float: right;
  font-weight: 500;
  font-size: 16px;
  background-color: #0a870ac7;
  border: none;
  color: #ffffff;
  cursor: pointer;
  outline: none;
  width: 20%;
  height: 45px;
  border-radius: 5px;
  font-family: "Poppins", sans-serif;
}
</style>
