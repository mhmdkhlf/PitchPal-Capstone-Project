import {Request, Response} from 'express';
const ManagerModel = require('../models/field-manager.model');

async function createProfileInformation(req: Request, res: Response){
    try{
        const {email, mobileNumber, name, sportCenterName} = req.body;
        const managerInfo = await ManagerModel.create({email, mobileNumber, name, sportCenterName});
        res.status(200).json(managerInfo);
    }catch(error){
        res.status(400).json(error.message);
    }

}
async function updateManagerById(req: Request, res: Response) {
    try {
        const id = req.params.id;
        const updatedData = req.body;
        const options = { new: true };
        const result = await ManagerModel.findByIdAndUpdate(
            id, updatedData, options
        )
        res.send(result);
    }
    catch (error) {
        res.status(400).json({ message: error.message })
    }
}
async function getManager(req: Request, res: Response){
    try{
        const name = req.params.name
        const managerInfo = await ManagerModel.findOne({name});
        res.status(200).json(managerInfo);
    }catch(error){
        res.status(400).json(error.message);
    }

}
async function getAllManagers(req: Request, res: Response){
    try{
        res.status(200).json(await ManagerModel.find());
    }catch(error){
        res.status(400).json(error.message);
    }
}

module.exports = {createProfileInformation, getManager, getAllManagers,updateManagerById};
