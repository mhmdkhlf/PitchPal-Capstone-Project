import mongoose from 'mongoose';

const FriendsSchema = new mongoose.Schema({
    player_id: {
        type: String,
        required: true
    },
    friends_ids: {
        type: [String],
        required: true,
        default: []
    }
}, { collection: 'Friends' }
);

module.exports = mongoose.model('Friends', FriendsSchema);