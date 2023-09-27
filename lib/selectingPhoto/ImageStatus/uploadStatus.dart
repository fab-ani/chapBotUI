import 'package:flutter/material.dart';

class UploadStatusWidget extends StatefulWidget {
  const UploadStatusWidget({
    Key? key,
    required this.isUploading,
    required this.uploadStatus,
  }) : super(key: key);
  final bool isUploading;
  final String uploadStatus;

  @override
  State<UploadStatusWidget> createState() => _UploadStatusWidgetState();
}

class _UploadStatusWidgetState extends State<UploadStatusWidget> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isUploading,
      child: Center(
        child: SimpleDialog(
          backgroundColor: const Color(0xffDA6726),
          children: [
            const Center(child: CircularProgressIndicator()),
            Center(child: Text(widget.uploadStatus)),
          ],
        ),
      ),
    );
  }
}
