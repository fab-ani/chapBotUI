import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../selectingPhoto/ImageStatus/profileOnSuggestions.dart';
import '../../selectingPhoto/imageViewer.dart';
import '../../services/calling.dart';

class ShowProducts extends StatefulWidget {
  const ShowProducts({
    Key? key,
    required this.details,
    required this.name,
    required this.price,
    required this.trimImageUrl,
    required this.uid,
  }) : super(key: key);

  final String uid;
  final String name;
  final int price;
  final String details;
  final List<String> trimImageUrl;

  @override
  State<ShowProducts> createState() => _ShowProductsState();
}

class _ShowProductsState extends State<ShowProducts> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserProfileOnReccomendations(
                      userId: widget.uid,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(children: [
                      Text(
                        "Tsh ${widget.price}",
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.red),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => SimpleDialog(
                              title: Text(widget.name),
                              contentPadding: const EdgeInsets.all(20.0),
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Text(
                                    widget.details,
                                    style: const TextStyle(fontSize: 16),
                                    softWrap: true,
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        child: const Text(
                          'details',
                          style: TextStyle(color: Colors.lightBlue),
                        ),
                      )
                    ]),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: 150,
                      width: double.infinity,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.trimImageUrl.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => Container()),
                                  );
                                },
                                child: Image.network(
                                  widget.trimImageUrl[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: CallButton(
                          userId: widget.uid,
                        ))
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }
}
