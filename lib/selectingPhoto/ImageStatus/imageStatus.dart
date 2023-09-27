import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_tips/models/user.dart';
import 'package:my_tips/services/Database.dart';

import '../../services/auth.dart';

class UserNotifier extends StateNotifier<Users> {
  UserNotifier() : super(Users(uid: null));
  AuthServices _auth = AuthServices();

  Future<UserNotifier> getProducts(String name, String price, String details,
      List<String> image, List<String> imageName, int stock) async {
    String? senderUid = _auth.getCurrentUID();
    state = Users(uid: senderUid);
    return await DatabaseServices(uid: state.uid!).updateUserData(
      name,
      price,
      details,
      image,
      imageName,
      stock,
    );
  }
}

final userProvider =
    StateNotifierProvider<UserNotifier, Users>((ref) => UserNotifier());
