require('dotenv').config()

import express from 'express';
import mongoose from 'mongoose';
const bodyParser = require('body-parser');
const cors = require('cors');

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
app.use(bodyParser.urlencoded({ extended: false })); // Parses urlencoded bodies
app.use(bodyParser.json()); // Send JSON responses
app.use(cors());
app.listen(5000, () => {
    console.log('Hello from PitchPal')
});


//routes
const playerReviewRoutes = require('./routes/player-review.route.ts');
const distanceRoutes = require('./routes/distance.route.ts');
const authenticationRoutes = require('./routes/authentication.route.ts');
const SportCenterRoutes = require('./routes/sport-center.route.ts');
const playerInfoRoutes = require('./routes/player.route');
const teamRoutes = require('./routes/team-formation.route');
const managerInfoRoutes = require('./routes/field-manager.route');
const adminInfoRoutes = require('./routes/admin.route');
const friendsRoutes = require('./routes/friends.route');
app.use('/api', playerReviewRoutes);
app.use('/api',distanceRoutes);
app.use('/api',authenticationRoutes);
app.use('/api', SportCenterRoutes);
app.use('/api', playerInfoRoutes);
app.use('/api', teamRoutes);
app.use('/api', managerInfoRoutes);
app.use('/api', adminInfoRoutes);
app.use('/api', friendsRoutes);


