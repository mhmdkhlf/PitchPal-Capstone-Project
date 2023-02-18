import mongoose from 'mongoose';
const LocationSchema = require('./helpers/location.schema.ts')
const TimeSlotSchema = require('./helpers/time-slot.schema.ts')

const SportCenterSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
        unique: true
    },
    location: {
        type: LocationSchema,
        required: true
    },
    phoneNumber: {
        type: String,
        required: true
    },
    profilePicture: {
        type: String
    },
    linkToSocial: {
        type: String
    },
    nbOfFields: {
        type: Number,
        required: true
    },
    facilityQualityAverageRating: {
        type: Number,
        default: 0
    },
    staffServiceAverageRating: {
        type: Number,
        default: 0
    },
    nbOfRatings: {
        type: Number,
        default: 0
    },
    facilitiesAvailable: {
        type: String
    },
    workingHours: {
        type: TimeSlotSchema,
        required: true
    }
}, { collection: 'SportCenter' }
);

module.exports = mongoose.model('SportCenter', SportCenterSchema);