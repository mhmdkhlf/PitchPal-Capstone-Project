import mongoose from "mongoose";

const photosSchema = new mongoose.Schema(
  {
    email: String,
    img: {
      data: Buffer,
      contentType: String,
    },
  },
  { collection: "Photos" }
);

module.exports = mongoose.model("Photos", photosSchema);
