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
    skillRating:{
        type: StarRatingSchema
    },
    moralRating:{
        type: StarRatingSchema
    }
}, { collection: 'Team' }
);

module.exports = mongoose.model('Team', teamSchema);