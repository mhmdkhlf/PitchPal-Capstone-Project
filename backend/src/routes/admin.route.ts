import express from 'express';
const adminController = require('../controllers/admin.controller');

const router = express.Router();

router.post('/newAdminProfile', adminController.createProfileInformation);
router.patch('/updateAdmin/:id', adminController.updateAdminById);


module.exports = router;
