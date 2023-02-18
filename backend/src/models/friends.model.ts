import mongoose from 'mongoose';

const FriendsSchema = new mongoose.Schema({
    playerID: {
        type: String,
        required: true
    },
    friendsIDs: {
        type: [String],
        required: true,
        default: []
    }
}, { collection: 'Friends' }
);

module.exports = mongoose.model('Friends', FriendsSchema);