import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' as cloud_store;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_tips/services/auth.dart';

final AuthServices _auth = AuthServices();
String? theId;

class ChatServices {
  final cloud_store.CollectionReference chatCollection =
      cloud_store.FirebaseFirestore.instance.collection("chatMessages");

  Future<String> generateUniqueDocumentId() async {
    try {
      DocumentReference mainCollectioni = chatCollection.doc();
      String? conversationId = mainCollectioni.id;
      print("Generated Document ID: $conversationId");
      theId = conversationId;

      print('convo id $conversationId');

      return conversationId;
    } catch (e) {
      print('Error:$e');
    }

    return '';
  }

  Future<void> createConversationId(conversationId) async {
    String? userId = _auth.getCurrentUID();
    chatCollection.doc(userId).collection('conversationIds').add({
      'conversationId': conversationId,
    });
  }

  Future<void> createUserMessage(String messageText, senderId, convoId) async {
    String? userId = _auth.getCurrentUID();

    print('creatting user Messsageeeeee $convoId');

    try {
      print('user message  on here $messageText');
      final CollectionReference documentReference =
          chatCollection.doc(userId).collection('Convomessages');

      //DocumentReference userConvoRe = documentReference.doc(chatDocId);

      await documentReference.add({
        'message': messageText,
        'senderId': userId,
        'conversationId': convoId,
        'timeStamp': FieldValue.serverTimestamp(),
      });
      print('imeenda $documentReference');
      print('addeddd');
    } catch (e) {
      print('Error creating user messages:$e');
    }
  }

  Future<void> createBotMessage(messageText, convoId) async {
    print('messageText from bot $messageText');
    print('here the oho${messageText['name']}');
    final String textmessage = messageText['response'] ?? '';

    final String uid = messageText['uid'] ?? '';

    String? userId = _auth.getCurrentUID();

    try {
      print('product id is hereeeeeeeeeeeeeeeeee $uid');
      print(
          'bot message  on HEREEEEEEEEEEEEEEEEEEEEEEEEYYYYYYYYYYYYYY $messageText');

      final CollectionReference documentReference =
          chatCollection.doc(userId).collection('Convomessages');

      if (messageText.containsKey('response')) {
        await documentReference.add({
          'message': textmessage,
          'senderId': 'bot',
          'conversationId': convoId,
          'timeStamp': FieldValue.serverTimestamp(),
        });
      } else {
        await documentReference.add({
          'botMessage': messageText,
          'senderId': 'bot',
          'conversationId': convoId,
          'timeStamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error creating user messages:$e');
    }
  }

  Stream<QuerySnapshot> getConvomessages(newId) {
    String? userId = _auth.getCurrentUID();

    return chatCollection
        .doc(userId)
        .collection('Convomessages')
        .where('conversationId', isEqualTo: newId)
        .snapshots();
  }

  Future<void> deleteConvoMessages(newId) async {
    String? userId = _auth.getCurrentUID();

    QuerySnapshot messagesSnapshot = await chatCollection
        .doc(userId)
        .collection('Convomessages')
        .where('conversationId', isEqualTo: newId)
        .get();
    for (QueryDocumentSnapshot messageDoc in messagesSnapshot.docs) {
      await messageDoc.reference.delete();
    }
  }

  Stream<QuerySnapshot> getLastMessage(newId) {
    String? userId = _auth.getCurrentUID();

    return chatCollection
        .doc(userId)
        .collection('Convomessages')
        .where('conversationId', isEqualTo: newId)
        .orderBy('timeStamp', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getConversationId() {
    String? userId = _auth.getCurrentUID();

    return chatCollection.doc(userId).collection('conversationIds').snapshots();
  }

  Future deleteUserMessages(String userId) async {
    await _deleteSubcollection(
        chatCollection.doc(userId).collection('Convomessages'));
    await _deleteSubcollection(
        chatCollection.doc(userId).collection('conversationIds'));

    await chatCollection.doc(userId).delete();
  }

  Future _deleteSubcollection(CollectionReference subcollections) async {
    var querySnapshot = await subcollections.get();
    for (var docSnapshot in querySnapshot.docs) {
      await docSnapshot.reference.delete();
    }
  }
}
