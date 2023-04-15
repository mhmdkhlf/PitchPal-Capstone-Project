import express from "express";
const reservationController = require("../controllers/game-reservation.controller");

const router = express.Router();

router.post("/makeReservation", reservationController.makeReservation);
router.get(
  "/getAllPublicReservationsOfToday",
  reservationController.getAllPublicReservationsOfToday
);
router.get(
  "/getAllReservationsOfTodayBysportCenterName/:sportCenterName",
  reservationController.getAllReservationsOfTodayBysportCenterName
);
router.get(
  "/getAllPendingReservationsBySportCenterForToday/:sportCenterName",
  reservationController.getAllPendingReservationsBySportCenterForToday
);
router.get(
  "/getAllPendingReservationsBySportCenterForTodayAndAfter/:sportCenterName",
  reservationController.getAllPendingReservationsBySportCenterForTodayAndAfter
);
router.patch(
  "/editReservationStatus",
  reservationController.editReservationStatus
);
router.get(
  "/getReservationsById/:reserverId",
  reservationController.getReservationsByReserverId
);
router.post("/addPlayerToMatch", reservationController.addPlayerToTeam);
router.post("/updateTeamPlayers", reservationController.updateTeamPlayers);
router.get(
  "getAccepteddReservationsBySportCenterNameOfTodayAndAfter/:sportCenterName",
  reservationController.getAccepteddReservationsBySportCenterNameOfTodayAndAfter
);

module.exports = router;
