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
    const emailExist2 = await playerModel.findOne({ email });
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
    let manager = await ManagerModel.findOne({ _id: id });
    let managerEmail = manager.email;
    const updatedData = req.body;
    const options = { new: true };
    const emailExist = await ManagerModel.findOne({
      email: req.body.email,
    });
    const emailExist2 = await playerModel.findOne({ email: req.body.email });
    if (req.body.email !== managerEmail && (emailExist || emailExist2)) {
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

async function getManagerByEmail(req: Request, res: Response) {
  try {
    const email = req.params.email;
    const managerInfo = await ManagerModel.findOne({ email });
    res.status(200).json(managerInfo);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
}
async function getManagersBySportCenterName(req: Request, res: Response) {
  try {
    const sportCenterName = req.params.sportCenterName;
    const managerInfo = await ManagerModel.find({ sportCenterName });
    res.status(200).json(managerInfo);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
}
async function isManagerForSportCenterName(req: Request, res: Response) {
  try {
    const sportCenterName = req.body.sportCenterName;
    const email = req.body.email;
    const managerInfo = await ManagerModel.findOne({ sportCenterName, email });
    if (managerInfo) {
      res.status(200).json({ result: true });
    } else {
      res.status(200).json({ result: false });
    }
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
async function deleteManager(req: Request, res: Response) {
  let email = req.params.email;
  try {
    await ManagerModel.deleteOne({ email });
    res.status(200).json({ res: "done" });
  } catch (error) {
    res.status(400).json(error.message);
  }
}

module.exports = {
  createProfileInformation,
  getManagerByEmail,
  getAllManagers,
  updateManagerById,
  getManagersBySportCenterName,
  isManagerForSportCenterName,
  deleteManager,
};
