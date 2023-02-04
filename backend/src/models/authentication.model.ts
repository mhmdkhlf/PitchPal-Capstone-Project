import mongoose from 'mongoose';

const AuthenticationSchema = new mongoose.Schema({
    email: {
        type: String,
        required: true,
        unique: true
    },
    password: {
        type: String,
        required: true
    },
    role: {
        type: String,
        required: true,
        enum: ['admin','player','field manager']
    }
}, { collection: 'Authentication' }
);

module.exports = mongoose.model('Authentication', AuthenticationSchema);