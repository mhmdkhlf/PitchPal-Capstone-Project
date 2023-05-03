import express from "express";
const playerReviewController = require("../controllers/player-review.controller.ts");

const router = express.Router();

router.post("/newPlayerReview", playerReviewController.newPlayerReview);
router.get(
  "/getAPlayersReviews/:playerID",
  playerReviewController.getAPlayersReviews
);
router.get("/getAllPlayerReviews", playerReviewController.getAllPlayerReviews);
router.delete(
  "/deletePlayerReview/:id",
  playerReviewController.deletePlayerReviewById
);
router.patch("updateReview/:id", playerReviewController.updateReview);

module.exports = router;
