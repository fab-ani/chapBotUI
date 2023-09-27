import 'package:cloud_firestore/cloud_firestore.dart' as cloud_store;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../selectingPhoto/ImageStatus/imageStatus.dart';

class DatabaseServices {
  final String uid;
  DatabaseServices({required this.uid});

  final cloud_store.CollectionReference productCollection =
      cloud_store.FirebaseFirestore.instance.collection("chapBotItems");

  final cloud_store.CollectionReference otherUserData =
      cloud_store.FirebaseFirestore.instance.collection('ProfileUserData');

  Future<UserNotifier> updateUserData(String name, String price, String details,
      List<String> url, List<String> imageName, int stock) async {
    await productCollection.add({
      "uid": uid,
      "name": name,
      "price": price,
      "details": details,
      "url_image": url,
      "Stock": stock,
      "image_name": imageName,
      'timeStamp': FieldValue.serverTimestamp(),
    });
    final updatedUserNotifier = UserNotifier();
    return updatedUserNotifier;
  }

  Future updateProfileInfo(
    String name,
    int phoneNumber,
    String userImage,
  ) async {
    cloud_store.DocumentReference profileInfoRef =
        otherUserData.doc(uid).collection('profiles').doc('info');

    await profileInfoRef.set({
      'userName': name,
      'userImage': userImage,
      'userId': uid,
      'phoneNumber': "+255$phoneNumber",
    });
  }

  Future deleteUserAndSubcollections(String userId) async {
    var userDocRef = otherUserData.doc(userId);

    await userDocRef.delete();
    await _deleteSubcollections(userDocRef);
  }

  Future _deleteSubcollections(cloud_store.DocumentReference userDocRef) async {
    var subcollections = ['profiles', 'info'];

    for (var subcollectionName in subcollections) {
      var subcollectionRef = userDocRef.collection(subcollectionName);
      var querySnapshot = await subcollectionRef.get();

      for (var docSnapshot in querySnapshot.docs) {
        await docSnapshot.reference.delete();
      }
    }
  }

  Future<void> deleteProductsInTheDatabase(
      String productId, List<String> imagesName) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    cloud_store.FirebaseFirestore firestore =
        cloud_store.FirebaseFirestore.instance;
    print("IMAGE URLEZZZZZ $imagesName");

    for (String imageUrl in imagesName) {
      Reference imageRef = storage.ref().child('usersImages/$uid/$imageUrl');
      print("IMAGE REFERENCEEEEEE $imageRef");
      try {
        await imageRef.delete();
        print('Image deleted successfully:$imageUrl');
      } catch (e) {
        print('Error deleting image $imageUrl:$e');
      }
    }
    print("productId RDDDDDDDDD$productId");
    cloud_store.DocumentReference docRef =
        firestore.collection('chapBotItems').doc(productId);
    try {
      await docRef.delete();
      print('Product document deleted successfully');
    } catch (e) {
      print('Error deleting product document:$e');
    }
  }
}
