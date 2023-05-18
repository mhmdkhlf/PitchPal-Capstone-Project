<template>
  <!-- <logo /> -->
  <error v-if="error" :errorMessage="error" />
  <loader v-if="this.$store.state.isLoading && !error" />
  <div
    class="reservation-page"
    v-if="!this.$store.state.isLoading"
    :class="{ hidden: error }"
  >
    <h1 class="t">Play in {{ sportcenterInfo.name }}</h1>

    <div class="form-container">
      <div class="form-item">
        <label for="field">Select Field Number:</label>
        <select id="field" v-model="selectedField">
          <option v-for="field in sportcenterInfo.nbOfFields" :key="field">
            {{ field }}
          </option>
        </select>
      </div>
      <div class="form-item">
        <label for="field">Visibilty of Reservation:</label>
        <select id="field" v-model="visibility">
          <option value="public" v-if="!isManager">public</option>
          <option value="private">private</option>
        </select>
      </div>

      <div class="form-item">
        <label for="date">Select Date:</label>
        <input type="date" id="date" v-model="selectedDate" :min="minDate" />
      </div>
    </div>
    <h1 class="h">Available Slots</h1>
    <div class="time-slots">
      <timeSlot
        v-for="timeSlot in fieldTimes[selectedField]"
        :key="timeSlot.startTime"
        :startTime="timeSlot.startTime"
        :endTime="timeSlot.endTime"
        @selected="getTimeSlot"
        :isSelected="isSelected(timeSlot)"
        :type="`free`"
      />
    </div>
    <div class="flex">
      <div class="form-container2">
        <h1 class="t">Team One Players</h1>
        <form action="" class="team-form">
          <div>
            <div>
              <input
                type="text"
                placeholder="Enter player Id or Team Name"
                v-model="inputOne"
              />
              <button id="push" @click="addPlayer($event)">Add</button>
            </div>
          </div>

          <userRow
            v-for="(player, index) in teamOnePlayers"
            :userName="player.name"
            :userId="player.id"
            :imageSrc="player.src"
            :key="index"
            @delete="deletePlayer(index)"
            :isCaptain="false"
          />
        </form>
      </div>
      <div class="form-container2">
        <h1 class="t">Team Two Players</h1>
        <form action="" class="team-form">
          <div>
            <div>
              <input
                type="text"
                placeholder="Enter player Id or Team Name"
                v-model="inputTwo"
              />
              <button id="push" @click="addPlayer2($event)">Add</button>
            </div>
          </div>

          <userRow
            v-for="(player, index) in teamTwoPlayers"
            :userName="player.name"
            :userId="player.id"
            :imageSrc="player.src"
            :key="index"
            @delete="deletePlayer2(index)"
            :isCaptain="false"
          />
        </form>
      </div>
    </div>
    <h1 class="hh">Additional Comments</h1>
    <div>
      <textarea
        class="text-area"
        rows="6"
        cols="160"
        v-model="comment"
        placeholder="Any Additional Comments"
      ></textarea>
    </div>
    <div class="button">
      <button @click="makeReservation()">Confirm Reservation</button>
    </div>
  </div>
</template>

