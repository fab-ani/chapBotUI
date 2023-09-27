import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_tips/selectingPhoto/ImageStatus/editUserProfile.dart';
import 'package:my_tips/selectingPhoto/ImageStatus/getUserProfile.dart';
import 'package:my_tips/services/auth.dart';

class UserProfileData extends StatefulWidget {
  const UserProfileData({super.key});

  @override
  State<UserProfileData> createState() => _UserProfileDataState();
}

AuthServices _auth = AuthServices();

class _UserProfileDataState extends State<UserProfileData> {
  @override
  Widget build(BuildContext context) {
    String? userId = _auth.getCurrentUID();
    return StreamBuilder<List<DocumentSnapshot>>(
      stream: GetUserProfile().doesUserProfileExist(userId!),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error loading Profile ${snapshot.hasError}");
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        } else if (snapshot.hasData) {
          final userProfile = snapshot.data!;
          for (DocumentSnapshot userProfileSnapshot in userProfile) {
            final data = userProfileSnapshot.data() as Map<String, dynamic>;
            if (data.isNotEmpty) {
              final image = data['userImage']?.toString() ?? '';
              final name = data['userName'].toString();

              return Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const EditUserProfile()));
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(width: 4, color: Colors.white),
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
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Center(
                            child: Text(
                          name,
                          style: const TextStyle(fontSize: 18),
                        )),
                      )
                    ],
                  ),
                ),
              );
            }
          }
        }
        return Align(
          alignment: Alignment.topLeft,
          child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const EditUserProfile()));
            },
            child: Row(
              children: [
                Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(width: 4, color: Colors.white),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 2,
                          blurRadius: 10,
                          color: Colors.black.withOpacity(0.1),
                        )
                      ],
                      shape: BoxShape.circle,
                    ),
                    child: const CircleAvatar(
                      child: Icon(
                        Icons.person,
                        size: 40,
                      ),
                    )),
                const SizedBox(
                  width: 20,
                ),
                const Center(
                    child: Text(
                  'No name is set',
                  style: TextStyle(fontSize: 18),
                ))
              ],
            ),
          ),
        );
      },
    );
  }
}
