import 'package:flutter/material.dart';

class TypingIndicaot extends StatefulWidget {
  const TypingIndicaot({
    super.key,
    required this.bubbleColor,
    required this.showIndicator,
    required this.flashingCircleBrightColor,
    required this.flashingCircleDarkColor,
  });

  final bool showIndicator;
  final Color bubbleColor;
  final Color flashingCircleDarkColor;
  final Color flashingCircleBrightColor;

  @override
  State<TypingIndicaot> createState() => _TypingIndicaotState();
}

class _TypingIndicaotState extends State<TypingIndicaot> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
