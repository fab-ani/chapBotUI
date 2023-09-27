import 'package:flutter/material.dart';
import 'package:my_tips/Bot/DeletingData/AccountSetting.dart';

import '../../Business/userScreenProduct.dart';
import '../../selectingPhoto/ImageStatus/userProfile.dart';
import '../../services/auth.dart';

class HomePageDrawer extends StatefulWidget {
  const HomePageDrawer({super.key});

  @override
  State<HomePageDrawer> createState() => _HomePageDrawerState();
}

final AuthServices _auth = AuthServices();

String? senderUid = _auth.getCurrentUID();

class _HomePageDrawerState extends State<HomePageDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xffE4EBFB),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  const DrawerHeader(child: UserProfileData()),
                  ListTile(
                    title: const Text(
                      "My products",
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserItemsScreen(
                            userId: senderUid!,
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.contacts),
              title: const Text(
                "Send feedback",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () async {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text(
                "Settings",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AccountSettings(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(
                "Log out",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      children: [
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Thank you for using our app. Are you sure you want to log out?',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("cancel")),
                            TextButton(
                                onPressed: () async {
                                  await _auth.signOuts();
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  "logout",
                                  style: TextStyle(color: Colors.red),
                                )),
                          ],
                        )
                      ],
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
