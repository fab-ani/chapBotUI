import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_tips/Bot/chatBot.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/chatServices.dart';

class ConversationListItem extends ConsumerStatefulWidget {
  const ConversationListItem({
    Key? key,
    required this.conversationId,
  }) : super(key: key);
  final String conversationId;

  @override
  ConsumerState<ConversationListItem> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<ConversationListItem> {
  bool isDeleteButtonVisible = false;
  late StreamProvider<QuerySnapshot> lastMessageProvoder;

  @override
  void initState() {
    super.initState();
    lastMessageProvoder = createLastMessageProvider();
  }

  StreamProvider<QuerySnapshot> createLastMessageProvider() {
    final db = ChatServices();
    return StreamProvider<QuerySnapshot>((ref) {
      return db.getLastMessage(widget.conversationId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: ChatServices().getLastMessage(widget.conversationId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error getting chats');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.none) {
          return const Text('No network connection');
        } else if (snapshot.hasData) {
          List<Map<String, dynamic>> lastMessageData = snapshot.data!.docs
              .map((e) => e.data() as Map<String, dynamic>)
              .toList();

          if (lastMessageData.isEmpty) {
            return const SizedBox.shrink();
          }
          lastMessageData.sort((a, b) {
            final aTimeStamp = a['timeStamp'] as Timestamp?;
            final bTimeStamp = b['timeStamp'] as Timestamp?;

            if (aTimeStamp == null && bTimeStamp == null) {
              return 0;
            } else if (aTimeStamp == null) {
              return 1;
            } else if (bTimeStamp == null) {
              return -1;
            }
            return bTimeStamp.compareTo(aTimeStamp);
          });
          final lastMessage = lastMessageData.first;

          final lastMessageBot = lastMessage['message'];

          String image = lastMessage['botMessage']?['products']?[0]
                  ?['url_image']?[0] ??
              '';

          String details =
              lastMessage['botMessage']?['products']?[0]?['details'] ?? '';

          return Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 10,
            ),
            child: GestureDetector(
              onLongPress: () {
                setState(() {
                  isDeleteButtonVisible = true;
                });
              },
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatBotScreen(newId: widget.conversationId),
                  ),
                );
              },
              child: Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    height: 70,
                    alignment: Alignment.topCenter,
                    color: const Color(0xff6962f7).withOpacity(0.8),
                    child: ListTile(
                      leading: image.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  image,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                        "Assets/product deleted.jpg");
                                  },
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                      title: Text(
                        lastMessageBot ?? details,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        formatTimeStamp(lastMessage['timeStamp']),
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                    visible: isDeleteButtonVisible,
                    child: Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                          onPressed: () {
                            ChatServices()
                                .deleteConvoMessages(widget.conversationId);
                          },
                          icon: const Icon(Icons.delete)),
                    ))
              ]),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

String formatTimeStamp(dynamic timeStamp) {
  if (timeStamp == null) return '';

  final now = DateTime.now();

  final difference = now.difference(timeStamp.toDate());

  if (difference.inDays >= 1) {
    return 'on ${DateFormat('EEE').format(timeStamp.toDate())}';
  } else if (difference.inHours >= 1 || difference.inMinutes >= 1) {
    return '${DateFormat('hh:mm a').format(timeStamp.toDate())} ';
  } else {
    return 'just now';
  }
}
