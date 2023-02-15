import express from 'express';
const playerController = require('../controllers/player.controller');

const router = express.Router();

router.post('/updatePlayerProfile', playerController.updateProfileInformation);
router.get('/getPlayer/:id', playerController.getPlayerInformation);
router.get('/getAllPlayers', playerController.getAllPlayers);


module.exports = router;
