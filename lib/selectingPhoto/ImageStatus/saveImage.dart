import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../../services/auth.dart';

class SaveImageProfile {
  AuthServices _auth = AuthServices();
  Future<String> uploadImageToStorage(String imagePath) async {
    String? userIdProfile = _auth.getCurrentUID();
    try {
      File file = File(imagePath); // Assuming you have the image file path
      String fileName = '$userIdProfile.png'; // Get the file name
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('profile_images/$userIdProfile/$fileName');

      UploadTask uploadTask = storageReference.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});

      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      print("Image uploaded to: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
    }
    return '';
  }
}
