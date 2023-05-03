import express from "express";
const teamReviewController = require("../controllers/team-review.controller.ts");

const router = express.Router();

router.post("/newTeamReview", teamReviewController.newTeamReview);
router.get(
  "/getATeamsReviews/:teamName",
  teamReviewController.getATeamsReviews
);
router.get("/getAllTeamReviews", teamReviewController.getAllTeamReviews);
router.delete(
  "/deleteTeamReview/:id",
  teamReviewController.deleteTeamReviewById
);
router.patch("/updateTeamReview", teamReviewController.updateTeamReview);

module.exports = router;
