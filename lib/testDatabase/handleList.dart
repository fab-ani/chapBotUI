import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  final CollectionReference messages =
      FirebaseFirestore.instance.collection('testCollection');

  Future updateMyTodos(String todos) async {
    return messages.add({'todos': todos});
  }

  Stream<QuerySnapshot> retrieveTodos() {
    return messages.snapshots();
  }

  Future<void> deleteTodo(String todo) async {
    try {
      await messages.doc(todo).delete();
    } catch (e) {
      print('Error deleting todo:$e');
    }
  }
}
