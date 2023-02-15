import express from 'express';
const teamController = require('../controllers/team-formation.controller.ts');

const router = express.Router();

router.post('/newTeam', teamController.newTeam);
router.get('/getTeamByCaptain/:captainId', teamController.getTeamsByCaptain);
router.get('/getTeamByName/:name', teamController.getTeamByName);
router.get('/getAllTeams', teamController.getAllTeams);
module.exports = router;