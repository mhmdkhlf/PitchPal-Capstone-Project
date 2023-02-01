import express from 'express';
const playerReviewController = require('../controllers/player-review.controller.ts');

const router = express.Router();

router.post('/newPlayerReview', playerReviewController.newPlayerReview);
//get review
router.get('/getPlayerReviews', playerReviewController.getPlayerReviews);

module.exports = router;
