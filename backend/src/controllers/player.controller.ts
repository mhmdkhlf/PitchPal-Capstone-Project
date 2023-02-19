import {Request, Response} from 'express';
const playerModel = require('../models/player.model.ts');
async function randomNumberGenerator():Promise<Number>{
    var playerId = Math.floor(100000 + Math.random() * 900000);
    const user = await playerModel.findOne({playerId});
    if (user) {
        return randomNumberGenerator();
    }
    return playerId;
}

async function updateProfileInformation(req: Request, res: Response){
    try{
        const id = await randomNumberGenerator();
        const playerID = id.toString().substring(0,3)+"-"+id.toString().substring(3,6);
        const playerInfo = await playerModel.create( {
            playerID: playerID,
            name: req.body.name,
            email: req.body.email,
            phoneNumber: req.body.phoneNumber,
            location: req.body.location,
            age: req.body.age,
            picture: req.body.picture,
            height: req.body.height,
            weight: req.body.weight,
            sex: req.body.sex,
            moralityRating: req.body.averageMoralityScore,
            skillRating: req.body.averageSkillRating,
            numberOfReviews: req.body.numberOfReviews,
            position: req.body.position
        });
        res.status(200).json(playerInfo);
    } catch(error) {
        res.status(400).json(error.message);
    }
}

async function getPlayerInformation(req: Request, res: Response){
    try{
        const playerId = req.params.id;
        const playerInfo = await playerModel.findOne({playerId});
        res.status(200).json(playerInfo);
    }catch(error){
        res.status(400).json(error.message);
    }
}

async function getAllPlayers(req: Request, res: Response){
    try{
        const playerInfo = await playerModel.find();
        res.status(200).json(playerInfo);
    }catch(error){
        res.status(400).json(error.message);
    }
}

module.exports = {updateProfileInformation, getPlayerInformation, getAllPlayers};