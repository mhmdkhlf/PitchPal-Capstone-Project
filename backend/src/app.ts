require('dotenv').config()

import express from 'express';
import mongoose from 'mongoose';

// DB initialization and connection
mongoose.set('strictQuery', true);
const mongoString = process.env.DATABASE_URL;

mongoose.connect(mongoString!);
const database = mongoose.connection;

database.on('error', (error) => {
    console.log(error)
})

database.once('connected', () => {
    console.log('Database Connected');
})

// Starting up Express application
const app = express();
app.use(express.json());

app.listen(5000, () => {
    console.log('Hello from PitchPal')
});

// Connecting AppReviewRoute to express server
const playerReviewRoutes = require('./routes/player-review.route.ts');
app.use('/api', playerReviewRoutes);
