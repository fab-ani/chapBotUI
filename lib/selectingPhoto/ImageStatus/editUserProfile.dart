import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_tips/selectingPhoto/ImageStatus/getUserProfile.dart';
import 'package:my_tips/selectingPhoto/ImageStatus/updateImage.dart';
import 'package:my_tips/services/auth.dart';

import '../../shared/constnts.dart';

class EditUserProfile extends StatefulWidget {
  const EditUserProfile({super.key});

  @override
  State<EditUserProfile> createState() => _EditUserProfileState();
}

TextEditingController nameController = TextEditingController();
TextEditingController businessNameController = TextEditingController();
TextEditingController typeOfProductController = TextEditingController();
TextEditingController phoneNumberController = TextEditingController();

final _formKey = GlobalKey<FormState>();

TextEditingController locationController = TextEditingController();

final AuthServices _auth = AuthServices();

class _EditUserProfileState extends State<EditUserProfile> {
  @override
  void dispose() {
    nameController;
    businessNameController;
    typeOfProductController;
    phoneNumberController;
    locationController;
    super.dispose();
  }

  String selectedImage = '';

  @override
  Widget build(BuildContext context) {
    String? userId = _auth.getCurrentUID();
    return StreamBuilder(
      stream: GetUserProfile().doesUserProfileExist(userId!),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error loading Profile ${snapshot.hasError}");
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          final userProfile = snapshot.data!;
          for (DocumentSnapshot userSnapshot in userProfile) {
            final data = userSnapshot.data() as Map<String, dynamic>;
            if (data.isNotEmpty) {
              final image = data['userImage'].toString();
              nameController.text = data['userName'].toString();
              phoneNumberController.text = data['phoneNumber'].toString();
              print('NUMBERRRR  ${phoneNumberController.text}');

              return Scaffold(
                appBar: AppBar(
                  backgroundColor: const Color(0xFF112D60),
                  title: const Text('Edit Profile'),
                ),
                body: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 50),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 4, color: Colors.white),
                                  boxShadow: [
                                    BoxShadow(
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(0.1),
                                    )
                                  ],
                                  shape: BoxShape.circle,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(80),
                                  child: image.isNotEmpty
                                      ? Image(
                                          image: NetworkImage(image),
                                          fit: BoxFit.cover,
                                        )
                                      : const CircleAvatar(
                                          backgroundColor: Color(0xffff5722),
                                          child: Icon(
                                            Icons.person,
                                            size: 40,
                                          ),
                                        ),
                                ),
                              ),
                              Positioned(
                                top: 60,
                                left: 62,
                                child: EditProfileImage(
                                  name: nameController.text,
                                  phoneNumber: phoneNumberController.text,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const SizedBox(
                            width: 60,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            decoration: textDec.copyWith(hintText: "Name :"),
                            controller: nameController,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            decoration:
                                textDec.copyWith(hintText: "phoneNumber :"),
                            controller: phoneNumberController,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          MaterialButton(
                            onPressed: () async {
                              print("AAAAAAAAAAAAA");
                              print('hi');
                              var uid = _auth.getCurrentUID;
                              print('ID ${uid.toString()}');

                              await GetUserProfile().updateProfileInfo(
                                image,
                                nameController.text,
                                int.parse(phoneNumberController.text),
                              );
                            },
                            child: const Text('Update'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          }
        }
        return const SizedBox.shrink();
      },
    );
  }
}
