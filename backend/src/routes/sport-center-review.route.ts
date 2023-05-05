import express from "express";
const sportCenterReviewController = require("../controllers/sport-center-review.controller.ts");

const router = express.Router();

router.post(
  "/newSportCenterReview",
  sportCenterReviewController.newSportCenterReview
);
router.get(
  "/getASportCentersReviews/:sportCenterName",
  sportCenterReviewController.getASportCentersReviews
);
router.get(
  "/getAllSportCenterReviews",
  sportCenterReviewController.getAllSportCenterReviews
);
router.delete(
  "/deleteSportCenterReview/:id",
  sportCenterReviewController.deleteSportCenterReviewById
);
router.patch(
  "updateSportCenterReview",
  sportCenterReviewController.updateSportCenterReview
);
router.post(
  "/getReviewBySportCenterNameAndReviewerId",
  sportCenterReviewController.getReviewBySportCenterNameAndReviewerId
);

module.exports = router;
