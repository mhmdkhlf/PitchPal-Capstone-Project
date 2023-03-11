import express from 'express';
const userController = require('../controllers/user-controller');

const router = express.Router();

router.post('/isFirstTimeLogIn', userController.isFirstTimeLogIn);

module.exports = router;