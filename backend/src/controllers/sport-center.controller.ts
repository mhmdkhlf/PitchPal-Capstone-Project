import {Request, Response} from 'express';

const SportCenterModel = require('../models/sport-center.model.ts');

async function newSportCenter(req: Request, res: Response) {
    const sportCenterData = new SportCenterModel({
        name: req.body.name,
        location: req.body.location,
        phoneNumber: req.body.phoneNumber,
        profilePicture: req.body.profilePicture,
        linkToSocial: req.body.linkToSocial,
        nbOfFields: req.body.nbOfFields,
        facilityQualityAverageRating: req.body.facilityQualityAverageRating,
        staffServiceAverageRating: req.body.staffServiceAverageRating,
        nbOfRatings: req.body.nbOfRatings,
        facilitiesAvailable: req.body.facilitiesAvailable,
        workingHours: req.body.workingHours,
    });
    try {
        const sportCenterToSave = await sportCenterData.save();
        res.status(200).json(sportCenterToSave);
    }
    catch (error) {
        res.status(400).json({ message: error.message });
    }
}

module.exports = { newSportCenter };