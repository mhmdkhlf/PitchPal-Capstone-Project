import mongoose from 'mongoose';
const TimeSlotSchema = require('./helpers/time-slot.schema.ts')

const reservationSchema = new mongoose.Schema({
    reserverID: {
        type: String,
        required: true
    },
    reserverType: {
        type: String,
        required: true,
        enum: ["Player", "FieldManager"]
    },
    fieldID: {
        type: String,
        required: true
    },
    isPublic: {
        type: Boolean,
        required: true
    },
    reservationTimeAndDate: {
        type: TimeSlotSchema,
        required: true
    },
    comment: {
        type: String,
        default: ""
    }
}, { collection: 'Reservation' }
);

module.exports = mongoose.model('Reservation', reservationSchema);