import { Request, Response } from "express";
const ManagerModel = require("../models/field-manager.model");
const SportCenterModel = require("../models/sport-center.model");
const playerModel = require("../models/player.model");
async function createProfileInformation(req: Request, res: Response) {
  try {
    const { email, mobileNumber, name, sportCenterName } = req.body;
    const sportCenter = await SportCenterModel.findOne({
      name: sportCenterName,
    });
    if (!sportCenter) {
      throw Error(
        `There is no registered sport-center with the name '${sportCenterName}'`
      );
    }
    const emailExist = await ManagerModel.findOne({ email });
    const emailExist2 = await playerModel.find({ email });
    if (emailExist || emailExist2) {
      throw Error("The email is already taken by another user");
    }
    const managerInfo = await ManagerModel.create({
      email,
      mobileNumber,
      name,
      sportCenterName,
    });
    res.status(200).json(managerInfo);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
}
async function updateManagerById(req: Request, res: Response) {
  try {
    const id = req.params.id;
    const updatedData = req.body;
    const options = { new: true };
    const emailExist = await ManagerModel.findOne({
      email: req.body.email,
    });
    const emailExist2 = await playerModel.find({ email: req.body.email });
    if (emailExist || emailExist2) {
      throw Error("The email is already taken by another user");
    }
    const result = await ManagerModel.findByIdAndUpdate(
      id,
      updatedData,
      options
    );
    res.send(result);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
}
async function getManager(req: Request, res: Response) {
  try {
    const name = req.params.name;
    const managerInfo = await ManagerModel.findOne({ name });
    res.status(200).json(managerInfo);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
}
async function getAllManagers(req: Request, res: Response) {
  try {
    res.status(200).json(await ManagerModel.find());
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
}

module.exports = {
  createProfileInformation,
  getManager,
  getAllManagers,
  updateManagerById,
};
