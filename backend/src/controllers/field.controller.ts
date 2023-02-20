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
async function updateFieldById(req: Request, res: Response) {
    try {
        const id = req.params.id;
        const updatedData = req.body;
        const options = { new: true };
        const result = await FieldModel.findByIdAndUpdate(
            id, updatedData, options
        )
        res.send(result);
    }
    catch (error) {
        res.status(400).json({ message: error.message })
    }
}
async function deleteFieldById(req: Request, res: Response) {
    try {
        const id = req.params.id;
        const dataInJson = await FieldModel.findByIdAndDelete(id);
        const dataString = JSON.stringify(dataInJson);
        res.send(`Document with ${dataString} has been deleted`);
    }
    catch (error) {
        res.status(400).json({ message: error.message })
    }
}

module.exports = { newField, getFieldsBySportCenterName, updateFieldById, deleteFieldById};