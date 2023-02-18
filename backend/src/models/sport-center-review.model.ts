import mongoose from 'mongoose';
const StarRatingSchema = require('./helpers/star-rating.schema.ts')

const sportCenterReviewSchema = new mongoose.Schema({
    sportCenterName: {
        type: String,
        required: true,
    },
    reviewerID: {
        type: String,
        required: true,
    },
    reviewText: {
        type: String,
        default: ""
    },
    staffServiceScore: {
        type: StarRatingSchema,
        required: true
    },
    facilityQualityScore: {
        type: StarRatingSchema,
        required: true
    }
}, { collection: 'SportCenterReview' }
);

module.exports = mongoose.model('SportCenterReview', sportCenterReviewSchema);