import {Request, Response} from 'express';
import mongoose from 'mongoose';
const teamModel = require('../models/team.model.ts');
const rating=require("../models/helpers/star-rating.schema.ts");
const rateModel=mongoose.model('Rate', rating)
async function newTeam(req: Request, res: Response) {
    const MoralRateSchema=new rateModel({value:1});
    const SkillRateSchema=new rateModel({value:1});
    const teamData = new teamModel({
        name: req.body.name,
        captainId: req.body.captainId,
        playerIds:req.body.playerIds,
        skillRating:SkillRateSchema,
        moralRating:MoralRateSchema

    });

    try {
        const sportCenterToSave = await teamData.save();
        res.status(200).json(sportCenterToSave);
    }
    catch (error) {
        res.status(400).json({ message: error.message });
    }
}
async function getTeamsByCaptain(req: Request, res: Response) {
    const captainId=req.params.captainId
    const teamData = await teamModel.find({captainId});

    try {
        res.status(200).json(teamData);
    }
    catch (error) {
        res.status(400).json({ message: error.message });
    }
}
async function getTeamByName(req: Request, res: Response) {
    const name=req.params.name
    const teamData = await teamModel.findOne({name});

    try {
        res.status(200).json(teamData);
    }
    catch (error) {
        res.status(400).json({ message: error.message });
    }
}
async function getAllTeams(req: Request, res: Response) {
    try {
        res.status(200).json(await teamModel.find());
    }
    catch (error) {
        res.status(400).json({ message: error.message });
    }
}


module.exports = { newTeam, getTeamByName,getTeamsByCaptain,getAllTeams };