import express from "express";
const friendController = require("../controllers/friends.controller");

const router = express.Router();

router.post("/addFriend", friendController.addFriend);
router.get(
  "/getNumberOfFriends/:playerID",
  friendController.getNumberOfFriends
);
router.get(
  "/getFriends/:playerID",
  friendController.getFriends
);
router.post("/areFriends", friendController.FriendshipStatus);

module.exports = router;
