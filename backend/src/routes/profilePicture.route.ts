import express from "express";
const router = express.Router();
const pictureController = require("../controllers/profilePicture.controller");

router.post("/upload", pictureController.uploadPicture);

module.exports = router;
