import { Request, Response } from "express";
const teamModel = require("../models/team.model.ts");
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
//should be called before adding the new Review
async function updateTeamAverageRatingInCaseOfNewReview(
  req: Request,
  res: Response
) {
  let teamName = req.body.teamName;
  let newReviewSkillValue = req.body.newReviewSkillValue;
  let newReviewMoralValue = req.body.newReviewMoralValue;
  let team = await teamModel.findOne({ name: teamName });
  console.log(team);
  let oldSkillAvg = team.averageSkillRating;
  let oldMoralAvg = team.averageMoralRating;
  let nbOfReviews = team.numberOfRatings;
  let newSkillAvg =
    (oldSkillAvg * nbOfReviews + newReviewSkillValue) / (nbOfReviews + 1);
  let newMoralAvg =
    (oldMoralAvg * nbOfReviews + newReviewMoralValue) / (nbOfReviews + 1);
  let dbId = team._id;
  try {
    let options = { new: true };
    let info = await teamModel.findByIdAndUpdate(
      dbId,
      {
        averageMoralRating: newMoralAvg,
        averageSkillRating: newSkillAvg,
        numberOfRatings: nbOfReviews + 1,
      },
      options
    );
    res.status(200).json(info);
  } catch (error) {
    res.status(400).json(error.message);
  }
}
async function updateTeamAverageRatingInCaseOfNewEdit(
  req: Request,
  res: Response
) {
  let teamName = req.body.teamName;
  let oldSkillReviewValue = req.body.oldSkillReviewValue;
  let oldMoralReviewValue = req.body.oldMoralReviewValue;
  let newSkillReviewValue = req.body.newSkillReviewValue;
  let newMoralReviewValue = req.body.newMoralReviewValue;
  let team = await teamModel.findOne({ name: teamName });
  let oldSkillAvg = team.averageSkillRating;
  let oldMoralAvg = team.averageMoralRating;
  let numberOfReviews = team.numberOfRatings;
  let newSkillAvg =
    (oldSkillAvg * numberOfReviews -
      oldSkillReviewValue +
      newSkillReviewValue) /
    numberOfReviews;
  let newMoralAvg =
    (oldMoralAvg * numberOfReviews -
      oldMoralReviewValue +
      newMoralReviewValue) /
    numberOfReviews;
  let dbId = team._id;
  try {
    let options = { new: true };
    let info = await teamModel.findByIdAndUpdate(
      dbId,
      { averageSkillRating: newSkillAvg, averageMoralRating: newMoralAvg },
      options
    );
    res.status(200).json(info);
  } catch (error) {
    res.status(400).json(error.message);
  }
}

module.exports = {
  updateTeamAverageRatingInCaseOfNewEdit,
  updateTeamAverageRatingInCaseOfNewReview,
  newTeam,
  getTeamByName,
  getTeamsByCaptain,
  getAllTeams,
  addPlayerToTeam,
  getAPlayersTeams,
  deleteTeam,
  updateTeam,
};
