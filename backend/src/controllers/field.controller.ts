import {Request, Response} from 'express';

const FieldModel = require('../models/field.model')

async function newField(req: Request, res: Response) {
    const fieldData = new FieldModel({
        sportCenterName: req.body.sportCenterName,
        fieldNumber: req.body.fieldNumber,
        fieldLength: req.body.fieldLength,
        fieldWidth: req.body.fieldWidth,
        grassType: req.body.grassType,
        recommendedTeamSize: req.body.recommendedTeamSize
    });
    try {
        const fieldToSave = await fieldData.save();
        res.status(200).json(fieldToSave);
    }
    catch (error) {
        res.status(400).json({ message: error.message });
    }
}
async function getFieldsBySportCenterName(req: Request, res: Response) {
    const sportCenterName = req.params.sportCenterName
    try{
        const fields = await FieldModel.find({sportCenterName: sportCenterName});
        res.status(200).json(fields);
    }catch(error){
        res.status(400).json(error.message);
    }
}

module.exports = { newField, getFieldsBySportCenterName};