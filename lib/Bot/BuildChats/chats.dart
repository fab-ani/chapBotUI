import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:intl/intl.dart';

import '../../selectingPhoto/ImageStatus/profileOnSuggestions.dart';
import '../../selectingPhoto/imageViewer.dart';

class ChatsBubbles extends ConsumerWidget {
  final dynamic messages;

  const ChatsBubbles({Key? key, required this.messages}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final productBot = messages['botMessage'];
    final botMessage = messages['botMessage']?['botResponse'] ?? '';
    final message = messages["message"] ?? '';
    final time = messages['timeStamp'] ?? '';
    final senderId = messages["senderId"] ?? '';
    final products = productBot?['products'] as List<dynamic>? ?? [];
    bool isVisible = false;

    print('botMessageMMMMMMMMMMMMMMMMMMMM $botMessage');
    print('botMessageMMMMMMMMMMMMMMMMMMMMPPPPP $message');

    if (botMessage.isNotEmpty) {
      isVisible = true;
    }

    return senderId == 'bot'
        ? Container(
            alignment: Alignment.topLeft,
            child: message.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 100),
                        child: Card(
                          elevation: 4,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: SelectableText(
                              message,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        formatTimeStamp(time),
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      )
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: isVisible,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 100),
                              child: Card(
                                elevation: 4,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Text(
                                    botMessage,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              formatTimeStamp(time),
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8,
                          left: 8,
                          bottom: 2,
                        ),
                        child: Container(
                          color: Colors.white,
                          height: 200,
                          width: 300,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];
                              final productName = product['name'];
                              final productPrice = product['price'];
                              final productImage = product['url_image'];
                              final String productUid = product['uid'];
                              final String productdetails = product['details'];
                              final productImageW =
                                  product['url_image'] as List<dynamic>;

                              print('productName   $productName');

                              return Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: productImage[0] != null &&
                                              Uri.parse(productImage[0])
                                                  .isAbsolute
                                          ? Image.network(
                                              productImage[0],
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Image.asset(
                                                    "Assets/product deleted.jpg");
                                              },
                                            )
                                          : Image.asset(
                                              "Assets/product_deleted.jpg"),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => ExpandImages(
                                                imageUrls: productImageW,
                                                initialIndex:
                                                    index < productImageW.length
                                                        ? index
                                                        : 0,
                                                name: productName,
                                                details: productdetails,
                                                uid: productUid,
                                              ),
                                            ));
                                      },
                                      child: Column(
                                        children: [
                                          UserProfileOnReccomendations(
                                            userId: productUid,
                                          ),
                                          Text(
                                            productName,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                          Text(
                                            'Tsh${productPrice.toString()}',
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      Text(
                        formatTimeStamp(time),
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
          )
        : Container(
            alignment: Alignment.topRight,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 120),
                  child: Card(
                    elevation: 4,
                    color: const Color(0xff6962f7),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: SelectableText(
                        messages['message'],
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ),
                Text(
                  formatTimeStamp(time),
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                )
              ],
            ),
          );
  }

  String formatTimeStamp(dynamic timeStamp) {
    if (timeStamp == null) return '';

    DateTime dateTime = timeStamp.toDate();

    String formattedTime = DateFormat('hh:mm ').format(dateTime);
    return formattedTime;
  }
}
