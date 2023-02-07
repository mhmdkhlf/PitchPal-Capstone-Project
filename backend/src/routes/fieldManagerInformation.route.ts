import express from 'express';
const managerController = require('../controllers/managerInformation.controller');

const router = express.Router();

router.post('/updateManagerProfile', managerController.updateProfileInformation);
router.get('/getManager/:name', managerController.getManager);
router.get('/getAllManagers', managerController.getAllManagers);


module.exports = router;
