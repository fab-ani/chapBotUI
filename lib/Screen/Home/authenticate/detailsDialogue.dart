import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:my_tips/services/Database.dart';

class Dialogtrigger extends StatefulWidget {
  final String docId;
  final String name;
  final String price;
  final String details;
  final String stock;

  final Function(String, int, String, int) onUpdateWord;
  final String productId;
  final List<String> imageName;
  final String userProductId;

  const Dialogtrigger({
    Key? key,
    required this.docId,
    required this.name,
    required this.price,
    required this.details,
    required this.stock,
    required this.onUpdateWord,
    required this.imageName,
    required this.productId,
    required this.userProductId,
  }) : super(key: key);

  @override
  State<Dialogtrigger> createState() => _DialogtriggerState();
}

class _DialogtriggerState extends State<Dialogtrigger> {
  final TextEditingController productName = TextEditingController();
  final TextEditingController productPrice = TextEditingController();
  final TextEditingController productDetails = TextEditingController();
  final TextEditingController productStock = TextEditingController();

  @override
  void initState() {
    super.initState();
    productName.text = widget.name;
    productPrice.text = widget.price.toString();
    productDetails.text = widget.details;
    productStock.text = widget.stock;
  }

  @override
  void dispose() {
    productName.dispose();
    productPrice.dispose();
    productDetails.dispose();
    productStock.dispose();
    super.dispose();
  }

  Future<void> updateDataInFireStore(
      String newWord, int newPrice, String newDetails, int newStock) async {
    try {
      final CollectionReference collection =
          FirebaseFirestore.instance.collection("chapBotItems");
      await collection.doc(widget.docId).update({
        "name": newWord,
        "price": newPrice,
        "details": newDetails,
        "Stock": newStock,
      });
    } catch (e) {
      print('Error updating word in firestore: $e');
    }
  }

  void saveChanges() async {
    final newWord = productName.text;
    final newPrice = int.parse(productPrice.text);
    final newDetails = productDetails.text;
    final newStock = int.parse(productStock.text);
    await updateDataInFireStore(newWord, newPrice, newDetails, newStock);
    widget.onUpdateWord(newWord, newPrice, newDetails, newStock);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Items'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: productName,
              decoration: const InputDecoration(
                label: Text('Name'),
              ),
            ),
            TextField(
              controller: productPrice,
              decoration: const InputDecoration(
                label: Text('Price'),
              ),
            ),
            TextField(
              controller: productStock,
              decoration: const InputDecoration(
                label: Text('Stock'),
              ),
            ),
            TextField(
              controller: productDetails,
              decoration: const InputDecoration(
                label: Text('Details'),
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            saveChanges();
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            await DatabaseServices(uid: widget.userProductId)
                .deleteProductsInTheDatabase(
                    widget.productId, widget.imageName);
            setState(() {});
            Navigator.pop(context);
          },
          child: const Text('Delete'),
        )
      ],
    );
  }
}
