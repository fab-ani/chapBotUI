import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_tips/selectingPhoto/ImageStatus/getUserProfile.dart';

class UserProfileOnReccomendations extends StatelessWidget {
  const UserProfileOnReccomendations({Key? key, required this.userId})
      : super(key: key);
  final String userId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: GetUserProfile().doesUserProfileExist(userId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error loading data');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox.shrink(),
          );
        } else if (snapshot.connectionState == ConnectionState.none) {
          return const Text('Please check your network connection');
        } else if (snapshot.hasData) {
          final userProfile = snapshot.data!;

          for (DocumentSnapshot userProfileSnapshot in userProfile) {
            final data = userProfileSnapshot.data() as Map<String, dynamic>;
            if (data.isNotEmpty) {
              final userProfileImage = data['userImage']?.toString() ?? '';

              final userName = data['userName'].toString();

              return ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
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
                    child: userProfileImage.isNotEmpty
                        ? Image(
                            image: NetworkImage(userProfileImage),
                            fit: BoxFit.cover,
                          )
                        : const CircleAvatar(
                            backgroundColor: Color(0xff6962f7),
                            child: Icon(
                              Icons.person,
                              size: 20,
                            ),
                          ),
                  ),
                ),
                title: Text(userName),
              );
            }
          }
        }
        return const SizedBox.shrink();
      },
    );
  }
}
