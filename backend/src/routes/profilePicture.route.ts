import express from "express";
const router = express.Router();
const pictureController = require("../controllers/profilePicture.controller");
//taking form data containing the img data and the email
router.post("/uploadPicture", pictureController.uploadPicture);
router.get(
  "/getProfilePictureByEmail/:email",
  pictureController.getProfileByEmail
);
//router.post("/updateProfilePicture", pictureController.updatePicture);

module.exports = router;
