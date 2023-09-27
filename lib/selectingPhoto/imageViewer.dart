import 'dart:ui';

import 'package:flutter/material.dart';
import '../../services/calling.dart';

class ExpandImages extends StatefulWidget {
  final List<dynamic> imageUrls;
  final int initialIndex;
  final String details;
  final String name;
  final String uid;
  const ExpandImages({
    Key? key,
    required this.imageUrls,
    required this.initialIndex,
    required this.details,
    required this.name,
    required this.uid,
  }) : super(key: key);

  @override
  State<ExpandImages> createState() => _ExpandImagesState();
}

class _ExpandImagesState extends State<ExpandImages> {
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();

    currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              widget.imageUrls[currentIndex],
              errorBuilder: (context, error, stackTrace) {
                return Image.asset("Assets/product deleted.jpg");
              },
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: FractionallySizedBox(
              widthFactor: 0.9,
              heightFactor: 0.6,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    widget.imageUrls[currentIndex],
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset("Assets/product deleted.jpg");
                    },
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 410),
            child: Align(
              alignment: Alignment.center,
              child: FractionallySizedBox(
                widthFactor: 0.9,
                heightFactor: 0.5,
                child: Card(
                  color: Colors.white.withOpacity(0.5),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            child: Text(
                              widget.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.details,
                            style: const TextStyle(
                              fontSize: 16,
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
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.imageUrls.length,
                  (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: currentIndex == index
                                  ? Colors.white
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              widget.imageUrls[index],
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                    "Assets/product deleted.jpg");
                              },
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
