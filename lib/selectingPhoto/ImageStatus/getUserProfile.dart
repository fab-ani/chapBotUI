import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_tips/services/auth.dart';

AuthServices _auth = AuthServices();

class GetUserProfile {
  Stream<List<QueryDocumentSnapshot>> getAllUserProfileData() {
    return FirebaseFirestore.instance
        .collection('ProfileUserData')
        .snapshots()
        .map((event) => event.docs);
  }

  Stream<List<QueryDocumentSnapshot>> doesUserProfileExist(String userId) {
    return FirebaseFirestore.instance
        .collection('ProfileUserData')
        .doc(userId)
        .collection('profiles')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((event) => event.docs);
  }

  Future updateProfileInfo(
    String urlImage,
    String name,
    int phoneNumber,
  ) async {
    String? iduser = _auth.getCurrentUID();
    print('iduser $iduser');
    DocumentReference profileInfoRef = FirebaseFirestore.instance
        .collection('ProfileUserData')
        .doc(iduser!)
        .collection('profiles')
        .doc('info');

    await profileInfoRef.update({
      'userImage': urlImage,
      'userName': name,
      'phoneNumber': "+$phoneNumber",
    });
  }
}
