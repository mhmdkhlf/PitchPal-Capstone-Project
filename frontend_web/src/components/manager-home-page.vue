<template>
  <loader v-if="this.$store.state.isLoading" />
  <div class="all" v-if="!this.$store.state.isLoading">
    <div class="nav">
      <h1>Welcome {{ managerInfo.name }}</h1>
      <a @click="managerProfile()">Your Profile</a>
      <a @click="makeReservation()">Make Reservation</a>
      <a @click="pendingReservations()">Pending Reservations</a>
      <a @click="sportCenterProfile()">{{ sportCenterInfo.name }}</a>
      <a @click="logOut()">Log Out</a>
    </div>
    <div class="form-container">
      <div class="form-item">
        <label for="field">Select Field Number:</label>
        <select id="field" v-model="selectedField">
          <option v-for="field in sportCenterInfo.nbOfFields" :key="field">
            {{ field }}
          </option>
        </select>
      </div>

      <div class="form-item">
        <label for="date">Select Date:</label>
        <input type="date" id="date" v-model="selectedDate" :min="minDate" />
      </div>
    </div>
    <h1 class="h">
      Sport Center Schedule (black for reserved , green for free and yellow for
      pending)
    </h1>
    <div class="time-slots">
      <timeSlot
        v-for="reser in fieldTimes[selectedField]"
        :key="reser.reservationTime.startTime"
        :startTime="reser.reservationTime.startTime"
        :endTime="reser.reservationTime.endTime"
        @selected="getTimeSlot"
        :type="getType(reser)"
      />
    </div>
  </div>
</template>
<script>
const helpers = require("../../helpers/authentication");
import loader from "./loader.vue";
import timeSlot from "./timeSlot.vue";
import axios from "axios";
export default {
  name: "manager-page",
  data() {
    return {
      managerInfo: this.$store.state.managerInfo,
      sportCenterInfo: this.$store.state.sportCenterInfo,
      fieldTimes: [],
      slots: [],
      allReservation: [],
      selectedField: 1,
      selectedDate: new Date().toJSON().slice(0, 10),
    };
  },
  watch: {
    selectedDate(newd) {
      this.$store.dispatch("setLoading");
      let today = newd;
      for (let i = 1; i <= this.sportCenterInfo.nbOfFields; i++) {
        this.fieldTimes[i] = [];
      }
      let todayAndAfterReservations = this.allReservation.filter((reser) => {
        if (reser.reservationDate.slice(0, 10) === today) {
          return true;
        }
        return false;
      });
      let perField = {};
      for (let i = 1; i <= this.sportCenterInfo.nbOfFields; i++) {
        perField[i] = todayAndAfterReservations.filter((r) => {
          if (r.fieldNumber === i) {
            return true;
          }
          return false;
        });
      }
      for (let i = 0; i < this.slots.length; i++) {
        let timeSlot = this.slots[i];
        for (let i = 1; i <= this.sportCenterInfo.nbOfFields; i++) {
          if (
            !perField[i]
              .map((r) => {
                return (
                  r.reservationTime.startTime + "-" + r.reservationTime.endTime
                );
              })
              .includes(timeSlot)
          ) {
            let startTime = timeSlot.split("-")[0];
            let endTime = timeSlot.split("-")[1];
            perField[i].push({
              reservationStatus: "free",
              reservationTime: { startTime, endTime },
            });
          }
        }
      }
      console.log(perField);
      this.fieldTimes = perField;
      this.$store.dispatch("stopLoading");
    },
  },
  components: {
    loader,
    timeSlot,
  },
  async beforeMount() {
    this.$store.dispatch("setLoading");
    let today = new Date().toJSON().slice(0, 10);
    for (let i = 1; i <= this.sportCenterInfo.nbOfFields; i++) {
      this.fieldTimes[i] = [];
    }
    this.slots = this.getTimeSlots(
      this.sportCenterInfo.workingHours.startTime,
      this.sportCenterInfo.workingHours.endTime
    );
    let allReservation = await axios.get(
      helpers.api +
        "getAllReservationsBySportCenter/" +
        this.sportCenterInfo.name
    );
    console.log(allReservation.data);
    this.allReservation = allReservation.data;
    let todayAndAfterReservations = allReservation.data.filter((reser) => {
      if (reser.reservationDate.slice(0, 10) === today) {
        return true;
      }
      return false;
    });
    console.log(todayAndAfterReservations);
    let perField = {};
    for (let i = 1; i <= this.sportCenterInfo.nbOfFields; i++) {
      perField[i] = todayAndAfterReservations.filter((r) => {
        if (r.fieldNumber === i) {
          return true;
        }
        return false;
      });
    }
    for (let i = 0; i < this.slots.length; i++) {
      let timeSlot = this.slots[i];
      for (let i = 1; i <= this.sportCenterInfo.nbOfFields; i++) {
        if (
          !perField[i]
            .map((r) => {
              return (
                r.reservationTime.startTime + "-" + r.reservationTime.endTime
              );
            })
            .includes(timeSlot)
        ) {
          let startTime = timeSlot.split("-")[0];
          let endTime = timeSlot.split("-")[1];
          perField[i].push({
            reservationStatus: "free",
            reservationTime: { startTime, endTime },
          });
        }
      }
    }
    console.log(perField);
    this.fieldTimes = perField;
    this.$store.dispatch("stopLoading");
  },

  computed: {
    minDate() {
      return new Date().toJSON().slice(0, 10);
    },
  },
  methods: {
    getTimeSlot(t) {
      var id = "";
      let f = this.fieldTimes[this.selectedField];
      for (let i = 0; i < f.length; i++) {
        if (
          f[i].reservationTime.startTime === t.startTime &&
          f[i].reservationTime.endTime === t.endTime
        ) {
          id = f[i]._id;
          break;
        }
      }
      if (id) {
        this.$router.push("/reservation/" + id);
      } else {
        this.push("/reservation-form/" + this.sportCenterInfo.name);
      }
    },
    getType(r) {
      console.log(r);
      if (r.reservationStatus === "pending") {
        return "pending";
      } else if (r.reservationStatus === "accepted") {
        return "reserved";
      } else {
        return "free";
      }
    },
    managerProfile() {
      this.$router.push("/manager-profile/" + this.managerInfo.email + "/true");
    },
    sportCenterProfile() {
      this.$router.push(
        "/sport-center-view/" + this.sportCenterInfo.name + "/true"
      );
    },
    pendingReservations() {
      this.$router.push("/pendingReservations");
    },
    makeReservation() {
      this.$router.push("/reservation-form/" + this.sportCenterInfo.name);
    },
    logOut() {
      sessionStorage.clear();
      this.$store.dispatch("setManagerInfo", null);
      this.$store.dispatch("setSportCenterInfo", null);
      this.$store.dispatch("setSportCenterFields", null);
      this.$router.push("/logIn");
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
  },
};
</script>
<style lang="scss" scoped>
.nav {
  background-color: green;
  color: white;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-left: 10px;
  padding-right: 10px;
}
a {
  text-decoration: underline;
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
.form-container {
  margin: 30px;
}
input,
select {
  margin-left: 5px;
}
.h {
  border: 2px solid green;
  background-color: green;
  color: white;
  text-align: center;
}
.form-container {
  display: flex;
  justify-content: space-evenly;
  align-items: center;
  margin-bottom: 20px;
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
.form-item {
  margin-right: 20px;
}
</style>
