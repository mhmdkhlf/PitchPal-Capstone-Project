import { Request, Response } from "express";
var multer = require("multer");
const photosModel = require("../models/photos.model");
var fs = require("fs");
var path = require("path");
async function uploadPicture(req: any, res: any) {
  var storage = multer.diskStorage({
    destination: function (request: any, file: any, callback: any) {
      callback(null, "./uploads");
    },
    filename: function (request: any, file: any, callback: any) {
      var temp_file_arr = file.originalname.split(".");

      var temp_file_name = temp_file_arr[0];

      var temp_file_extension = temp_file_arr[1];

      callback(
        null,
        temp_file_name + "-" + Date.now() + "." + temp_file_extension
      );
    },
  });

  var upload = multer({ storage: storage }).single("image");
  upload(req, res, async () => {
    // console.log(req.file);
    var obj = {
      email: req.body.email,
      img: {
        data: fs.readFileSync(
          path.join(__dirname + "/../../uploads/" + req.file.filename)
        ),
        contentType: req.file.mimetype,
      },
    };
    try {
      await photosModel.create(obj);
      res.status(200).json(obj);
    } catch (error) {
      res.status(400).json({ error });
    }
  });
}

module.exports = { uploadPicture };
