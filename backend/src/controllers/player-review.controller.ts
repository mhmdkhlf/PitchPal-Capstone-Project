import {Request, Response} from 'express';

const PlayerReviewModel = require('../models/player-review.model.ts');

const newPlayerReview = async (req: Request, res: Response) => {
    const playerReviewData = new PlayerReviewModel({
        player_id: req.body.player_id,
        reviewer_id: req.body.reviewer_id,
        morality_score: req.body.morality_score,
        skill_score: req.body.skill_score,
        comment_text: req.body.comment_text,
        submission_date: req.body.submission_date,
    });

    try {
        const playerReviewToSave = await playerReviewData.save();
        res.status(200).json(playerReviewToSave);
    }
    catch (error) {
        res.status(400).json({ message: error.message });
    }
}

module.exports = {newPlayerReview};