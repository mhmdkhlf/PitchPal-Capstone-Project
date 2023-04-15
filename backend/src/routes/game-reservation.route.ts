import express from "express";
const reservationController = require("../controllers/game-reservation.controller");

const router = express.Router();

router.post("/makeReservation", reservationController.makeReservation);
//done
router.get(
  "/getAllPublicReservationsOfToday",
  reservationController.getAllPublicReservationsOfToday
);
//done
router.get(
  "/getAllReservationsOfTodayBysportCenterName/:sportCenterName",
  reservationController.getAllReservationsOfTodayBysportCenterName
);
//done
router.get(
  "/getAllPendingReservationsBySportCenterForToday/:sportCenterName",
  reservationController.getAllPendingReservationsBySportCenterForToday
);
//done testing
router.get(
  "/getAllPendingReservationsBySportCenterForTodayAndAfter/:sportCenterName",
  reservationController.getAllPendingReservationsBySportCenterForTodayAndAfter
);
//done
router.patch(
  "/editReservationStatus",
  reservationController.editReservationStatus
);
//done
router.get(
  "/getReservationsByEmail/:reserverEmail",
  reservationController.getReservationsByReserverEmail
);
//tested previosuly
router.post("/addPlayerToMatch", reservationController.addPlayerToTeam);
//tested before
router.post("/updateTeamPlayers", reservationController.updateTeamPlayers);
//tested
router.get(
  "/getAccepteddReservationsBySportCenterNameOfTodayAndAfter/:sportCenterName",
  reservationController.getAccepteddReservationsBySportCenterNameOfTodayAndAfter
);

module.exports = router;
