import { Request, Response } from "express";

const SportCenterModel = require("../models/sport-center.model.ts");
const fieldModel = require("../models/field-manager.model");
async function newSportCenter(req: Request, res: Response) {
  const sportCenterData = new SportCenterModel({
    name: req.body.name,
    location: req.body.location,
    locationLink: req.body.locationLink,
    phoneNumber: req.body.phoneNumber,
    linkToFB: req.body.linkToFB,
    linkToInsta: req.body.linkToInsta,
    nbOfFields: req.body.nbOfFields,
    facilityQualityAverageRating: req.body.facilityQualityAverageRating,
    staffServiceAverageRating: req.body.staffServiceAverageRating,
    nbOfRatings: req.body.nbOfRatings,
    facilitiesAvailable: req.body.facilitiesAvailable,
    workingHours: req.body.workingHours,
  });
  try {
    const isExist = await SportCenterModel.findOne({ name: req.body.name });
    if (isExist) {
      throw Error("The name is already taken by another sport center");
    }
    const sportCenterToSave = await sportCenterData.save();
    res.status(200).json(sportCenterToSave);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
}

async function getAllSportCenters(req: Request, res: Response) {
  try {
    const sportCenters = await SportCenterModel.find();
    res.status(200).json(sportCenters);
  } catch (error) {
    res.status(400).json(error.message);
  }
}
async function getSportCenter(req: Request, res: Response) {
  try {
    const name = req.params.name;
    const sportCenters = await SportCenterModel.findOne({ name });
    res.status(200).json(sportCenters);
  } catch (error) {
    res.status(400).json(error.message);
  }
}

async function updateSportCenterById(req: Request, res: Response) {
  try {
    const id = req.params.id;
    const current = await SportCenterModel.findOne({ _id: id });
    const updatedData = req.body;
    const options = { new: true };
    const isExist = await SportCenterModel.findOne({ name: req.body.name });
    if (isExist && isExist.name !== current.name) {
      throw Error("The name is already taken by another sport center");
    }
    const result = await SportCenterModel.findByIdAndUpdate(
      id,
      updatedData,
      options
    );
    res.send(result);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
}

async function deleteSportCenterById(req: Request, res: Response) {
  try {
    const id = req.params.id;
    const dataInJson = await SportCenterModel.findByIdAndDelete(id);
    const dataString = JSON.stringify(dataInJson);
    await fieldModel.deleteMany({
      sportCenterName: dataInJson.sportCenterName,
    });
    res.send(`Deleted sport center with the following content:\n${dataString}`);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
}

module.exports = {
  newSportCenter,
  getAllSportCenters,
  updateSportCenterById,
  deleteSportCenterById,
  getSportCenter,
};
