import mongoose from "mongoose";

const photosSchema = new mongoose.Schema(
  {
    email: {
      type: String,
      unique: true,
      required: true,
    },
    img: {
      data: Buffer,
      contentType: String,
    },
  },
  { collection: "Photos" }
);

module.exports = mongoose.model("Photos", photosSchema);
