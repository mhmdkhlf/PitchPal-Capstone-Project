import mongoose from 'mongoose';
const StarRatingSchema = require('./helpers/star-rating.schema.ts')
const teamSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
        unique: true
    },
    captainId:{
        type: String,
        required:true
    },
    playerIds:{
        type: Array,
        required:true
    },
    averageSkillRating:{
        type: Number,
        default: 0
    },
    averageMoralRating:{
        type: Number,
        default: 0
    },
    numberOfRatings: {
        type: Number,
        default:0
    }
}, { collection: 'Team' }
);

module.exports = mongoose.model('Team', teamSchema);