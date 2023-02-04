import express from 'express';
const AuthenticationController = require('../controllers/authentication.controller.ts');

const router = express.Router();

router.post('/logIn', AuthenticationController.tryLogIn);
router.post('/signUp', AuthenticationController.trySignUp);

module.exports = router;
