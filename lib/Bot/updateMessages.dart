import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_tips/services/Database.dart';
import 'package:my_tips/services/auth.dart';
import 'package:my_tips/services/chatServices.dart';

class ConversationPage extends StatelessWidget {
  final String document;

  ConversationPage({
    Key? key,
    required this.document,
  }) : super(key: key);
  final AuthServices _auth = AuthServices();

  @override
  Widget build(BuildContext context) {
    String? userId = _auth.getCurrentUID();
    ChatServices _database = ChatServices();
    return Scaffold(
      appBar: AppBar(
        title: Text(document),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: _database.getDocumentById(document, 'chatMessages'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error:${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              final Map<String, dynamic>? documentData = snapshot.data?.data();
              if (documentData == null) {
                return const Center(
                  child: Text('Document Not found'),
                );
              }

              final List<dynamic>? conversation = documentData['conversation'];

              if (conversation == null || conversation.isEmpty) {
                return const Center(
                  child: Text('conversation Not found'),
                );
              }
              return ListView.builder(
                itemCount: conversation.length,
                itemBuilder: (context, index) {
                  final Map<String, dynamic> messageData = conversation[index];
                  final dynamic botData = messageData['Bot'];
                  final String? response = botData is Map<String, dynamic>
                      ? botData['response']
                      : null;
                  final String? message = messageData['message'];
                  return Column(
                    children: [
                      SelectableText('$message'),
                      SelectableText(response ?? ''),
                      Divider(),
                    ],
                  );
                },
              );
            }
            return Center();
          }),
    );
  }
}
