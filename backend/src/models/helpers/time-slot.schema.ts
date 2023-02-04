import mongoose from 'mongoose';

const TimeSlotSchema = new mongoose.Schema({
    startTime: {
        type: Date,
        required: true,
    },
    endTime: {
        type: Date,
        required: true
    },
}, { collection: 'TimeSlot' }
);

module.exports = TimeSlotSchema;