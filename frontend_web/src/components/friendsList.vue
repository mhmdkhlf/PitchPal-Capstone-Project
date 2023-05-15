<template>
  <loader v-if="isLoading" />
  <div class="all" v-if="!isLoading">
    <nav class="navbar">
      <div class="navbar-left">
        <h1>Players</h1>
      </div>
      <div class="navbar-right">
        <form class="navbar-form">
          <div class="form-group">
            <div class="input-group">
              <input
                type="text"
                class="form-control"
                placeholder="Search By Name"
                v-model="searchValue"
              />
              <div class="input-group-append">
                <i class="fa fa-search" style="color: green"></i>
              </div>
            </div>
          </div>
        </form>
        <div class="navbar-select">
          <label for="sort-select">Display:</label>
          <select id="sort-select" class="form-control" v-model="type">
            <option value="">Select an option</option>
            <option value="friends">Friends</option>
            <option value="players">Players</option>
          </select>
        </div>
      </div>
    </nav>
    <div class="sps">
      <playerCard
        v-for="(player, index) in show"
        :player-info="player"
        :key="index"
      />
    </div>
  </div>
</template>
<script>
import axios from "axios";
import playerCard from "./playerCard.vue";
import { Buffer } from "buffer";
import loader from "./loader.vue";
const helpers = require("../../helpers/authentication");
export default {
  name: "friendsView",
  components: {
    playerCard,
    loader,
  },
  data() {
    return {
      players: [],
      friends: [],
      show: [],
      searchValue: "",
      type: "",
    };
  },
  mounted() {
    this.show = this.friends;
  },
  watch: {
    type(newv) {
      if (newv === "players") {
        this.show = this.players;
      } else if (newv === "friends") {
        this.show = this.friends;
      } else {
        this.show = this.players;
      }
    },
    searchValue(newv) {
      if (newv != "" && newv && this.type === "players") {
        this.show = this.players.filter((item) => {
          return item.name.toUpperCase().includes(newv.toUpperCase());
        });
      } else if (newv != "" && newv && this.type === "friends") {
        this.show = this.friends.filter((item) => {
          return item.name.toUpperCase().includes(newv.toUpperCase());
        });
      } else {
        if (this.type === "friends") {
          this.show = this.friends.filter((item) => {
            return item.name.toUpperCase().includes(newv.toUpperCase());
          });
        } else {
          this.show = this.players.filter((item) => {
            return item.name.toUpperCase().includes(newv.toUpperCase());
          });
        }
      }
    },
  },
  computed: {
    isLoading() {
      return this.$store.state.isLoading;
    },
  },
  async beforeMount() {
    let id = this.$route.params.id;
    let playerId = id ? id : this.$store.state.playerInfo.playerID;
    this.$store.dispatch("setLoading");
    let friends = await axios.get(helpers.api + "getFriends/" + playerId);
    await Promise.all(
      friends.data.map(async (id) => {
        let playerI = await axios.get(
          "http://localhost:5000/api/getPlayer/" + id
        );

        let img = await axios.get(
          "http://localhost:5000/api/getProfilePictureByEmail/" +
            playerI.data.email
        );

        if (img.data) {
          playerI.data["src"] = `data:${
            img.data.img.contentType
          };base64,${Buffer.from(img.data.img.data, "utf-8").toString(
            "base64"
          )}`;
          this.friends.push(playerI.data);
        } else {
          this.friends.push(playerI.data);
        }
      })
    );
    let players = await axios.get(helpers.api + "getAllPlayers");
    await Promise.all(
      players.data.map(async (player) => {
        let img = await axios.get(
          "http://localhost:5000/api/getProfilePictureByEmail/" + player.email
        );

        if (img.data) {
          player["src"] = `data:${
            img.data.img.contentType
          };base64,${Buffer.from(img.data.img.data, "utf-8").toString(
            "base64"
          )}`;
          this.players.push(player);
        } else {
          this.players.push(player);
        }
      })
    );
    this.$store.dispatch("stopLoading");
  },
};
</script>
<style lang="scss" scoped>
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
  color: #1e9600 !important;
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
