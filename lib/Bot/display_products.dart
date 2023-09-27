import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_tips/Bot/GetProduct.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:my_tips/Bot/chatBot.dart';
import 'package:my_tips/services/auth.dart';

import '../selectingPhoto/ImageStatus/profileOnSuggestions.dart';
import '../services/chatServices.dart';

class UserDisplayWidget extends ConsumerStatefulWidget {
  const UserDisplayWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<UserDisplayWidget> createState() => _UserDisplayWidgetState();
}

AuthServices _auth = AuthServices();

class _UserDisplayWidgetState extends ConsumerState<UserDisplayWidget> {
  bool isDataFatched = false;
  String? userId = _auth.getCurrentUID();

  @override
  Widget build(BuildContext context) {
    final UserController userController = ref.watch(userControllerProvider);

    return StreamBuilder<List<QueryDocumentSnapshot>>(
      stream: userController.fetchProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.hasData) {
          final productList = snapshot.data;

          return MasonryGridView.builder(
            shrinkWrap: true,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) {
              Map<String, dynamic> productListing = {};
              final productData =
                  productList[index].data() as Map<String, dynamic>;

              final imageUrl = productData["url_image"][0]?.toString();
              final name = productData["name"]?.toString();
              final price = productData["price"];
              final userIdProduct = productData["uid"]?.toString();
              int stock = productData['Stock'] ?? '';
              String details = productData['details'] ?? '';
              String uid = productData['uid'] ?? '';
              final image = productData["url_image"];
              Map<String, dynamic> product = {
                'Stock': stock,
                'details': details,
                'name': name,
                'price': price,
                'uid': uid,
                'url_image': image,
              };
              productListing.addAll({
                'products': [product]
              });
              return Card(
                color: const Color(0xffFFFFFF),
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserProfileOnReccomendations(
                      userId: userIdProduct!,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: FadeInImage(
                        placeholder: const AssetImage('Assets/chapbot.png'),
                        image: NetworkImage(imageUrl!),
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey,
                            width: double.infinity,
                            height: double.infinity,
                            child: const Center(
                              child: Text('Error to load image'),
                            ),
                          );
                        },
                      ),
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 2,
                                right: 2,
                              ),
                              child: Text(
                                name ?? "",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 2, left: 2, right: 2),
                              child: Text(
                                'Tsh ${price.toString()}',
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    print('productData   $productData');
                                    String newId = await ChatServices()
                                        .generateUniqueDocumentId();
                                    ChatServices().createConversationId(newId);
                                    ChatServices().createBotMessage(
                                        productListing, newId);
                                    print('newId  $newId');
                                    // ignore: use_build_context_synchronously
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                ChatBotScreen(newId: newId)));
                                  },
                                  icon: const Icon(
                                    Icons.arrow_right_alt,
                                    color: Color(0xffDA6726),
                                  ),
                                )
                              ])
                        ]),
                  ],
                ),
              );
            },
            itemCount: productList!.length,
          );
        }
        return const Text("No data Found");
      },
    );
  }
}
