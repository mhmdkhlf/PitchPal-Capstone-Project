export {};
const multer = require("multer");
const sportCenterProfilePictureModel = require("../models/sport-center-picture.model");
const fs = require("fs");
const path = require("path");

async function uploadSportCenterPicture(req: any, res: any) {
  let storage = multer.diskStorage({
    destination: function (request: any, file: any, callback: any) {
      callback(null, "./uploads");
    },
    filename: function (request: any, file: any, callback: any) {
      let tempFileArr = file.originalname.split(".");
      let tempFileName = tempFileArr[0];
      let tempFileExtension = tempFileArr[1];
      callback(null, tempFileName + "-" + Date.now() + "." + tempFileExtension);
    },
  });

  let upload = multer({ storage: storage }).single("image");
  upload(req, res, async () => {
    let obj = {
      sportCenterName: req.body.sportCenterName,
      img: {
        data: fs.readFileSync(
          path.join(__dirname + "/../../uploads/" + req.file.filename)
        ),
        contentType: req.file.mimetype,
      },
    };
    try {
      await sportCenterProfilePictureModel.create(obj);
      res.status(200).json(obj);
    } catch (error) {
      res.status(400).json({ error });
    }
  });
}

async function getSportCenterProfileByName(req: any, res: any) {
  try {
    const sportCenterName = req.params.sportCenterName;
    const profile = await sportCenterProfilePictureModel.findOne({
      sportCenterName,
    });
    res.status(200).json(profile);
  } catch (error) {
    res.status(400).json(error.message);
  }
}

async function updateSportCenterPicture(req: any, res: any) {
  let storage = multer.diskStorage({
    destination: function (request: any, file: any, callback: any) {
      callback(null, "./uploads");
    },
    filename: function (request: any, file: any, callback: any) {
      let temp_file_arr = file.originalname.split(".");

      let temp_file_name = temp_file_arr[0];

      let temp_file_extension = temp_file_arr[1];

      callback(
        null,
        temp_file_name + "-" + Date.now() + "." + temp_file_extension
      );
    },
  });

  let upload = multer({ storage: storage }).single("image");
  upload(req, res, async () => {
    // console.log(req.file);
    let obj = {
      email: req.body.email,
      img: {
        data: fs.readFileSync(
          path.join(__dirname + "/../../uploads/" + req.file.filename)
        ),
        contentType: req.file.mimetype,
      },
    };
    try {
      await sportCenterProfilePictureModel.deleteOne({
        sportCenterName: req.body.sportCenterName,
      });
      await sportCenterProfilePictureModel.create(obj);
      res.status(200).json(obj);
    } catch (error) {
      res.status(400).json({ error });
    }
  });
}
async function deleteSportCenterPicture(req: any, res: any) {
  try {
    await photosModel.deleteOne({ name: req.params.name });
    res.status(200).json({ result: "done" });
  } catch (Error) {
    res.status(400).json({ result: "Failed" });
  }
}

module.exports = {
  uploadSportCenterPicture,
  updateSportCenterPicture,
  getSportCenterProfileByName,
  deleteSportCenterPicture,
};
