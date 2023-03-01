import {Request, Response} from 'express';
const AdminModel = require('../models/admin.model');

async function createProfileInformation(req: Request, res: Response){
    try{
        const {email, mobileNumber, name} = req.body
        const adminInfo = await AdminModel.create({email, name, mobileNumber});
        res.status(200).json(adminInfo);
    } catch(error) {
        res.status(400).json(error.message);
    }
}
async function updateAdminById(req: Request, res: Response) {
    try {
        const id = req.params.id;
        const updatedData = req.body;
        const options = { new: true };
        const result = await AdminModel.findByIdAndUpdate(
            id, updatedData, options
        )
        res.send(result);
    }
    catch (error) {
        res.status(400).json({ message: error.message })
    }
}

module.exports = {createProfileInformation,updateAdminById};
