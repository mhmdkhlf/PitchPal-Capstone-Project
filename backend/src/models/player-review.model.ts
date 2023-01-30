import mongoose from 'mongoose';

const PlayerReviewSchema = new mongoose.Schema({
    player_id: {
        type: Number,
        required: true
    },
    reviewer_id: {
        type: Number,
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
});

module.exports = mongoose.model('PlayerReview', PlayerReviewSchema);