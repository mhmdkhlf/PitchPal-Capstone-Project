import express from 'express';
const adminController = require('../controllers/admin.controller');

const router = express.Router();

router.post('/updateAdminProfile', adminController.updateProfileInformation);


module.exports = router;
