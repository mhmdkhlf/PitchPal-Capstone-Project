import express from "express";
const teamReviewController = require("../controllers/team-review.controller.ts");

const router = express.Router();

router.post("/newTeamReview", teamReviewController.newTeamReview);
router.get("/getATeamReviews/:teamName", teamReviewController.getATeamsReviews);
router.get("/getAllTeamReviews", teamReviewController.getAllTeamReviews);
router.delete(
  "/deleteTeamReview/:id",
  teamReviewController.deleteTeamReviewById
);
router.patch("/updateTeamReview/:id", teamReviewController.updateTeamReview);
router.post(
  "/getTeamReviewByTeamNameAndReviewerID",
  teamReviewController.getTeamReviewByTeamNameAndReviewerID
);

module.exports = router;
