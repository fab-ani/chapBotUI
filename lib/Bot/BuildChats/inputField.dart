import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InputField extends ConsumerWidget {
  const InputField({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: const Color(0xff554994).withOpacity(0.5),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 20, bottom: 10, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: TextField(
                  focusNode: FocusNode(),
                  textAlignVertical: TextAlignVertical.top,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: const BorderSide(),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: const BorderSide(
                        color: Colors.purple,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xff554994)),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    hintText: "Hellow chapBot....",
                    filled: true,
                    hintStyle: const TextStyle(fontFamily: "italic"),
                    fillColor: Colors.white,
                  ),
                  controller: queryController,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (msg) {
                    getResponse();
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              FloatingActionButton.small(
                onPressed: () {
                  getResponse();
                },
                backgroundColor: const Color(0xffff5722),
                child: const Icon(
                  Icons.send,
                  color: Color(0xff554994),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
