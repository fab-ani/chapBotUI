import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/auth.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({Key? key, required this.onImageSelected})
      : super(key: key);
  final Function(String) onImageSelected;

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

AuthServices _auth = AuthServices();

class _ProfilePictureState extends State<ProfilePicture> {
  XFile? _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: source);

    setState(() {
      _imageFile = image;
      widget.onImageSelected(_imageFile!.path);
      print("IMAGE PATHHHH${_imageFile!.path}");
      print("IMAGE FILE ${_imageFile}");
    });
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
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: const Color(0xffff5722),
          radius: 40,
          backgroundImage: _imageFile != null
              ? FileImage(
                  File(_imageFile!.path),
                )
              : null,
          child: _imageFile == null
              ? const Icon(
                  Icons.person,
                  color: Colors.grey,
                  size: 40,
                )
              : null,
        ),
        const SizedBox(
          width: 20,
        ),
        TextButton(
          onPressed: () => _showImageSourceDialog(),
          child: const Text(
            'Profile Picture',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
