import express from 'express';
const AuthenticationController = require('../controllers/authentication.controller.ts');

const router = express.Router();

router.post('/logIn', AuthenticationController.logInController);
router.post('/signUp', AuthenticationController.signUpController);


module.exports = router;
