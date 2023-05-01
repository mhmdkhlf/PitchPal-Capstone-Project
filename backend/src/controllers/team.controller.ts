import { Request, Response } from "express";
const teamModel = require("../models/team.model.ts");
const rating = require("../models/helpers/star-rating.schema.ts");

async function newTeam(req: Request, res: Response) {
  const teamData = new teamModel({
    name: req.body.name,
    captainId: req.body.captainId,
    playerIds: req.body.playerIds,
  });
  try {
    const exist = await teamModel.findOne({ name: req.body.name });
    if (exist) {
      throw Error("The name is taken by another team.");
    }
    const sportCenterToSave = await teamData.save();
    res.status(200).json(sportCenterToSave);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
}

async function getTeamsByCaptain(req: Request, res: Response) {
  const captainId = req.params.captainId;
  const teamData = await teamModel.find({ captainId });
  try {
    res.status(200).json(teamData);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
}

async function getAPlayersTeams(req: Request, res: Response) {
  const playerId = req.params.playerId;
  const teamsData = await teamModel.find({
    $or: [{ captainId: playerId }, { playerIds: playerId }],
  });
  try {
    res.status(200).json(teamsData);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
}

async function getTeamByName(req: Request, res: Response) {
  const name = req.params.name;
  const teamData = await teamModel.findOne({ name });

  try {
    res.status(200).json(teamData);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
}

async function getAllTeams(req: Request, res: Response) {
  try {
    res.status(200).json(await teamModel.find());
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
}
async function addPlayerToTeam(req: Request, res: Response) {
  const { teamName, playerId } = req.body;
  const teamDoc = await teamModel.findOne({ name: teamName });
  teamDoc.playerIds.push(playerId);
  try {
    const teamInfo = await teamDoc.save();
    res.status(200).json(teamInfo);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
}
async function deleteTeam(req: Request, res: Response) {
  let name = req.params.name;
  try {
    await teamModel.deleteOne({ name });
    res.status(200).json({ res: true });
  } catch (error) {
    res.status(400).json({ res: false });
  }
}
async function updateTeam(req: Request, res: Response) {
  let id = req.params.id;
  let updatedData = req.body;
  let options = { new: true };
  try {
    let team = await teamModel.findByIdAndUpdate(id, updatedData, options);
    res.status(200).json({ team });
  } catch (Error) {
    res.status(400).json({ error: Error.message });
  }
}

module.exports = {
  newTeam,
  getTeamByName,
  getTeamsByCaptain,
  getAllTeams,
  addPlayerToTeam,
  getAPlayersTeams,
  deleteTeam,
  updateTeam,
};
