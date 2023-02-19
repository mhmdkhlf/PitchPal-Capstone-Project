import express from 'express';
const sportCenterController = require('../controllers/sport-center.controller.ts');

const router = express.Router();

router.post('/newSportCenter', sportCenterController.newSportCenter);
router.get('/getAllSportCenters', sportCenterController.getAllSportCenters);

module.exports = router;