import mongoose from 'mongoose';
const StarRatingSchema = require('./helpers/star-rating.schema.ts')

const playerReviewSchema = new mongoose.Schema({
    playerID: {
        type: Number,
        required: true,
    },
    reviewerID: {
        type: Number,
        required: true,
    },
    reviewText: {
        type: String,
        default: ""
    },
    skillLevel: {
        type: StarRatingSchema,
        required: true
    },
    moralityScore: {
        type: StarRatingSchema,
        required: true
    }
}, { collection: 'PlayerReview' }
);

module.exports = mongoose.model('PlayerReview', playerReviewSchema);