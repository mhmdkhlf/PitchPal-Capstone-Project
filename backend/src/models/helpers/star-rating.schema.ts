import mongoose from 'mongoose';

const StarRatingSchema = new mongoose.Schema({
    value: {
        type: Number,
        required: true,
        enum:[1,2,3,4,5]
    }
}, { collection: 'StarRating' }
);

module.exports = StarRatingSchema;