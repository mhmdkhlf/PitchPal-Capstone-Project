import { Request, Response } from "express";
import { stat } from "fs";
const FriendsModel = require("../models/friends.model.ts");

async function addFriend(req: Request, res: Response) {
  const playerID1 = req.body.playerID1;
  const playerID2 = req.body.playerID2;
  let playerDoc1 = await FriendsModel.findOne({ playerID: playerID1 });
  let playerDoc2 = await FriendsModel.findOne({ playerID: playerID2 });
  if (playerDoc1) {
    if (!playerDoc1.friendsIDs.includes(playerID2)) {
      playerDoc1.friendsIDs.push(playerID2);
    }
  } else {
    playerDoc1 = new FriendsModel({
      playerID: playerID1,
      friendsIDs: [playerID2],
    });
  }
  if (playerDoc2) {
    if (!playerDoc2.friendsIDs.includes(playerID1)) {
      playerDoc2.friendsIDs.push(playerID1);
    }
  } else {
    playerDoc2 = new FriendsModel({
      playerID: playerID2,
      friendsIDs: [playerID1],
    });
  }
  try {
    const friendDoc1ToSave = await playerDoc1.save();
    const friendDoc2ToSave = await playerDoc2.save();
    res.status(200).json([friendDoc1ToSave, friendDoc2ToSave]);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
}
async function FriendshipStatus(req: Request, res: Response) {
  const playerID1 = req.body.playerID1;
  const playerID2 = req.body.playerID2;
  const f1List = await FriendsModel.findOne({ playerID: playerID1 });
  const f2List = await FriendsModel.findOne({ playerID: playerID2 });
  let f1Friends = f1List.friendsIDs;
  let f2Friends = f2List.friendsIDs;
  var status = false;
  if (f1Friends.includes(playerID2) && f2Friends.includes(playerID1)) {
    status = true;
  }
  try {
    res.status(200).json({ status });
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
}
async function getNumberOfFriends(req: Request, res: Response) {
  const playerID = req.params.playerID;
  const fList = await FriendsModel.findOne({ playerID });
  let fFriends = fList.friendsIDs;
  let numberOfFriends = fFriends.length;
  try {
    res.status(200).json({ numberOfFriends });
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
}

module.exports = { addFriend, FriendshipStatus, getNumberOfFriends };
