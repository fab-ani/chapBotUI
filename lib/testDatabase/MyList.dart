import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Bot/recommend.dart';
import 'handleList.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final todosStreamProvider = StreamProvider.autoDispose<QuerySnapshot>((ref) {
  final db = DatabaseServices();
  return db.retrieveTodos();
});

class TodoList extends ConsumerWidget {
  TodoList({Key? key}) : super(key: key);

  final TextEditingController inputText = TextEditingController();
  late String todos = '';
  final List<String> todosBuild = [];

  @override
  Widget build(BuildContext context, ref) {
    final AsyncValue<QuerySnapshot> snapshot = ref.watch(todosStreamProvider);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('MyTodos'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
            },
          ),
        ),
        body: snapshot.when(
          data: (data) {
            List<String> todoLists =
                data.docs.map((e) => e.id.toString()).toList();
            print('tht to dolist $todoLists');
            return Container(
              alignment: Alignment.topCenter,
              child: Column(children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: todoLists.length,
                    itemBuilder: (context, index) {
                      final document = data.docs[index];
                      final documentId = document.id;

                      return Dismissible(
                        key: Key(documentId),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(right: 20.0),
                          child: const Icon(
                            Icons.dangerous,
                            color: Colors.black,
                          ),
                        ),
                        onDismissed: (direction) {
                          DatabaseServices().deleteTodo(documentId);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              height: 100,
                              alignment: Alignment.topCenter,
                              color: Colors.blue.withOpacity(0.5),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    todoLists[index],
                                    style: const TextStyle(fontSize: 18),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: TextField(
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        controller: inputText,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        todos = inputText.text;
                        if (todos.isNotEmpty) {
                          todosBuild.add(todos);

                          DatabaseServices().updateMyTodos(todos);
                          inputText.clear();
                        }
                      },
                      backgroundColor: Colors.blueGrey,
                      child: const Icon(Icons.add),
                    )
                  ]),
                ),
              ]),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => Center(
            child: Text('Error:$error'),
          ),
        ),
      ),
    );
  }
}
