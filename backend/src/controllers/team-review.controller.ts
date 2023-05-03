import { Request, Response } from "express";

const teamReviewModel = require("../models/team-review.model.ts");

async function newTeamReview(req: Request, res: Response) {
  const teamReviewData = new teamReviewModel({
    teamName: req.body.teamName,
    reviewerName: req.body.reviewerName,
    moralityScore: req.body.moralityScore,
    skillLevel: req.body.skillLevel,
    reviewText: req.body.reviewText,
    submissionDate: req.body.submissionDate,
  });
  try {
    const teamReviewToSave = await teamReviewData.save();
    res.status(200).json(teamReviewToSave);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
}

async function getAllTeamReviews(req: Request, res: Response) {
  try {
    const allTeamReviews = await teamReviewModel.find();
    res.status(200).json(allTeamReviews);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
}

async function getATeamsReviews(req: Request, res: Response) {
  const teamName = req.params.teamName;
  try {
    const aTeamsReviews = await teamReviewModel.find({ teamName: teamName });
    res.status(200).json(aTeamsReviews);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
}

async function deleteTeamReviewById(req: Request, res: Response) {
  try {
    const id = req.params.id;
    const dataInJson = await teamReviewModel.findByIdAndDelete(id);
    const dataString = JSON.stringify(dataInJson);
    res.send(`Deleted team review with the following content:\n${dataString}`);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
}
async function updateTeamReview(req: Request, res: Response) {
  let id = req.params.id;
  let options = { new: true };
  let updatedData = req.body;
  try {
    let info = await teamReviewModel.findByIdAndUpdate(
      id,
      updatedData,
      options
    );
    res.status(200).json(info);
  } catch (Error) {
    res.status(400).json(Error.message);
  }
}

module.exports = {
  getAllTeamReviews,
  updateTeamReview,
  getATeamsReviews,
  newTeamReview,
  deleteTeamReviewById,
};
