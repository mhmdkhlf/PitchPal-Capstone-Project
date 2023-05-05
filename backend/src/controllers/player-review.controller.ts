import { Request, Response } from "express";

const PlayerReviewModel = require("../models/player-review.model.ts");

async function newPlayerReview(req: Request, res: Response) {
  const playerReviewData = new PlayerReviewModel({
    playerID: req.body.playerID,
    reviewerID: req.body.reviewerID,
    moralityScore: req.body.moralityScore,
    skillScore: req.body.skillScore,
    commentText: req.body.commentText,
    submissionDate: req.body.submissionDate,
  });
  try {
    const playerReviewToSave = await playerReviewData.save();
    res.status(200).json(playerReviewToSave);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
}

async function getAllPlayerReviews(req: Request, res: Response) {
  try {
    const allPlayerReviews = await PlayerReviewModel.find();
    res.status(200).json(allPlayerReviews);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
}

async function getAPlayersReviews(req: Request, res: Response) {
  const playerID = req.params.playerID;
  try {
    const aPlayersReviews = await PlayerReviewModel.find({
      playerID: playerID,
    });
    res.status(200).json(aPlayersReviews);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
}
async function updateReview(req: Request, res: Response) {
  let id = req.params.id;
  let options = { new: true };
  let updatedData = req.body;
  try {
    let info = await PlayerReviewModel.findByIdAndUpdate(
      id,
      updatedData,
      options
    );
    res.status(200).json(info);
  } catch (Error) {
    res.status(400).json(Error.message);
  }
}

async function deletePlayerReviewById(req: Request, res: Response) {
  try {
    const id = req.params.id;
    const dataInJson = await PlayerReviewModel.findByIdAndDelete(id);
    const dataString = JSON.stringify(dataInJson);
    res.send(
      `Deleted player review with the following content:\n${dataString}`
    );
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
}
async function getReviewByPlayerIdandReviewerId(req: Request, res: Response) {
  let playerID = req.body.playerID;
  let ReviewerID = req.body.reviewerID;
  try {
    let review = await PlayerReviewModel.findOne({ playerID, ReviewerID });
    res.status(200).json(review);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
}

module.exports = {
  getAllPlayerReviews,
  getAPlayersReviews,
  newPlayerReview,
  updateReview,
  deletePlayerReviewById,
  getReviewByPlayerIdandReviewerId,
};
