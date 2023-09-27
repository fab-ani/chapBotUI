import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../Bot/GetProduct.dart';
import '../Screen/Home/authenticate/detailsDialogue.dart';

class UserItemsScreen extends ConsumerStatefulWidget {
  final String userId;
  UserItemsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  ConsumerState<UserItemsScreen> createState() => _UserItemsScreenState();
}

class _UserItemsScreenState extends ConsumerState<UserItemsScreen> {
  @override
  Widget build(BuildContext context) {
    final productProvider = ref.read(productControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Products"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: productProvider.fetchUserProducts(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          return MasonryGridView.builder(
              shrinkWrap: true,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              gridDelegate:
                  const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final productData =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                final imageUrl = productData["url_image"][0]?.toString();
                final imageUrL = List<String>.from(productData["image_name"]);
                late String name = productData["name"];
                late String details = productData["details"];
                late String price = productData["price"].toString();
                late String stock = productData["Stock"].toString();

                final document = snapshot.data!.docs[index];
                final documentId = document.id;

                void updateWord(
                  String newWord,
                  int newPrice,
                  String newDetails,
                  int newStock,
                ) {
                  setState(() {
                    name = newWord;
                    price = newPrice.toString();
                    details = newWord;
                    stock = newStock.toString();
                  });
                }

                return GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) => Dialogtrigger(
                      docId: documentId,
                      onUpdateWord: updateWord,
                      name: name,
                      price: price,
                      details: details,
                      stock: stock,
                      productId: documentId,
                      imageName: imageUrL,
                      userProductId: widget.userId,
                    ),
                  ),
                  child: Card(
                    color: const Color.fromARGB(255, 104, 209, 223),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              imageUrl!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'STOCK $stock',
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                          ),
                        ]),
                  ),
                );
              });
        },
      ),
    );
  }
}
