import mongoose from 'mongoose';

const fieldSchema = new mongoose.Schema({
    sportCenterName: {
        type: String,
        required: true,
    },
    fieldNumber: {
        type: Number,
        unique: true
    },
    fieldLength: {
        type: Number,
        required: true
    },
    fieldWidth: {
        type: Number,
        required: true
    },
    reservation_price: {
        type: Number,
        required: true
    },
    grassType: {
        type: String,
        required: true,
        enum: ["turf", "grass"]
    },
    recommendedTeamSize: {
        type: Number,
        required: true
    }
}, { collection: 'Field' }
);

module.exports = mongoose.model('Field', fieldSchema);