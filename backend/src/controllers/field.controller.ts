import { Request, Response } from "express";

const FieldModel = require("../models/field.model");

async function newField(req: Request, res: Response) {
  const fieldData = new FieldModel({
    sportCenterName: req.body.sportCenterName,
    fieldNumber: req.body.fieldNumber,
    fieldLength: req.body.fieldLength,
    fieldWidth: req.body.fieldWidth,
    reservationPrice: req.body.reservationPrice,
    grassType: req.body.grassType,
    recommendedTeamSize: req.body.recommendedTeamSize,
  });
  try {
    const isExist = await FieldModel.findOne({
      sportCenterName: req.body.sportCenterName,
      fieldNumber: req.body.fieldNumber,
    });
    if (isExist) {
      throw Error(
        "You cant have two fields with the same number at the same sport center"
      );
    }
    const fieldToSave = await fieldData.save();
    res.status(200).json(fieldToSave);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
}
async function getFieldsBySportCenterName(req: Request, res: Response) {
  const sportCenterName = req.params.sportCenterName;
  try {
    const fields = await FieldModel.find({ sportCenterName: sportCenterName });
    res.status(200).json(fields);
  } catch (error) {
    res.status(400).json(error.message);
  }
}
async function updateFieldById(req: Request, res: Response) {
  try {
    const id = req.params.id;
    let field = await FieldModel.findOne({ _id: id });
    const updatedData = req.body;
    const options = { new: true };
    const isExist = await FieldModel.findOne({
      sportCenterName: req.body.sportCenterName,
      fieldNumber: req.body.fieldNumber,
    });
    if (
      isExist &&
      isExist.sportCenterName !== field.sportCenterName &&
      isExist.fieldNumber !== field.fieldNumber
    ) {
      throw Error(
        "You cant have two fields with the same number at the same sport center"
      );
    }
    const result = await FieldModel.findByIdAndUpdate(id, updatedData, options);
    res.send(result);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
}
async function deleteFieldById(req: Request, res: Response) {
  try {
    const id = req.params.id;
    const dataInJson = await FieldModel.findByIdAndDelete(id);
    const dataString = JSON.stringify(dataInJson);
    res.send(`Deleted field with the following content:\n${dataString}`);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
}

module.exports = {
  newField,
  getFieldsBySportCenterName,
  updateFieldById,
  deleteFieldById,
};
