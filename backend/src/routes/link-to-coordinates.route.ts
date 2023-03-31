import express from 'express';
const linkToCoordinatesController = require('../controllers/link-to-coordinates.controller');

const router = express.Router();

router.get('/linkToCoordinates', linkToCoordinatesController.getCoordinatesFromGoogleMapsLink);

module.exports = router;

