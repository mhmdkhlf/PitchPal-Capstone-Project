<template>
  <logo />
  <div class="reservation-page">
    <h1>Play in {{ sportcenterInfo.name }}</h1>

    <div class="form-container">
      <div class="form-item">
        <label for="field">Select Field Number:</label>
        <select id="field" v-model="selectedField">
          <option v-for="field in sportcenterInfo.numberOfFields" :key="field">
            {{ field }}
          </option>
        </select>
      </div>

      <div class="form-item">
        <label for="date">Select Date:</label>
        <input type="date" id="date" v-model="selectedDate" :min="minDate" />
      </div>
    </div>
    <h1>Available Slots</h1>
    <div class="time-slots">
      <!-- <div
        v-for="timeSlot in fieldTimes[selectedField]"
        :key="timeSlot.startTime"
        class="time-slot"
      >
        {{ timeSlot.startTime }} - {{ timeSlot.endTime }}
      </div> -->

      <timeSlot
        v-for="timeSlot in fieldTimes[selectedField]"
        :key="timeSlot.startTime"
        :startTime="timeSlot.startTime"
        :endTime="timeSlot.endTime"
        :type="`free`"
      />
    </div>
    <button>Confirm Reservation</button>
  </div>
</template>

<script>
import timeSlot from "./timeSlot.vue";
import logo from "./logo.vue";
export default {
  components: {
    timeSlot,
    logo,
  },
  computed: {
    minDate() {
      const today = new Date();
      console.log(today);
      console.log(today.toISOString());
      return today.toISOString().split("T")[0];
    },
  },
  data() {
    return {
      sportcenterInfo: null,
      selectedField: 1,
      selectedDate: "", // Default selected field
      fieldTimes: {},
    };
  },
  methods: {
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

<style scoped>
.reservation-page {
  text-align: center;
}
.form-container {
  margin: 30px;
}
input,
select {
  margin-left: 5px;
}
h1 {
  margin: 0;
}
.form-container {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-bottom: 20px;
}

.form-item {
  margin-right: 20px;
}
* {
  color: green;
}

.time-slots {
  /* display: grid;
  grid-template-columns: repeat(auto-fit, minmax(100px, 1fr));
  grid-gap: 10px;
  margin-top: 20px; */
  border: 3px solid green;
  display: grid;
  gap: 15px;
  grid-template-columns: repeat(5, 1fr);
  @media (max-width: 768px) {
    grid-template-columns: repeat(2, 1fr);
  }
  padding: 20px;
}
button {
  margin-top: 30px;
  padding: 15px;
}
</style>
