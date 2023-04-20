import express from "express";
const AuthenticationController = require("../controllers/authentication.controller.ts");

const router = express.Router();

router.post("/logIn", AuthenticationController.tryLogIn);
router.post("/signUp", AuthenticationController.trySignUp);
router.delete("/deleteUser/:email", AuthenticationController.deleteUser);

module.exports = router;
