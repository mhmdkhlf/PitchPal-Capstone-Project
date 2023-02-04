import mongoose from 'mongoose';

const LocationSchema = new mongoose.Schema({
    longitude: {
        type: Number,
        required: true,
    },
    latitude: {
        type: Number,
        required: true
    },
}, { collection: 'Location' }
);

module.exports = LocationSchema;