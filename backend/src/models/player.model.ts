import mongoose from "mongoose";
const LocationSchema = require("./helpers/location.schema.ts");
const PlayerSchema = new mongoose.Schema(
  {
    playerID: {
      type: String,
      required: true,
      unique: true,
    },
    name: {
      type: String,
      required: true,
    },
    email: {
      type: String,
      required: true,
      unique: true,
    },
    phoneNumber: {
      type: String,
      required: true,
    },
    location: {
      type: LocationSchema,
      required: true,
    },
    dateOfBirth: {
<<<<<<< HEAD
        type: Date,
    
    },
    picture: {
        type: String
    },
    height: {
        type: Number,
       
    },
    weight: {
        type: Number,
       
=======
      type: Date,
    },
    height: {
      type: Number,
    },
    weight: {
      type: Number,
>>>>>>> main
    },
    sex: {
      type: String,
      required: true,
      enum: ["M", "F"],
    },
    averageMoralityRating: {
      type: Number,
      default: 0,
    },
    averageSkillRating: {
      type: Number,
      default: 0,
    },
    numberOfReviews: {
      type: Number,
      default: 0,
    },
    position: {
      type: String,
      required: true,
      enum: ["goal keeper", "defender", "midfielder", "attacker"],
    },
    description: {
      type: String,
    },
  },
  { collection: "Player" }
);

module.exports = mongoose.model("Player", PlayerSchema);
