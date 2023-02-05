import mongoose from 'mongoose';
const LocationSchema = require('./helpers/location.schema.ts')
const PlayerSchema = new mongoose.Schema({
    player_id: {
        type: String,
        required: true,
        unique: true
    },
    name: {
        type: String,
        required: true
    },
    email: {
        type: String,
        required: true,
        unique:true
    }, 
    phoneNumber: {
        type: String,
        required: true
    },
    location: {
        type: LocationSchema,
        required: true
    },
    age: {
        type: Number,
        required: true
    },
    picture: {
        type: String
    },
    height: {
        type: Number,
        required: true
    },
    weight: {
        type: Number,
        required:true
    },
    sex: {
        type: String,
        required: true,
        enum: ["M","F"]
    },
    moralityRating: {
        type: Number
    },
    skillRating: {
        type: Number
    },
    numberOfReviews: {
        type: Number,
        default:0
    },
    position: {
        type: String,
        required: true,
        enum:["goal keeper","defender","midfielder","attacker"]
    },
}, { collection: 'Player' }
);

module.exports = mongoose.model('Player', PlayerSchema);