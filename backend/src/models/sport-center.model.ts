import mongoose from 'mongoose';
const LocationSchema = require('./helpers/location.schema.ts')

const SportCenterSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
        unique: true
    },
    location: {
        type: LocationSchema,
        required: true
    }
}, { collection: 'SportCenter' }
);

module.exports = mongoose.model('SportCenter', SportCenterSchema);