import express from 'express';
const playerReviewController = require('../controllers/player-review.controller.ts');

const router = express.Router();

router.post('/newPlayerReview', playerReviewController.newPlayerReview);

module.exports = router;
