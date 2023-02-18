import mongoose from 'mongoose';

const PlayerReviewSchema = new mongoose.Schema({
    player_id: {
        type: String,
        required: true
    },
    reviewer_id: {
        type: String,
        required: true
    },
    morality_score: {
        type: Number,
        required: true
    },
    skill_score: {
        type: Number,
        required: true
    },
    comment_text: {
        type: String,
        required: false
    },
    submission_date: {
        type: Date,
        default: Date.now
    }
}, { collection: 'PlayerReview' }
);

module.exports = mongoose.model('PlayerReview', PlayerReviewSchema);