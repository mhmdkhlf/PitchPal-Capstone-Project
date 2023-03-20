require("dotenv").config();

import express from "express";
import mongoose from "mongoose";
const bodyParser = require("body-parser");
const cors = require("cors");
// var fs = require('fs');
// var path = require('path');

// DB initialization and connection
mongoose.set("strictQuery", true);
const mongoString = process.env.DATABASE_URL;

mongoose.connect(mongoString!);
const database = mongoose.connection;

database.on("error", (error) => {
  console.log(error);
});

database.once("connected", () => {
  console.log("Database Connected");
});

// Starting up Express application
const app = express();
app.use(express.json());
app.use(bodyParser.urlencoded({ extended: false })); // Parses urlencoded bodies
app.use(bodyParser.json()); // Send JSON responses
app.use(cors());
app.listen(5000, () => {
  console.log("Hello from PitchPal");
});

//routes
<<<<<<< HEAD
const playerReviewRoutes = require('./routes/player-review.route.ts');
const distanceRoutes = require('./routes/distance.route.ts');
const authenticationRoutes = require('./routes/authentication.route.ts');
const sportCenterRoutes = require('./routes/sport-center.route.ts');
const playerInfoRoutes = require('./routes/player.route');
const teamRoutes = require('./routes/teams.route');
const managerInfoRoutes = require('./routes/field-manager.route');
const adminInfoRoutes = require('./routes/admin.route');
const friendsRoutes = require('./routes/friends.route');
const reservationRoutes = require('./routes/game-reservation.route');
const fieldRoutes = require('./routes/field.route');
const sportCenterReviewRoutes = require('./routes/sport-center-review.route');
const teamReviewRoutes = require('./routes/team-review.route');
const generalUserRoutes = require('./routes/users-common-route');
app.use('/api', playerReviewRoutes);
app.use('/api',distanceRoutes);
app.use('/api',authenticationRoutes);
app.use('/api', sportCenterRoutes);
app.use('/api', playerInfoRoutes);
app.use('/api', teamRoutes);
app.use('/api', managerInfoRoutes);
app.use('/api', adminInfoRoutes);
app.use('/api', friendsRoutes);
app.use('/api', reservationRoutes);
app.use('/api', fieldRoutes);
app.use('/api', sportCenterReviewRoutes);
app.use('/api', teamReviewRoutes);
app.use('/api', generalUserRoutes);
=======
const playerReviewRoutes = require("./routes/player-review.route.ts");
const distanceRoutes = require("./routes/distance.route.ts");
const authenticationRoutes = require("./routes/authentication.route.ts");
const sportCenterRoutes = require("./routes/sport-center.route.ts");
const playerInfoRoutes = require("./routes/player.route");
const teamRoutes = require("./routes/teams.route");
const managerInfoRoutes = require("./routes/field-manager.route");
const adminInfoRoutes = require("./routes/admin.route");
const friendsRoutes = require("./routes/friends.route");
const reservationRoutes = require("./routes/game-reservation.route");
const fieldRoutes = require("./routes/field.route");
const sportCenterReviewRoutes = require("./routes/sport-center-review.route");
const teamReviewRoutes = require("./routes/team-review.route");
const generalUserRoutes = require("./routes/users-common-route");
const profilePictureRoutes = require("./routes/profile-picture.route");
app.use("/api", playerReviewRoutes);
app.use("/api", distanceRoutes);
app.use("/api", authenticationRoutes);
app.use("/api", sportCenterRoutes);
app.use("/api", playerInfoRoutes);
app.use("/api", teamRoutes);
app.use("/api", managerInfoRoutes);
app.use("/api", adminInfoRoutes);
app.use("/api", friendsRoutes);
app.use("/api", reservationRoutes);
app.use("/api", fieldRoutes);
app.use("/api", sportCenterReviewRoutes);
app.use("/api", teamReviewRoutes);
app.use("/api", generalUserRoutes);
app.use("/api", profilePictureRoutes);
//  const multer  = require('multer');
//  var storage = multer.diskStorage({
//     destination: (req:any, file:any, cb:any) => {
//         cb(null, 'uploads')
//     },
//     filename: (req:any, file:any, cb:any) => {
//         cb(null, file.fieldname + '-' + Date.now())
//     }
// });

//   const upload = multer({ storage: storage });

//   app.post('/upload', upload.single('image'), (req:any, res:any, next) => {

//        res.json({res:"done"});
//     //    var img= {
//     //         data: fs.readFileSync(path.join(__dirname + '/uploads/' + req.file.filename)),
//     //         contentType: 'image/png'
//     //     }
//     //     console.log(img);

//     // imgModel.create(obj, (err, item) => {
//     //     if (err) {
//     //         console.log(err);
//     //     }
//     //     else {
//     //         // item.save();
//     //         res.redirect('/');
//     //     }
//     // });
// });
>>>>>>> main
