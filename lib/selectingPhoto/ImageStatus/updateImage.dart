import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_tips/selectingPhoto/ImageStatus/saveImage.dart';

import 'getUserProfile.dart';

class EditProfileImage extends StatefulWidget {
  const EditProfileImage({
    Key? key,
    required this.name,
    required this.phoneNumber,
  }) : super(key: key);

  final String name;
  final String phoneNumber;

  @override
  State<EditProfileImage> createState() => _EditProfileImageState();
}

class _EditProfileImageState extends State<EditProfileImage> {
  XFile? _imageFile;
  String imageUrl = '';

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: source);

    setState(() {
      _imageFile = image;
    });
    imageUrl = await SaveImageProfile().uploadImageToStorage(_imageFile!.path);

    await GetUserProfile().updateProfileInfo(
      imageUrl,
      widget.name,
      int.parse(widget.phoneNumber),
    );
  }

  Future _showImageSourceDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit Profile Picture'),
            content: SizedBox(
              height: 150,
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    leading: const Icon(Icons.camera),
                    title: const Text('camera'),
                    onTap: () {
                      _pickImage(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('gallery'),
                    onTap: () {
                      _pickImage(ImageSource.gallery);
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          _showImageSourceDialog();
        },
        icon: const Icon(Icons.camera_alt));
  }
}
