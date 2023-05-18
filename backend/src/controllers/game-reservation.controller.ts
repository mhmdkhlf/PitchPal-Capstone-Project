import { Request, Response } from "express";
const reservationModel = require("../models/reservation.model");

async function makeReservation(req: Request, res: Response) {
  const {
    reserverEmail,
    reserverType,
    fieldNumber,
    isPublic,
    comment,
    teamOneIds,
    teamTwoIds,
    reservationStatus,
    reservationDate, //should be today date in this form `"2022-06-17"`; (ie when reservation occurs)
    reservationTime,
    sportCenterName,
  } = req.body;
  const reservationDetails = {
    sportCenterName,
    reserverEmail,
    reserverType,
    fieldNumber,
    isPublic,
    reservationStatus,
    reservationDate,
    reservationTime,
    comment,
    teamOneIds,
    teamTwoIds,
  };
  try {
    const reservationInfo = await reservationModel.create(reservationDetails);
    res.status(200).json(reservationInfo);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
}

async function getAllReservationsBySportCenter(req: Request, res: Response) {
  try {
    const sportCenterName = req.params.sportCenterName;
    const reservationInfo = await reservationModel.find({ sportCenterName });
    res.status(200).json(reservationInfo);
  } catch (error) {
    res.status(400).json(error.message);
  }
}
//today notifications for managers
async function getAllPendingReservationsBySportCenterForToday(
  req: Request,
  res: Response
) {
  let currentDate = new Date().toJSON().slice(0, 10);
  console.log(new Date(currentDate));
  try {
    const sportCenterName = req.params.sportCenterName;
    const reservationInfo = await reservationModel.find({
      reservationStatus: "pending",
      sportCenterName,
      reservationDate: new Date(currentDate),
    });
    res.status(200).json(reservationInfo);
  } catch (error) {
    res.status(400).json(error.message);
  }
}
//all notifications for managers
async function getAllPendingReservationsBySportCenterForTodayAndAfter(
  req: Request,
  res: Response
) {
  let currentDate = new Date().toJSON().slice(0, 10);
  try {
    const sportCenterName = req.params.sportCenterName;
    const reservationInfo = await reservationModel.find({
      reservationStatus: "pending",
      sportCenterName,
      reservationDate: { $gte: currentDate },
    });
    res.status(200).json(reservationInfo);
  } catch (error) {
    res.status(400).json(error.message);
  }
}

//after the manager responds: (ie change to accepted or rejected)
async function editReservationStatus(req: Request, res: Response) {
  try {
    let id = req.body.reservationId;
    let status = req.body.status;
    let updatedData = { reservationStatus: status };
    let options = { new: true };
    let result = await reservationModel.findByIdAndUpdate(
      id,
      updatedData,
      options
    );
    res.send(result);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
}

async function addPlayerToTeam(req: Request, res: Response) {
  const { reservationId, playerId, teamNumber } = req.body;
  const reservationDoc = await reservationModel.findOne({ _id: reservationId });
  if (teamNumber === 1) {
    reservationDoc.teamOneIds.push(playerId);
  } else {
    //team 2
    reservationDoc.teamTwoIds.push(playerId);
  }
  try {
    const reservationInfo = await reservationDoc.save();
    res.status(200).json(reservationInfo);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
}
async function updateTeamPlayers(req: Request, res: Response) {
  const { reservationId, teamNumber, playerIds } = req.body;
  const reservationDoc = await reservationModel.findOne({ _id: reservationId });
  if (teamNumber === 1) {
    reservationDoc.teamOneIds = playerIds;
  } else {
    //team 2
    reservationDoc.teamTwoIds = playerIds;
  }
  try {
    const reservationInfo = await reservationDoc.save();
    res.status(200).json(reservationInfo);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
}
//for views so that any player can join
async function getAllPublicReservationsOfToday(req: Request, res: Response) {
  try {
    let currentDate = new Date().toJSON().slice(0, 10);
    const reservationInfo = await reservationModel.find({
      isPublic: true,
      reservationDate: new Date(currentDate),
      reservationStatus: "accepted",
    });
    res.status(200).json(reservationInfo);
  } catch (error) {
    res.status(400).json(error.message);
  }
}

//for views so that any player can join
async function getUpcomingPublicMatches(req: Request, res: Response) {
  try {
    let currentDate = new Date().toJSON().slice(0, 10);
    const reservationInfo = await reservationModel.find({
      isPublic: true,
      reservationDate: { $gte: currentDate },
      reservationStatus: "accepted",
    });
    res.status(200).json(reservationInfo);
  } catch (error) {
    res.status(400).json(error.message);
  }
}

//get all acceptedfor today by sport Center Name
async function getAllReservationsOfTodayBysportCenterName(
  req: Request,
  res: Response
) {
  try {
    let currentDate = new Date().toJSON().slice(0, 10);
    let sportCenterName = req.params.sportCenterName;
    const reservationInfo = await reservationModel.find({
      sportCenterName,
      reservationDate: new Date(currentDate),
      reservationStatus: "accepted",
    });
    res.status(200).json(reservationInfo);
  } catch (error) {
    res.status(400).json(error.message);
  }
}
//all accepted and valid ones
async function getAcceptedReservationsBySportCenterNameOfTodayAndAfter(
  req: Request,
  res: Response
) {
  const sportCenterName = req.params.sportCenterName;
  let currentDate = new Date().toJSON().slice(0, 10);
  try {
    const reservations = await reservationModel.find({
      sportCenterName,
      reservationStatus: "accepted",
      reservationDate: { $gte: currentDate },
    });
    res.status(200).json(reservations);
  } catch (error) {
    res.status(400).json(error.message);
  }
}
async function getReservationsByReserverEmail(req: Request, res: Response) {
  const reserverEmail = req.params.reserverEmail;
  let currentDate = new Date().toJSON().slice(0, 10);
  try {
    const reservationInfo = await reservationModel.find({
      reserverEmail,
      isPublic: true,
      $or: [
        { reservationStatus: "pending" },
        { reservationStatus: "accepted" },
      ],
      reservationDate: new Date(currentDate),
    });
    res.status(200).json(reservationInfo);
  } catch (error) {
    res.status(400).json(error.message);
  }
}
async function getReservationById(req: Request, res: Response) {
  let id = req.params.id;
  try {
    let reservation = await reservationModel.findById(id);
    res.status(200).json(reservation);
  } catch (error) {
    res.status(400).json(error);
  }
}
async function deleteReservation(req: Request, res: Response) {
  let id = req.params.id;
  try {
    let reservation = await reservationModel.findByIdAndDelete(id);
    res.status(200).json(reservation);
  } catch (error) {
    res.status(400).json(error);
  }
}

async function getAPlayersUpcomingMatches(req: Request, res: Response) {
  const playerId = req.body.id;
  const playerEmail = req.body.email;
  let todaysDate = new Date().toJSON().slice(0, 10);
  const teamsData = await reservationModel.find({
    reservationDate: { $gte: todaysDate },
    reservationStatus: "accepted",
    $or: [{ reserverEmail: playerEmail }, { teamOneIds : playerId }, { teamTwoIds : playerId }],
  });
  try {
    res.status(200).json(teamsData);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
}

async function getAllReservationsByEmail(req: Request, res: Response) {
  const reserverEmail = req.params.reserverEmail;
  try {
    const reservationInfo = await reservationModel.find({ reserverEmail });
    res.status(200).json(reservationInfo);
  } catch (error) {
    res.status(400).json(error.message);
  }
}

module.exports = {
  deleteReservation,
  getReservationById,
  makeReservation,
  addPlayerToTeam,
  getAllReservationsBySportCenter,
  getAllPendingReservationsBySportCenterForToday,
  getAllPendingReservationsBySportCenterForTodayAndAfter,
  getReservationsByReserverEmail,
  updateTeamPlayers,
  editReservationStatus,
  getAllPublicReservationsOfToday,
  getAcceptedReservationsBySportCenterNameOfTodayAndAfter,
  getAllReservationsOfTodayBysportCenterName,
  getAPlayersUpcomingMatches,
  getAllReservationsByEmail,
  getUpcomingPublicMatches
};
