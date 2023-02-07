import {Request, Response} from 'express';
const AdminModel = require('../models/admin.model');

async function updateProfileInformation(req: Request, res: Response){
    try{
        const {email,mobileNumber,name}=req.body
        const adminInfo=await AdminModel.create({email,name,mobileNumber
           });
        res.status(200).json(adminInfo);    


    }catch(error){
        res.status(400).json(error.message);
    }
    

}

module.exports = {updateProfileInformation};
