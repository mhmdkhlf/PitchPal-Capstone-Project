import mongoose from "mongoose";

const TimeSlotSchema = new mongoose.Schema(
  {
    startTime: {
      type: String,
      required: true,
    },
    endTime: {
      type: String,
      required: true,
    },
  },
  { collection: "TimeSlot" }
);

module.exports = TimeSlotSchema;
