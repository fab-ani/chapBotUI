import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../selectingPhoto/ImageStatus/getUserProfile.dart';

class CallButton extends StatefulWidget {
  const CallButton({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  State<CallButton> createState() => _CallButtonState();
}

class _CallButtonState extends State<CallButton> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: GetUserProfile().doesUserProfileExist(widget.userId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error happen ${snapshot.error.toString()}');
        } else if (snapshot.hasData) {
          final getUserPhoneNumber = snapshot.data!;
          for (DocumentSnapshot userPhoneSnapshot in getUserPhoneNumber) {
            final data = userPhoneSnapshot.data() as Map<String, dynamic>;
            if (data.isNotEmpty) {
              String number = data['phoneNumber'];

              print("NUMVBERRRRRRRRRRRRRRRRRRRRRR $number");

              return TextButton(
                  onPressed: () async {
                    String url_number = '$number';
                    Uri url = Uri(scheme: 'tel', path: url_number);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      throw 'Could not lauch $url';
                    }

                    print(number);
                  },
                  child: Text(
                    number,
                    style: const TextStyle(color: Colors.black, fontSize: 18),
                  ));
            }
          }
        }
        return const SizedBox.shrink();
      },
    );
  }
}
