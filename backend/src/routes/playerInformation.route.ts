import express from 'express';
const playerController = require('../controllers/playerInformation.controller');

const router = express.Router();

router.post('/updateProfile', playerController.updateProfileInformation);


module.exports = router;
