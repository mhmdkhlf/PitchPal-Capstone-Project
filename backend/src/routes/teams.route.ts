import express from "express";
const teamController = require("../controllers/team.controller");

const router = express.Router();

router.post("/newTeam", teamController.newTeam);
router.get("/getTeamsByCaptain/:captainId", teamController.getTeamsByCaptain);
router.get("/getTeamByName/:name", teamController.getTeamByName);
router.get("/getAPlayersTeams/:playerId", teamController.getAPlayersTeams);
router.get("/getAllTeams", teamController.getAllTeams);
router.post("/addPlayerToTeam", teamController.addPlayerToTeam);
router.delete("/deleteTeam/:name", teamController.deleteTeam);
module.exports = router;
