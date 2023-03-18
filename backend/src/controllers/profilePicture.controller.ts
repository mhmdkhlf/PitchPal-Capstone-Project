import { Request, Response } from "express";
var multer = require("multer");

function uploadPicture(req: Request, res: Response) {
  // const imageName=req.body.imageName
  // res.status(200).json({imageName:imageName});
  var storage = multer.diskStorage({
    destination: function (request: any, file: any, callback: any) {
      callback(null, "./upload");
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
  upload(req, res, function (error: any) {
    if (error) {
      res.status(200).json({ status: "undone" });
    } else {
      res.status(200).json({ status: "done" });
    }
  });
}

module.exports = { uploadPicture };
