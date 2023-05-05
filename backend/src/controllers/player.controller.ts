import { Request, Response } from "express";
let playerModel = require("../models/player.model.ts");
let friendsModel = require("../models/friends.model");
let managerModel = require("../models/field-manager.model");
async function randomNumberGenerator(): Promise<Number> {
  var playerID = Math.floor(100000 + Math.random() * 900000);
  let user = await playerModel.findOne({ playerID });
  if (user) {
    return randomNumberGenerator();
  }
  return playerID;
}

async function updatePlayerById(req: Request, res: Response) {
  try {
    let id = req.params.id;
    let player = await playerModel.findOne({ _id: id });
    let playerEmail = player.email;
    let updatedData = req.body;
    let options = { new: true };
    const isExist = await playerModel.findOne({ email: req.body.email });
    const isExist2 = await managerModel.findOne({ email: req.body.email });
    if (req.body.email !== playerEmail && (isExist || isExist2)) {
      throw Error("Email already taken. Please use Another Email");
    }
    let result = await playerModel.findByIdAndUpdate(id, updatedData, options);
    res.send(result);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
}

async function createProfileInformation(req: Request, res: Response) {
  try {
    let id = await randomNumberGenerator();
    let playerID =
      id.toString().substring(0, 3) + "-" + id.toString().substring(3, 6);
    const data = {
      playerID: playerID,
      name: req.body.name,
      email: req.body.email,
      phoneNumber: req.body.phoneNumber,
      location: req.body.location,
      dateOfBirth: req.body.dateOfBirth,
      height: req.body.height,
      weight: req.body.weight,
      sex: req.body.sex,
      position: req.body.position,
      description: req.body.description,
    };
    const isExist = await playerModel.findOne({ email: data.email });
    const isExist2 = await managerModel.findOne({ email: data.email });
    if (isExist || isExist2) {
      throw Error("Email already taken. Please use Another Email");
    }
    let playerInfo = await playerModel.create(data);
    await friendsModel.create({ playerID, friendsIDs: [] });
    res.status(200).json(playerInfo);
  } catch (error) {
    console.log(error);
    res.status(400).json(error.message);
  }
}

async function getPlayerInformation(req: Request, res: Response) {
  try {
    let playerID = req.params.id;
    let playerInfo = await playerModel.findOne({ playerID });
    res.status(200).json(playerInfo);
  } catch (error) {
    res.status(400).json(error.message);
  }
}

async function getPlayerInformationByEmail(req: Request, res: Response) {
  try {
    let email = req.params.email;
    let playerInfo = await playerModel.findOne({ email });
    res.status(200).json(playerInfo);
  } catch (error) {
    res.status(400).json(error.message);
  }
}

async function getAllPlayers(req: Request, res: Response) {
  try {
    let playerInfo = await playerModel.find();
    res.status(200).json(playerInfo);
  } catch (error) {
    res.status(400).json(error.message);
  }
}
async function deletePlayer(req: Request, res: Response) {
  let email = req.params.email;
  try {
    await playerModel.deleteOne({ email });
    res.status(200).json({ res: "done" });
  } catch (error) {
    res.status(400).json(error.message);
  }
}
async function updatePlayerAverageRatingInCaseOfNewEdit(
  req: Request,
  res: Response
) {
  let playerID = req.body.playerID;
  let oldSkillReviewValue = req.body.oldSkillReviewValue;
  let oldMoralReviewValue = req.body.oldMoralReviewValue;
  let newSkillReviewValue = req.body.newSkillReviewValue;
  let newMoralReviewValue = req.body.newMoralReviewValue;
  let player = await playerModel.findOne({ playerID });
  let oldSkillAvg = player.data.averageSkillRating;
  let oldMoralAvg = player.data.averageMoralityRating;
  let nbOfReviews = player.data.numberOfReviews;
  let newSkillAvg =
    (oldSkillAvg * nbOfReviews - oldSkillReviewValue + newSkillReviewValue) /
    nbOfReviews;
  let newMoralAvg =
    (oldMoralAvg * nbOfReviews - oldMoralReviewValue + newMoralReviewValue) /
    nbOfReviews;
  let dbId = player.data._id;
  try {
    let options = { new: true };
    let info = await playerModel.findByIdAndUpdate(
      dbId,
      { averageMoralityRating: newMoralAvg, averageSkillRating: newSkillAvg },
      options
    );
    res.status(200).json(info);
  } catch (error) {
    res.status(400).json(error.message);
  }
}
async function updatePlayerAverageRatingInCaseOfNewReview(
  req: Request,
  res: Response
) {
  let playerID = req.body.playerID;
  let newSkillReviewValue = req.body.newSkillReviewValue;
  let newMoralReviewValue = req.body.newMoralReviewValue;
  let player = await playerModel.findOne({ playerID });
  let oldSkillAvg = player.data.averageSkillRating;
  let oldMoralAvg = player.data.averageMoralityRating;
  let oldNumberOfReviews = player.data.numberOfReviews;
  let newSkillAvg =
    (oldSkillAvg * oldNumberOfReviews + newSkillReviewValue) /
    (oldNumberOfReviews + 1);
  let newMoralAvg =
    (oldMoralAvg * oldNumberOfReviews + newMoralReviewValue) /
    (oldNumberOfReviews + 1);
  let dbId = player.data._id;
  try {
    let options = { new: true };
    let info = await playerModel.findByIdAndUpdate(
      dbId,
      {
        averageSkillRating: newSkillAvg,
        averageMoralityRating: newMoralAvg,
        oldNumberOfReviews: oldNumberOfReviews + 1,
      },
      options
    );
    res.status(200).json(info);
  } catch (error) {
    res.status(400).json(error.message);
  }
}

module.exports = {
  createProfileInformation,
  getPlayerInformation,
  getAllPlayers,
  updatePlayerById,
  getPlayerInformationByEmail,
  deletePlayer,
  updatePlayerAverageRatingInCaseOfNewReview,
  updatePlayerAverageRatingInCaseOfNewEdit,
};