<script>
import timeSlot from "./timeSlot.vue";
// import logo from "./logo.vue";
import userRow from "./userRow.vue";
import loader from "./loader.vue";
import axios from "axios";
import error from "./errorPopup.vue";
import { Buffer } from "buffer";
const helpers = require("../../helpers/authentication");
export default {
  components: {
    timeSlot,
    loader,
    // logo,
    userRow,
    error,
  },
  computed: {
    minDate() {
      return new Date().toJSON().slice(0, 10);
    },
  },
  watch: {
    selectedDate(newDate) {
      this.$store.dispatch("setLoading");
      for (let i = 1; i <= this.sportcenterInfo.nbOfFields; i++) {
        this.fieldTimes[i] = [];
      }
      let todayReservations = this.allReservation.filter((reser) => {
        if (reser.reservationDate.slice(0, 10) === newDate) {
          return true;
        }
        return false;
      });
      console.log(todayReservations);
      let perField = {};
      for (let i = 1; i <= this.sportcenterInfo.nbOfFields; i++) {
        perField[i] = todayReservations.filter((r) => {
          if (r.fieldNumber === i && r.status !== "rejected") {
            return true;
          }
          return false;
        });
      }
      console.log(perField);
      for (let i = 1; i <= this.sportcenterInfo.nbOfFields; i++) {
        perField[i] = perField[i].map((r) => {
          return r.reservationTime.startTime + "-" + r.reservationTime.endTime;
        });
      }
      console.log(perField);

      for (let i = 0; i < this.slots.length; i++) {
        let timeSlot = this.slots[i];
        for (let i = 1; i <= this.sportcenterInfo.nbOfFields; i++) {
          if (!perField[i].includes(timeSlot)) {
            let startTime = timeSlot.split("-")[0];
            let endTime = timeSlot.split("-")[1];
            this.fieldTimes[i].push({ startTime, endTime });
          }
        }
      }
      this.$store.dispatch("stopLoading");
    },
  },
  data() {
    return {
      sportcenterInfo: null,
      selectedField: 1,
      selectedDate: new Date().toJSON().slice(0, 10), // Default selected field
      fieldTimes: {},
      slots: [],
      allReservation: [],
      selectedTime: null,
      teamOnePlayers: [],
      teamTwoPlayers: [],
      error: null,
      inputOne: "",
      inputTwo: "",
      pattern: /^\d{3}-\d{3}$/,
      visibility: "private",
      isManager: this.$store.state.managerInfo ? true : false,
      comment: "",
    };
  },

  async beforeMount() {
    this.$store.dispatch("setLoading");
    let today = new Date().toJSON().slice(0, 10);
    if (this.$store.state.playerInfo) {
      this.generalAddPlayer(this.$store.state.playerInfo.playerID, "one");
    }

    let sp = await axios.get(
      helpers.api + "getSportCenter/" + this.$route.params.sportCenterName
    );
    this.sportcenterInfo = sp.data;
    for (let i = 1; i <= this.sportcenterInfo.nbOfFields; i++) {
      this.fieldTimes[i] = [];
    }
    this.slots = this.getTimeSlots(
      this.sportcenterInfo.workingHours.startTime,
      this.sportcenterInfo.workingHours.endTime
    );
    let allReservation = await axios.get(
      helpers.api +
        "getAllReservationsBySportCenter/" +
        this.sportcenterInfo.name
    );
    this.allReservation = allReservation.data;

    let todayReservations = allReservation.data.filter((reser) => {
      if (reser.reservationDate.slice(0, 10) == today) {
        return true;
      }
      return false;
    });

    let perField = {};
    for (let i = 1; i <= this.sportcenterInfo.nbOfFields; i++) {
      perField[i] = todayReservations.filter((r) => {
        if (r.fieldNumber === i && r.status !== "rejected") {
          return true;
        }
        return false;
      });
    }

    for (let i = 1; i <= this.sportcenterInfo.nbOfFields; i++) {
      perField[i] = perField[i].map((r) => {
        return r.reservationTime.startTime + "-" + r.reservationTime.endTime;
      });
    }

    for (let i = 0; i < this.slots.length; i++) {
      let timeSlot = this.slots[i];
      for (let i = 1; i <= this.sportcenterInfo.nbOfFields; i++) {
        if (!perField[i].includes(timeSlot)) {
          let startTime = timeSlot.split("-")[0];
          let endTime = timeSlot.split("-")[1];
          this.fieldTimes[i].push({ startTime, endTime });
        }
      }
    }
    this.$store.dispatch("stopLoading");
  },
  methods: {
    getTimeSlot(time) {
      //   console.log(time);
      //   console.log("in");
      this.selectedTime = time;
    },
    isSelected(t) {
      if (t === null || this.selectedTime === null) {
        return false;
      }
      let tt = t.startTime + "-" + t.endTime;
      let tt2 = this.selectedTime.startTime + "-" + this.selectedTime.endTime;
      console.log(this.selectedTime);
      console.log(tt);
      if (tt2 === tt) {
        return true;
      }
      return false;
    },
    getTimeSlots(start, end) {
      const startTime = this.convertToMinutes(start);
      const endTime = this.convertToMinutes(end);

      const timeSlots = [];
      let currentTime = startTime;

      while (currentTime + 90 <= endTime) {
        const timeSlotStart = this.convertToTime(currentTime);
        const timeSlotEnd = this.convertToTime(currentTime + 90);
        timeSlots.push(`${timeSlotStart}-${timeSlotEnd}`);

        currentTime += 90;
        if (currentTime + 90 <= endTime) {
          const timeSlotStart = this.convertToTime(currentTime);
          const timeSlotEnd = this.convertToTime(currentTime + 90);
          timeSlots.push(`${timeSlotStart}-${timeSlotEnd}`);
        }

        currentTime += 90;
      }

      return timeSlots;
    },
    async makeReservation() {
      this.$store.dispatch("setLoading");
      let teamOneIds = this.teamOnePlayers.map((player) => {
        return player.id;
      });
      let teamTwoIds = this.teamTwoPlayers.map((player) => {
        return player.id;
      });
      await axios.post(helpers.api + "makeReservation", {
        reserverEmail: this.isManager
          ? this.$store.state.managerInfo.email
          : this.$store.state.playerInfo.email,
        reserverType: this.isManager ? "FieldManager" : "Player",
        fieldNumber: this.selectedField,
        isPublic: this.visibility === "private" ? false : true,
        comment: this.comment,
        teamOneIds: teamOneIds,
        teamTwoIds: teamTwoIds,
        reservationStatus: "pending",
        reservationDate: this.selectedDate,
        reservationTime: this.selectedTime,
        sportCenterName: this.$route.params.sportCenterName,
      });
      this.$store.dispatch("stopLoading");
      if (this.$store.state.playerInfo) {
        this.$router.push("/");
      } else {
        this.$router.push("/manager-home-page");
      }
    },
    convertToMinutes(time) {
      const [hours, minutes] = time.split(":").map(Number);
      return hours * 60 + minutes;
    },

    convertToTime(minutes) {
      const hours = Math.floor(minutes / 60);
      const mins = minutes % 60;

      return `${this.padZero(hours)}:${this.padZero(mins)}`;
    },

    padZero(num) {
      return num.toString().padStart(2, "0");
    },
    deletePlayer(i) {
      this.teamOnePlayers.splice(i, 1);
    },
    deletePlayer2(i) {
      this.teamTwoPlayers.splice(i, 1);
    },
    generalAddPlayer(id, team) {
      if (this.pattern.test(id)) {
        let obj = {};
        this.$store.dispatch("setLoading");
        axios.get("http://localhost:5000/api/getPlayer/" + id).then(
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
                      this.teamOnePlayers.find(
                        (obj_added) =>
                          obj_added.id === obj.id &&
                          obj_added.name === obj.name &&
                          obj_added.src === obj.src
                      ) ||
                      this.teamTwoPlayers.find(
                        (obj_added) =>
                          obj_added.id === obj.id &&
                          obj_added.name === obj.name &&
                          obj_added.src === obj.src
                      )
                    ) {
                      this.error = "The player already exists in a team";
                    } else {
                      if (team === "one") {
                        this.teamOnePlayers.push(obj);
                      } else {
                        this.teamTwoPlayers.push(obj);
                      }
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
    async addPlayer(e) {
      e.preventDefault();
      let input = this.inputOne;

      if (this.pattern.test(input)) {
        this.generalAddPlayer(input, "one");
      } else {
        let team = await axios.get(helpers.api + "getTeamByName/" + input);
        if (team.data) {
          let ids = team.data.playerIds;
          for (let i = 0; i < ids.length; i++) {
            this.generalAddPlayer(ids[i], "one");
          }
        } else {
          this.error = "The input donot match player id or team name";
        }
      }
    },
    async addPlayer2(e) {
      e.preventDefault();

      let input = this.inputTwo;
      if (this.pattern.test(input)) {
        this.generalAddPlayer(input, "two");
      } else {
        let team = await axios.get(helpers.api + "getTeamByName/" + input);
        if (team.data) {
          let ids = team.data.playerIds;
          for (let i = 0; i < ids.length; i++) {
            this.generalAddPlayer(ids[i], "two");
          }
        } else {
          this.error = "The input donot match player id or team name";
        }
      }
    },
  },
};
</script>

<style scoped lang="scss">
.reservation-page {
  text-align: center;
}
.form-container {
  margin: 30px;
}
.button {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-top: 23px;
  margin-bottom: 7px;
}
.t {
  text-align: center;
  margin-bottom: 7px;
  background-color: green;
  color: white;
}
input,
select {
  margin-left: 5px;
}
.flex {
  display: flex;
  justify-content: space-evenly;
  margin-top: 30px;
}
h1 {
  margin: 0;
}
.form-container {
  display: flex;
  justify-content: space-evenly;
  align-items: center;
  margin-bottom: 20px;
}
.hidden {
  opacity: 0.07;
}
.form-item {
  margin-right: 20px;
}
* {
  color: green;
}
.h {
  border: 2px solid green;
  background-color: green;
  color: white;
}
.hh {
  margin-top: 20px;
  margin-bottom: 20px;
  background-color: green;
  color: white;
}
.time-slots {
  display: grid;
  gap: 15px;
  grid-template-columns: repeat(5, 1fr);
  @media (max-width: 768px) {
    grid-template-columns: repeat(2, 1fr);
  }
  padding: 20px;
}
button {
  /* margin-top: 30px; */
  padding: 15px;
}
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
.form-container2 {
  width: 600px;
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
input,
select {
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
