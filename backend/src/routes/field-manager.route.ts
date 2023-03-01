import express from 'express';
const managerController = require('../controllers/field-manager.controller');

const router = express.Router();

router.post('/newManagerProfile', managerController.createProfileInformation);
router.patch('/updateManager/:id', managerController.updateManagerById);
router.get('/getManager/:name', managerController.getManager);
router.get('/getAllManagers', managerController.getAllManagers);


module.exports = router;
