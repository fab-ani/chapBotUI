import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:my_tips/services/chatServices.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'getBot&userResponse/listtileMessages.dart';

class NotificationPage extends ConsumerWidget {
  NotificationPage({
    Key? key,
  }) : super(key: key);

  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  late final todosStreamProvider =
      StreamProvider.autoDispose<QuerySnapshot>((ref) {
    final db = ChatServices();
    return db.getConversationId();
  });

  @override
  Widget build(BuildContext context, ref) {
    final AsyncValue<QuerySnapshot> snapshot = ref.watch(todosStreamProvider);
    return Container(
        child: snapshot.when(
      data: (data) {
        List<Map<String, dynamic>> conversationIds =
            data.docs.map((e) => e.data() as Map<String, dynamic>).toList();

        return Container(
            alignment: Alignment.topCenter,
            child: Column(children: [
              const Padding(
                padding: EdgeInsets.only(),
                child: SizedBox(
                  child: DrawerHeader(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: Text(
                          'Recent Activity',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  key: _listKey,
                  addAutomaticKeepAlives: false,
                  itemCount: conversationIds.length,
                  itemBuilder: (context, index) {
                    final message = conversationIds[index];
                    final conversationId = message['conversationId'];

                    return ConversationListItem(
                      conversationId: conversationId,
                    );
                  },
                ),
              )
            ]));
      },
      loading: () => const Center(
        child: SizedBox.shrink(),
      ),
      error: (error, stackTrace) => Center(
        child: Text('Error:$error'),
      ),
    ));
  }
}
