import express from "express";
const router = express.Router();
const sportCenterProfilePicture = require("../controllers/sportCenter-profile-picture.controller");

router.post(
  "/uploadSportCenterPicture",
  sportCenterProfilePicture.uploadSportCenterPicture
);
router.get(
  "/getSportCenterProfilePictureByName/:sportCenterName",
  sportCenterProfilePicture.getSportCenterProfileByName
);
router.post(
  "/updatesportCenterProfilePicture",
  sportCenterProfilePicture.updateSportCenterPicture
);

module.exports = router;
