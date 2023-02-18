import {Request, Response} from 'express';
const FriendsModel = require('../models/friends.model.ts');

async function addFriend(req: Request, res: Response) {
    const playerID1 = req.body.playerID1;
    const playerID2 = req.body.playerID2;
    let playerDoc1 = await FriendsModel.findOne({playerID: playerID1});
    let playerDoc2 = await FriendsModel.findOne({playerID: playerID2});
    if (playerDoc1) {
        if (!playerDoc1.friendsIDs.includes(playerID2)) {
            playerDoc1.friendsIDs.push(playerID2);
        }
    }
    else {
        playerDoc1 = new FriendsModel({
            playerID: playerID1,
            friendsIDs: [playerID2]
        });
    }
    if (playerDoc2) {
        if (!playerDoc2.friendsIDs.includes(playerID1)) {
            playerDoc2.friendsIDs.push(playerID1);
        }
    }
    else {
        playerDoc2 = new FriendsModel({
            playerID: playerID2,
            friendsIDs: [playerID1]
        });
    }
    try {
        const friendDoc1ToSave = await playerDoc1.save();
        const friendDoc2ToSave = await playerDoc2.save();
        res.status(200).json([friendDoc1ToSave, friendDoc2ToSave]);
    }
    catch (error) {
        res.status(400).json({ message: error.message });
    }
}

module.exports = {addFriend};