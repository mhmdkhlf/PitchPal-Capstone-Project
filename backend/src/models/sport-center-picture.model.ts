import mongoose from "mongoose";
const sportCenterPictureSchema = new mongoose.Schema(
  {
    sportCenterName: {
      type: String,
      unique: true,
      required: true,
    },
    img: {
      data: Buffer,
      contentType: String,
    },
  },
  { collection: "sportCenterPictureSchema" }
);

module.exports = mongoose.model("SportCenterPicture", sportCenterPictureSchema);
