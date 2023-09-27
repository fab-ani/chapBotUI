import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final Reference storage = FirebaseStorage.instance.ref();

class DeleteUserData {
  Future deleteImages(
    String user,
  ) async {
    print('current user account $user');
    final folderPath = 'usersImages/$user/';
    try {
      final ListResult listResult = await storage.child(folderPath).listAll();
      for (final item in listResult.items) {
        await item.delete();
      }

      print('images delete successfully');
    } catch (e) {
      print('error deleting images$e,$storage      $folderPath');
    }
  }

  Future deleteAllTheUrls(String userId) async {
    print('delete images urls');
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("chapBotItems")
        .where("uid", isEqualTo: userId)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } else {
      return;
    }
  }

  Future deleteProfileImages(String user) async {
    print('deleting profile images');
    final folderPath = 'profile_images/$user/';
    try {
      final ListResult listResult = await storage.child(folderPath).listAll();
      if (listResult.items.isNotEmpty) {
        for (final item in listResult.items) {
          await item.delete();
        }
      } else {
        return;
      }

      print('images delete successfully');
    } catch (e) {
      print('error deleting images$e,$storage      $folderPath');
    }
  }
}
