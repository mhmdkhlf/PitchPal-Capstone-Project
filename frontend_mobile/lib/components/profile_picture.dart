import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants.dart';

class ProfilePicture {
  String path;
  ProfilePicture({required this.path});
}

Future<void> uploadImage(ProfilePicture profilePicture, String email) async {
  if (profilePicture.path == defaultProfilePath) return;
  final dio = Dio();
  final String apiRoute = Platform.isAndroid
      ? 'http://10.0.2.2:5000/api'
      : 'http://localhost:5000/api';
  try {
    File image = File(profilePicture.path);
    String filePath = image.path;
    String fileName = filePath.split('/').last;
    var formData = FormData.fromMap({
      'email': email,
      'image': await MultipartFile.fromFile(filePath, filename: fileName),
    });
    await dio.post(
      '$apiRoute/uploadPicture',
      data: formData,
    );
  } on DioError catch (e) {
    throw Exception(e.response);
  }
}

// ignore: must_be_immutable
class ProfilePictureWidget extends StatefulWidget {
  ProfilePictureWidget({
    super.key,
    required this.profilePicture,
  });

  ProfilePicture profilePicture;

  @override
  State<ProfilePictureWidget> createState() => _ProfilePictureWidgetState();
}

class _ProfilePictureWidgetState extends State<ProfilePictureWidget> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            radius: 80.0,
            backgroundImage: widget.profilePicture.path == defaultProfilePath
                ? const AssetImage(defaultProfilePath)
                : FileImage(File(widget.profilePicture.path)) as ImageProvider,
          ),
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => bottomSheet()),
                );
              },
              child: const Icon(
                Icons.camera_alt,
                color: kDarkGreen,
                size: 28.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          const Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: const Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: const Text("Camera"),
            ),
            TextButton.icon(
              icon: const Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: const Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
    );
    setState(() {
      widget.profilePicture.path = pickedFile!.path;
    });
  }
}
