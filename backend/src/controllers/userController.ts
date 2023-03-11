import {Request, Response} from 'express';
const playerModel=require("../models/player.model");
const managerModel=require("../models/field-manager.model");


async function isFirstTimeLogIn(req: Request, res: Response) {
    const {userType,userEmail}=req.body
    try {
       if (userType==="player"){
        const isFound=await playerModel.findOne({email:userEmail});
        if (isFound){
            res.status(200).json({result:false})
        }else{
            res.status(200).json({result:true})
        }
       }else{
        const isFound=await managerModel.findOne({email:userEmail});
        if (isFound){
            res.status(200).json({result:false})
        }else{
            res.status(200).json({result:true})
        }

       }
    }
    catch (error) {
        res.status(400).json({ message: error.message });
    }
}





module.exports = {isFirstTimeLogIn};