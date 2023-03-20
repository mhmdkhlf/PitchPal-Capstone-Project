import express from "express";
const router = express.Router();
const pictureController = require("../controllers/profile-picture.controller");

router.post("/uploadPicture", pictureController.uploadPicture);
router.get(
  "/getProfilePictureByEmail/:email",
  pictureController.getProfileByEmail
);
//router.post("/updateProfilePicture", pictureController.updatePicture);

module.exports = router;
