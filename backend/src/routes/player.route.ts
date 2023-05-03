import express from "express";
const playerController = require("../controllers/player.controller");

const router = express.Router();

router.post("/newPlayerProfile", playerController.createProfileInformation);
router.patch("/updatePlayerInformation/:id", playerController.updatePlayerById);
router.get("/getPlayer/:id", playerController.getPlayerInformation);
router.get(
  "/getPlayerByEmail/:email",
  playerController.getPlayerInformationByEmail
);
router.get("/getAllPlayers", playerController.getAllPlayers);
router.delete("/deletePlayer/:email", playerController.deletePlayer);
router.patch(
  "/updatePlayerAverageMoralityRatingInCaseOfNewReview",
  playerController.updatePlayerAverageMoralityRatingInCaseOfNewReview
);
router.patch(
  "/updatePlayerAverageSkillRatingInCaseOfNewReview",
  playerController.updatePlayerAverageSkillRatingInCaseOfNewReview
);
router.patch(
  "/updatePlayerAverageSkillRatingInCaseOfNewEdit",
  playerController.updatePlayerAverageSkillRatingInCaseOfNewEdit
);
router.patch(
  "/updatePlayerAverageMoralityRatingInCaseOfNewEdit",
  playerController.updatePlayerAverageMoralityRatingInCaseOfNewEdit
);
module.exports = router;
