import {Request, Response} from 'express';
const bcrypt = require('bcrypt');
const validator = require('validator');
const AuthenticationModel = require('../models/authentication.model.ts');


async function tryLogIn(req: Request, res: Response) {
    try{
        const {email, password, role} = req.body;
        if (!email || !password) {
            throw Error('All fields must be filled');
        }
        if (role!=="admin" && role!=="player" && role!=="field manager"){
            throw Error("Invalid Role");
        }

        const user = await AuthenticationModel.findOne({ email, role })
        if (!user) {
            throw Error('Incorrect email or role');
        }

        const match = await bcrypt.compare(password, user.password)
        if (!match) {
            throw Error('Incorrect password');
        }
        res.status(200).json({email, user});
    } catch(error){
        res.status(400).json({error: error.message});
    }
}

async function trySignUp(req: Request, res: Response) {
    try{
        const {email, password, role} = req.body;
        const exists = await AuthenticationModel.findOne({ email ,role });
        // validation
        if (!email || !password) {
            throw Error('All fields must be filled');
        }
        if (!validator.isEmail(email)) {
            throw Error('Email not valid');
        }
        if (!validator.isStrongPassword(password)) {
            throw Error('Password not strong enough');
        }
        if (role!=="admin" && role !=="player" && role!=="field manager"){
            throw Error("Invalid Role");
         }
        if (exists) {
            throw Error('Email already in use');
        }
        const salt = await bcrypt.genSalt(10);
        const hash = await bcrypt.hash(password, salt);
        const user = await AuthenticationModel.create({ email, password: hash, role });
        res.status(200).json({user});
    }
    catch(error){
        res.status(400).json({error: error.message});
    }
}

module.exports = {tryLogIn, trySignUp};