import { Request, Response } from "express";
let playerModel = require("../models/player.model.ts");
let friendsModel = require("../models/friends.model");
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
    let updatedData = req.body;
    let options = { new: true };
    let result = await playerModel.findByIdAndUpdate(id, updatedData, options);
    res.send(result);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
}
//create player
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

async function getAllPlayers(req: Request, res: Response) {
  try {
    let playerInfo = await playerModel.find();
    res.status(200).json(playerInfo);
  } catch (error) {
    res.status(400).json(error.message);
  }
}

module.exports = {
  createProfileInformation,
  getPlayerInformation,
  getAllPlayers,
  updatePlayerById,
};
