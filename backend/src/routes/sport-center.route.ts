import express from "express";
const sportCenterController = require("../controllers/sport-center.controller.ts");

const router = express.Router();

router.post("/newSportCenter", sportCenterController.newSportCenter);
router.get("/getAllSportCenters", sportCenterController.getAllSportCenters);
router.get("/getSportCenter/:name", sportCenterController.getSportCenter);
router.patch(
  "/updateSportCenter/:id",
  sportCenterController.updateSportCenterById
);
router.delete(
  "/deleteSportCenter/:id",
  sportCenterController.deleteSportCenterById
);
router.patch(
  "/updateSportCenterQualityAverageRatingInCaseOfNewEdit",
  sportCenterController.updateSportCenterQualityAverageRatingInCaseOfNewEdit
);
router.patch(
  "/updateSportCenterFacilityAverageRatingInCaseOfNewReview",
  sportCenterController.updateSportCenterFacilityAverageRatingInCaseOfNewReview
);

module.exports = router;
