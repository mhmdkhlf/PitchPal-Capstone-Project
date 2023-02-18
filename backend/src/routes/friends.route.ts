import express from 'express';
const friendController = require('../controllers/friends.controller');

const router = express.Router();

router.post('/addFriend', friendController.addFriend);

module.exports = router;
