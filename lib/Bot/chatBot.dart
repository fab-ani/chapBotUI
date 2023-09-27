import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:my_tips/Bot/BuildChats/chats.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_tips/Bot/BuildChats/getBotResponse.dart';
import 'package:my_tips/Bot/notificationpage.dart';
import 'package:my_tips/Bot/recommend.dart';
import 'package:my_tips/services/chatServices.dart';

class ChatBotScreen extends ConsumerStatefulWidget {
  const ChatBotScreen({
    Key? key,
    required this.newId,
  }) : super(key: key);
  final String newId;
  @override
  ConsumerState<ChatBotScreen> createState() => _ChatBotScreen();
}

class _ChatBotScreen extends ConsumerState<ChatBotScreen> {
  final List<dynamic> _data = [];
  final List<dynamic> conversation = [];
  //static const String BOT_URL = 'https://chapbot.onrender.com/api/predict';
  static const String BOT_URL = 'http://172.20.10.2:5000/api/predict';
  final TextEditingController queryController = TextEditingController();
  final Map<String, bool> loadingMap = {};
  final Map<int, bool> isTapMap = {};

  late final convoIdProvider = StreamProvider<QuerySnapshot>((ref) {
    return ChatServices().getConvomessages(widget.newId);
  });

  //late ScrollController _scrollController;

  final ScrollController _scrollController = ScrollController();
  @override
  void dispose() {
    _scrollController.dispose();
    queryController.dispose();
    super.dispose();
  }

  _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    final AsyncValue<QuerySnapshot> snapshot = ref.watch(convoIdProvider);
    print('snapshot $snapshot');
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(
            0xff0541bd,
          ),
          title: const Text(
            "ChapBot",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            Builder(builder: (context) {
              return IconButton(
                  icon: const Icon(
                    Icons.history,
                    color: Color(0xffDA6726),
                  ),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  });
            })
          ],
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xffDA6726),
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const HomePage()));
            },
          ),
        ),
        body: Stack(children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xffE4EBFB),
                  Color(0xffE4EBFB),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomRight,
              ),
            ),
            child: snapshot.when(
              data: (data) {
                List<Map<String, dynamic>> messages = data.docs.map((e) {
                  Map<String, dynamic> messageData =
                      e.data() as Map<String, dynamic>;

                  return messageData;
                }).toList();
                messages = messages
                    .where((message) => message['timeStamp'] != null)
                    .toList();
                messages.sort((a, b) => (b['timeStamp'] as Timestamp)
                    .compareTo(a['timeStamp'] as Timestamp));
                return Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                          reverse: false,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: messages.length,
                          itemBuilder: (BuildContext context, int index) {
                            final message =
                                messages[messages.length - 1 - index];
                            print(
                                "messagesssssssssssssssssssssssssssss $message");

                            return ChatsBubbles(
                              messages: message,
                            );
                          },
                          controller: _scrollController),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, bottom: 10, top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 10,
                                  minLines: 1,
                                  textAlignVertical: TextAlignVertical.top,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 10,
                                    ),
                                    alignLabelWithHint: true,
                                    border: InputBorder.none,
                                    hintText: "Hellow ChapBot....",
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  controller: queryController,
                                  textInputAction: TextInputAction.send,
                                  onSubmitted: (msg) {
                                    GetBotResponse(
                                            botUrl: BOT_URL,
                                            queryController: queryController,
                                            scrollController: _scrollController,
                                            data: _data,
                                            convoId: widget.newId)
                                        .getResponse();
                                    print('onSubmitted${widget.newId}');
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                onPressed: () {
                                  GetBotResponse(
                                          queryController: queryController,
                                          data: _data,
                                          botUrl: BOT_URL,
                                          scrollController: _scrollController,
                                          convoId: widget.newId)
                                      .getResponse();
                                  print('onPressed${widget.newId}');
                                },
                                icon: const Icon(
                                  Icons.send,
                                  color: Color(0xffDA6726),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Text('Error$error'),
            ),
          ),
        ]),
        endDrawer: Drawer(
          backgroundColor: Colors.white.withOpacity(0.5),
          child: NotificationPage(),
        ),
      ),
    );
  }
}
