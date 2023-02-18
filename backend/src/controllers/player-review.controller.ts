import {Request, Response} from 'express';

const PlayerReviewModel = require('../models/player-review.model.ts');

async function newPlayerReview (req: Request, res: Response) {
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
    }
    catch (error) {
        res.status(400).json({ message: error.message });
    }
}

async function getPlayerReviews(req: Request, res: Response) {
    try{
        const allPlayerReviews = await PlayerReviewModel.find();
        res.status(200).json(allPlayerReviews);
    }
    catch(error){
        res.status(500).json({message: error.message})
    }
}

module.exports = {getPlayerReviews, newPlayerReview};