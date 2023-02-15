import mongoose from 'mongoose';

const FriendsSchema = new mongoose.Schema({
    player_id: {
        type: Number,
        required: true
    },
    friends_ids: {
        type: [Number],
        required: true,
        default: []
    }
}, { collection: 'Friends' }
);

module.exports = mongoose.model('Friends', FriendsSchema);