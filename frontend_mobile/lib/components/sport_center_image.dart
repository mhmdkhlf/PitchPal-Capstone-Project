import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants.dart';

class SportCenterPicture {
  String path;
  SportCenterPicture({required this.path});
}

Future<void> uploadImage(
    SportCenterPicture profilePicture, String email) async {
  //TODO: api call
}

// ignore: must_be_immutable
class SportCenterPictureInput extends StatefulWidget {
  SportCenterPictureInput({
    super.key,
    required this.profilePicture,
  });

  SportCenterPicture profilePicture;

  @override
  State<SportCenterPictureInput> createState() =>
      _SportCenterPictureInputState();
}

class _SportCenterPictureInputState extends State<SportCenterPictureInput> {
  final ImagePicker _picker = ImagePicker();

  ImageProvider displayImage() {
    if (widget.profilePicture.path == defaultSportCenterImagePath) {
      return const AssetImage(defaultSportCenterImagePath);
    }
    return FileImage(File(widget.profilePicture.path));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image(image: displayImage()),
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
                color: kLightColor,
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
