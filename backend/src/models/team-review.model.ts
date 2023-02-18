import mongoose from 'mongoose';
const StarRatingSchema = require('./helpers/star-rating.schema.ts')

const teamReviewSchema = new mongoose.Schema({
    teamName: {
        type: String,
        required: true,
    },
    reviewerName: {
        type: String,
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
    },
    submissionDate: {
        type: Date,
        default: Date.now
    }
}, { collection: 'TeamReview' }
);

module.exports = mongoose.model('TeamReview', teamReviewSchema);