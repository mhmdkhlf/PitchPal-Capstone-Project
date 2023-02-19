import express from 'express';
const reservationController = require('../controllers/gameReservation.controller');

const router = express.Router();

router.post('/makeReservation', reservationController.makeReservation);
router.get('/getAllReservations',reservationController.getAllPublicReservations)
router.get('/getReservations/:sportCenterName',reservationController.getReservationsBySportCenterName)
router.get('/getReservationsById/:reserverId',reservationController.getReservationsByReserverId)
router.post('/addPlayerToMatch',reservationController.addPlayerToTeam)

module.exports = router;

