import express from 'express';
const adminController = require('../controllers/adminInformation.controller');

const router = express.Router();

router.post('/updateAdminProfile', adminController.updateProfileInformation);


module.exports = router;
