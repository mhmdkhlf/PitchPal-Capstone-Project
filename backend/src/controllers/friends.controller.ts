import {Request, Response} from 'express';
const FriendsModel = require('../models/friends.model.ts');

async function addFriend(req: Request, res: Response) {
    const player_id_1 = req.body.player_id_1;
    const player_id_2 = req.body.player_id_2;
    let playerDoc1 = await FriendsModel.findOne({player_id: player_id_1});
    let playerDoc2 = await FriendsModel.findOne({player_id: player_id_2});
    if (playerDoc1) {
        if (!playerDoc1.friends_ids.includes(player_id_2)) {
            playerDoc1.friends_ids.push(player_id_2);
        }
    }
    else {
        playerDoc1 = new FriendsModel({
            player_id: player_id_1,
            friends_ids: [player_id_2]
        });
    }
    if (playerDoc2) {
        if (!playerDoc2.friends_ids.includes(player_id_1)) {
            playerDoc2.friends_ids.push(player_id_1);
        }
    }
    else {
        playerDoc2 = new FriendsModel({
            player_id: player_id_2,
            friends_ids: [player_id_1]
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