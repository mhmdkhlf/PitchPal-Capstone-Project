import {Request, Response} from 'express';
import mongoose from 'mongoose';
const location=require("../models/helpers/location.schema.ts");
const locationModel=mongoose.model('Location', location)
const playerModel = require('../models/player.model.ts');


async function randomNumberGenerator():Promise<Number>{
    var player_id=Math.floor(100000 + Math.random() * 900000);
    const user=await playerModel.findOne({player_id});
    if (user){
        return randomNumberGenerator();
    }
    return player_id;
}
async function updateProfileInformation(req: Request, res: Response){
    const locationSchema=new locationModel({longitude:req.body.longitude,latitude:req.body.latitude});
    try{
        const id=await randomNumberGenerator();
        const player_id=id.toString().substring(0,3)+"-"+id.toString().substring(3,6);
        const playerInfo=await playerModel.create({player_id,name:req.body.name,email:req.body.email,
            phoneNumber:req.body.phoneNumber,
            location:locationSchema,age:req.body.age,picture:req.body.picture,height:req.body.height,
            weight:req.body.weight,sex:req.body.sex,moralityRating:2,skillRating:2,NumberOfReviews:0,position:req.body.position});
        res.status(200).json(playerInfo);    


    }catch(error){
        res.status(400).json(error.message);
    }
    

}
async function getPlayerInformation(req: Request, res: Response){
    try{
        const player_id=req.params.id;
        const playerInfo=await playerModel.findOne({player_id});
        res.status(200).json(playerInfo);    


    }catch(error){
        res.status(400).json(error.message);
    }
    

}
async function getAllPlayers(req: Request, res: Response){
    try{
        const playerInfo=await playerModel.find();
        res.status(200).json(playerInfo);    


    }catch(error){
        res.status(400).json(error.message);
    }
    

}

module.exports = {updateProfileInformation,getPlayerInformation,getAllPlayers};
