import {Request, Response} from 'express';
const ManagerModel = require('../models/fieldManager.model');

async function updateProfileInformation(req: Request, res: Response){
    try{
        const {email,mobileNumber,name,sportCenterName}=req.body
        const managerInfo=await ManagerModel.create({email,mobileNumber,name,
            sportCenterName
           });
        res.status(200).json(managerInfo);    


    }catch(error){
        res.status(400).json(error.message);
    }
    

}
async function getManager(req: Request, res: Response){
    try{
        const name=req.params.name
        const managerInfo=await ManagerModel.findOne({name});
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


module.exports = {updateProfileInformation,getManager,getAllManagers};
