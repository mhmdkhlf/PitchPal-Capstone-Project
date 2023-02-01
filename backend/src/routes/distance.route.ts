import express from 'express';
const distanceController = require('../controllers/get-distance.controller.ts');

const router = express.Router();

router.post('/calculate_distance', distanceController.calculateDistance);


module.exports = router;
