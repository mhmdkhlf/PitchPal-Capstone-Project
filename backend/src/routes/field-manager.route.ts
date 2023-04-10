import express from "express";
const managerController = require("../controllers/field-manager.controller");

const router = express.Router();

router.post("/newManagerProfile", managerController.createProfileInformation);
router.patch("/updateManager/:id", managerController.updateManagerById);
router.get("/getAllManagers", managerController.getAllManagers);
router.get("/getManager/:email", managerController.getManagerByEmail);

module.exports = router;
