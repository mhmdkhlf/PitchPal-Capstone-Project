import express from 'express';
const userController = require('../controllers/userController');

const router = express.Router();

router.post('/isFirstTimeLogIn', userController.isFirstTimeLogIn);

module.exports = router;