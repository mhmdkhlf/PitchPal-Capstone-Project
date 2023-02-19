import {Request, Response} from 'express';
const reservationModel = require('../models/reservation.model');
const fieldModel=require('../models/field.model');
async function makeReservation(req: Request, res: Response) {
    const {reserverID, reserverType,fieldID,isPublic,reservationTimeAndDate,comment,teamOneIds,teamTwoIds}=req.body
    const reservationDetails={
        reserverID,
        reserverType,
        fieldID,
        isPublic,
        reservationTimeAndDate,
        comment,
        teamOneIds,
        teamTwoIds   
    }
    try {
        const reservationInfo=await reservationModel.create(reservationDetails)
       res.status(200).json(reservationInfo)
    }
    catch (error) {
        res.status(400).json({ message: error.message });
    }
}
async function addPlayerToTeam(req: Request, res: Response) {
    const {reservationId,playerId,teamNumber}=req.body
    const reservationDoc=await reservationModel.findOne({_id:reservationId})
    if (teamNumber===1){
        reservationDoc.teamOneIds.push(playerId)
    }else{
        //team 2
        reservationDoc.teamTwoIds.push(playerId)

    }
    try {
        const reservationInfo=await reservationDoc.save();
       res.status(200).json(reservationInfo)
    }
    catch (error) {
        res.status(400).json({ message: error.message });
    }
}
async function updateTeamPlayers(req: Request, res: Response) {
    const {reservationId,teamNumber,playerIds}=req.body
    const reservationDoc=await reservationModel.findOne({_id:reservationId})
    if (teamNumber===1){
        reservationDoc.teamOneIds=playerIds
    }else{
        //team 2
        reservationDoc.teamTwoIds=playerIds

    }
    try {
        const reservationInfo=await reservationDoc.save();
       res.status(200).json(reservationInfo)
    }
    catch (error) {
        res.status(400).json({ message: error.message });
    }
}

async function getAllPublicReservations(req: Request, res: Response) {
    try{
        const reservationInfo = await reservationModel.find({isPublic:true});
        res.status(200).json(reservationInfo);
    }catch(error){
        res.status(400).json(error.message);
    }
}
async function helper(field:any){
    const fieldID=field._id;
    const reservationsByField=await reservationModel.find({fieldID,isPublic:true})
    return {fieldId:fieldID,reservations:reservationsByField}

}
async function getReservationsBySportCenterName(req: Request, res: Response) {
    const sportCenterName = req.params.sportCenterName
    try{
        const fieldInfo = await fieldModel.find({sportCenterName});
        const reservations=await Promise.all(fieldInfo.map(helper));
        console.log(reservations)
        res.status(200).json(reservations);
    }catch(error){
        res.status(400).json(error.message);
    }
}
async function getReservationsByReserverId(req: Request, res: Response) {
    const reserverID = req.params.reserverId
    try{
        const reservationInfo = await reservationModel.find({reserverID, isPublic:true});
        res.status(200).json(reservationInfo);
    }catch(error){
        res.status(400).json(error.message);
    }
}

module.exports = {makeReservation, addPlayerToTeam, getAllPublicReservations,getReservationsBySportCenterName,getReservationsByReserverId,updateTeamPlayers};