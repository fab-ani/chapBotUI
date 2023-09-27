import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "package:my_tips/app_status/nav_status/nav_notifier.dart";

import 'package:my_tips/selectingPhoto/selectPhotos.dart';
import "../app_status/nav_status/customAppBar.dart";

import "../services/chatServices.dart";
import "chatBot.dart";
import "display_products.dart";
import "getBot&userResponse/HomeDrawer.dart";

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePage();
}

class _HomePage extends ConsumerState<HomePage> {
  static final List<Widget> _widgetOptions = <Widget>[
    const UserDisplayWidget(),
    const ProfileImage(),
  ];

  bool showSignIn = true;

  void toggleView() {
    showSignIn;
  }

  @override
  Widget build(BuildContext context) {
    var navIndex = ref.watch(navProvider);

    PreferredSizeWidget? _buildAppBar() {
      if (navIndex.index == 0) {
        return const PreferredSize(
            preferredSize: Size.fromHeight(100.0), child: CustomScrollAppBar());
      }
      return null;
    }

    return Scaffold(
      appBar: _buildAppBar(),
      body: Center(
        child: _widgetOptions.elementAt(navIndex.index),
      ),
      backgroundColor: const Color(0xffE4EBFB),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
            indicatorColor: const Color(0xffDA6726),
            indicatorShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
        child: NavigationBar(
          backgroundColor: const Color(0xff0541bd),
          height: 60,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          animationDuration: const Duration(seconds: 1),
          selectedIndex: navIndex.index,
          onDestinationSelected: (int newIndex) async {
            ref.read(navProvider.notifier).onIndexChanged(newIndex);
          },
          destinations: const [
            NavigationDestination(
              selectedIcon: Icon(
                Icons.home,
                color: Color(0xffE4EBFB),
              ),
              icon: Icon(Icons.home_outlined),
              label: "Home",
            ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.add_a_photo,
                color: Color(0xffE4EBFB),
              ),
              icon: Icon(Icons.add_a_photo_outlined),
              label: "photo",
            ),
          ],
        ),
      ),
      drawer: const HomePageDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff6962f7),
        onPressed: () async {
          String newId = await ChatServices().generateUniqueDocumentId();
          ChatServices().createConversationId(newId);
          // ignore: use_build_context_synchronously
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => ChatBotScreen(newId: newId)));
        },
        child: const Icon(
          Icons.chat_bubble_sharp,
          color: Color(0xffDA6726),
        ),
      ),
    );
  }
}
