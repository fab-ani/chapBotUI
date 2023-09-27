import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../services/auth.dart';
import '../../services/chatServices.dart';
import 'package:http/http.dart' as http;

class GetBotResponse {
  final String convoId;
  final TextEditingController queryController;
  final AuthServices auth = AuthServices();
  List<dynamic> data;
  final String botUrl;
  final ScrollController scrollController;
  GetBotResponse({
    required this.queryController,
    required this.data,
    required this.botUrl,
    required this.scrollController,
    required this.convoId,
  });

  Future<void> getResponse() async {
    if (queryController.text.isNotEmpty) {
      String userInput = queryController.text;
      String? senderUid = auth.getCurrentUID();
      insertSingleItem(userInput);
      final ChatServices chatServices = ChatServices();

      await chatServices.createUserMessage(userInput, senderUid, convoId);

      var client = getClient();
      try {
        client.post(
          Uri.parse(botUrl),
          body: {"text": queryController.text},
        ).then((response) async {
          if (response.statusCode == 200 && response.body.isNotEmpty) {
            Map<String, dynamic> data = json.decode(response.body);

            //await Future.delayed(const Duration(seconds: 8));

            await chatServices.createBotMessage(data, convoId);

            // await Future.delayed(const Duration(seconds: 1));

            insertSingleItem(data);
          }
        });
      } finally {
        client.close();
        queryController.clear();
      }
    }
  }

  void insertSingleItem(dynamic newMessage) {
    data.add(newMessage);
    print(data);

    SchedulerBinding.instance.addPostFrameCallback((context) {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }

  http.Client getClient() {
    return http.Client();
  }
}
