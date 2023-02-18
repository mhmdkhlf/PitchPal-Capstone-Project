import mongoose from 'mongoose';

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
        type: Number,
        required: true
    },
    skillScore: {
        type: Number,
        required: true
    },
    commentText: {
        type: String,
        required: false
    },
    submissionDate: {
        type: Date,
        default: Date.now
    }
}, { collection: 'PlayerReview' }
);

module.exports = mongoose.model('PlayerReview', PlayerReviewSchema);