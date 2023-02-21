import mongoose from 'mongoose';
const StarRatingSchema = require('./helpers/star-rating.schema.ts')

const PlayerReviewSchema = new mongoose.Schema({
    playerID: {
        type: String,
        required: true
    },
    reviewerID: {
        type: String,
        required: true
    },
    moralityScore: {
        type: StarRatingSchema,
        required: true
    },
    skillScore: {
        type: StarRatingSchema,
        required: true
    },
    commentText: {
        type: String,
        default: ""
    },
    submissionDate: {
        type: Date,
        default: Date.now
    }
}, { collection: 'PlayerReview' }
);

module.exports = mongoose.model('PlayerReview', PlayerReviewSchema);