import {Request, Response} from 'express';

const SportCenterReviewModel = require('../models/sport-center-review.model.ts');

async function newSportCenterReview(req: Request, res: Response) {
    const sportCenterReviewData = new SportCenterReviewModel({
        sportCenterName: req.body.sportCenterName,
        reviewerID: req.body.reviewerID,
        reviewText: req.body.reviewText,
        staffServiceScore: req.body.staffServiceScore,
        facilityQualityScore: req.body.facilityQualityScore,
        submissionDate: req.body.submissionDate,
    });
    try {
        const sportCenterReviewToSave = await sportCenterReviewData.save();
        res.status(200).json(sportCenterReviewToSave);
    }
    catch (error) {
        res.status(400).json({ message: error.message });
    }
}

async function getAllSportCenterReviews(req: Request, res: Response) {
    try{
        const allSportCenterReviews = await SportCenterReviewModel.find();
        res.status(200).json(allSportCenterReviews);
    }
    catch(error){
        res.status(500).json({message: error.message})
    }
}

async function getASportCentersReviews(req: Request, res: Response) {
    const sportCenterName = req.params.sportCenterName;
    try{
        const aSportCentersReviews = await SportCenterReviewModel.find({sportCenterName: sportCenterName});
        res.status(200).json(aSportCentersReviews);
    }
    catch(error){
        res.status(500).json({message: error.message})
    }
}

async function deleteSportCenterReviewById(req: Request, res: Response) {
    try {
        const id = req.params.id;
        const dataInJson = await SportCenterReviewModel.findByIdAndDelete(id);
        const dataString = JSON.stringify(dataInJson);
        res.send(`Deleted sport center review with the following content:\n${dataString}`);
    }
    catch (error) {
        res.status(400).json({ message: error.message })
    }
}

module.exports = {getAllSportCenterReviews, getASportCentersReviews, newSportCenterReview, deleteSportCenterReviewById};