import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../services/auth.dart';

final userControllerProvider = Provider<UserController>(
  (ref) => UserController(),
);
AuthServices _auth = AuthServices();

class UserController extends GetxController {
  final _productList = <QueryDocumentSnapshot>[];

  List<QueryDocumentSnapshot> get productList => _productList;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Stream<List<QueryDocumentSnapshot>> fetchProducts() {
    return FirebaseFirestore.instance
        .collection("chapBotItems")
        .orderBy('timeStamp', descending: true)
        .snapshots()
        .map((event) => event.docs);
  }
}

final productControllerProvider = Provider<UsergetProduct>(
  (ref) => UsergetProduct(),
);

class UsergetProduct extends GetxController {
  final _productList = <QuerySnapshot>[];

  List<QuerySnapshot> get productList => _productList;

  String? userId = _auth.getCurrentUID();

  @override
  void onInit() {
    super.onInit();
    fetchUserProducts(userId);
  }

  Stream<QuerySnapshot> fetchUserProducts(userId) {
    String? userId = _auth.getCurrentUID();
    final snapshot = FirebaseFirestore.instance
        .collection("chapBotItems")
        .where("uid", isEqualTo: userId)
        .orderBy('timeStamp', descending: true)
        .snapshots();
    print('userId hereeeeeeeeeeeee   $userId');
    return snapshot;
  }
}
