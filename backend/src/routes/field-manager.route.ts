import express from "express";
const managerController = require("../controllers/field-manager.controller");

const router = express.Router();

router.post("/newManagerProfile", managerController.createProfileInformation);
router.patch("/updateManager/:id", managerController.updateManagerById);
router.get("/getAllManagers", managerController.getAllManagers);
router.get("/getManager/:email", managerController.getManagerByEmail);
router.get(
  "/getManagersBySportCenterName/:sportCenterName",
  managerController.getManagersBySportCenterName
);
router.post(
  "/isManagerForSportCenter",
  managerController.isManagerForSportCenterName
);
router.delete("/deleteManager/:email", managerController.deleteManager);

module.exports = router;
