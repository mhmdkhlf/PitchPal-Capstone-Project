import {Request, Response} from 'express';

const SportCenterModel = require('../models/sport-center.model.ts');

// TODO: work on this controlller next

async function newSportCenter(req: Request, res: Response) {
    const sportCenterData = new SportCenterModel({
        name: req.body.name,
        location: req.body.location,
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