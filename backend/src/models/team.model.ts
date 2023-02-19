import mongoose from 'mongoose';
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
        type: [String],
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