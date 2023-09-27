import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import 'package:my_tips/selectingPhoto/ImageStatus/imageStatus.dart';
import 'package:my_tips/selectingPhoto/selectingMultiple.dart' as mp;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_tips/services/auth.dart';

import 'ImageStatus/uploadStatus.dart';

final imageHelper1 = mp.ImageHelper();

class ProfileImage extends ConsumerStatefulWidget {
  const ProfileImage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ProfileImage> createState() => _ProfileImageState();
}

AuthServices _auth = AuthServices();

class _ProfileImageState extends ConsumerState<ProfileImage> {
  List<File>? _image = [];
  bool _uploading = false;
  String _uploadStatus = "";
  String sending = '';

  final TextEditingController productName = TextEditingController();
  final TextEditingController productPrice = TextEditingController();
  final TextEditingController productDescription = TextEditingController();
  final TextEditingController productStock = TextEditingController();
  bool isUploading = false;
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
  }

  @override
  void dispose() {
    productName.dispose();
    productPrice.dispose();
    productDescription.dispose();
    productStock.dispose();
    _isMounted = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: const Text("Add Photos"),
        actions: [
          ElevatedButton.icon(
            onPressed: _uploadImage,
            icon: const Icon(Icons.upload),
            label: const Text('Upload'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: _image!.length + 1,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemBuilder: (context, index) {
                if (index >= 0 && index < _image!.length) {
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(_image![index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: () async {
                      final pickedImages =
                          await imageHelper1.pickImage(multiple: true);
                      if (!_isMounted) {
                        return;
                      }

                      if (pickedImages.isNotEmpty) {
                        final xfiles =
                            pickedImages.map((e) => XFile(e.path)).toList();
                        for (int i = 0; i < xfiles.length; i++) {
                          final croppedFile =
                              await imageHelper1.crop(file: xfiles[i]);
                          if (croppedFile != null) {
                            setState(() {
                              if (_image!.length < 5) {
                                _image!.add(File(croppedFile.path));
                              }
                            });
                          }
                        }
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.all(4.0),
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.add),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          UploadStatusWidget(
            isUploading: isUploading,
            uploadStatus: _uploadStatus,
          )
        ],
      ),
    );
  }

  Future<List<String>> uploadFiles(List<File> files) async {
    String? userIdtoStrorePictures = _auth.getCurrentUID();

    List<String> downloadUrls = [];
    final storageRef = FirebaseStorage.instance.ref();

    final uploadTasks = files.map((file) {
      final fileName =
          '${DateTime.now().microsecondsSinceEpoch.toString()}.png';
      final fileRef =
          storageRef.child('usersImages/$userIdtoStrorePictures/$fileName');
      return fileRef.putFile(file);
    }).toList();
    final snapShots = await Future.wait(uploadTasks);
    for (final snapshot in snapShots) {
      final downloadUrl = await snapshot.ref.getDownloadURL();
      downloadUrls.add(downloadUrl);
    }
    return downloadUrls;
  }

  Future<void> _uploadImage() async {
    String? userIdtoStrorePictures = _auth.getCurrentUID();
    if (_image == null) return;
    final userState = ref.read(userProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return SingleChildScrollView(
              child: AlertDialog(
                title: const Text("Add product Details"),
                content: Column(
                  children: [
                    TextFormField(
                      controller: productName,
                      decoration:
                          const InputDecoration(labelText: "Product Name"),
                    ),
                    TextFormField(
                      controller: productPrice,
                      decoration:
                          const InputDecoration(labelText: "Product Price"),
                    ),
                    TextFormField(
                      controller: productDescription,
                      decoration: const InputDecoration(
                          labelText: "Product Description"),
                      maxLines: 4,
                      minLines: 1,
                    ),
                    TextFormField(
                      controller: productStock,
                      decoration:
                          const InputDecoration(labelText: "Product Stock"),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        isUploading = true;
                        print('isUploading   $isUploading');
                        _uploadStatus = 'Uploading...';
                        print('_uploadStatus   $_uploadStatus');
                      });
                      Navigator.of(context).pop();

                      final name = productName.text;
                      final price = productPrice.text;
                      final details = productDescription.text;
                      final stock = int.parse(productStock.text);
                      final List<String> imageNames = [];
                      final List<String> imageUrls = [];

                      String? fileURL;
                      List<String>? downloadURL;
                      if (_image!.length == 1) {
                        final imageName =
                            '${DateTime.now().millisecondsSinceEpoch}.png';
                        if (imageName.isNotEmpty) {
                          imageNames.add(imageName);
                        }

                        final firebaseStorageRef = FirebaseStorage.instance
                            .ref()
                            .child(
                                'usersImages/$userIdtoStrorePictures/$imageName');

                        final uploadTask =
                            firebaseStorageRef.putFile(_image![0]);
                        try {
                          final taskSnapShot = await uploadTask;
                          fileURL = await taskSnapShot.ref.getDownloadURL();
                        } catch (e) {
                          setState(() {
                            _uploadStatus = "Upload failed";
                          });
                        }
                      }
                      if (_image!.length > 1) {
                        try {
                          downloadURL = await uploadFiles(_image!);
                          debugPrint('Images uploaded successfully');
                          setState(() {
                            _uploadStatus = 'Upload successful';
                          });
                          Future.delayed(const Duration(seconds: 2), () {
                            setState(() {
                              isUploading = false;
                            });
                          });
                        } catch (e) {
                          setState(() {
                            _uploadStatus = 'Upload failed';
                          });
                        }
                      }
                      if (fileURL != null) {
                        imageUrls.add(fileURL);
                        debugPrint('my images urls here $imageUrls');
                      }
                      if (downloadURL != null) {
                        imageUrls.addAll(downloadURL);
                        debugPrint('my images urls here $imageUrls');
                      }
                      try {
                        userState.getProducts(
                            name, price, details, imageUrls, imageNames, stock);
                        setState(() {
                          _uploadStatus = 'successfully!';
                        });
                        Future.delayed(const Duration(seconds: 2), () {
                          setState(() {
                            isUploading = false;
                          });
                        });
                      } catch (e) {
                        setState(() {
                          isUploading = false;
                          _uploadStatus = 'failed to update data: $e';
                        });
                      }
                    },
                    child: const Text('Upload'),
                  ),
                ],
              ),
            );
          });
    });

    setState(() {
      _uploading = false;
    });
  }
}
