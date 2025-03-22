import 'package:flutter/material.dart';

class AppDialog extends StatefulWidget {
  final Widget content;
  final Widget? title;
  const AppDialog({super.key, required this.content, this.title});

  @override
  State<AppDialog> createState() => _AppDialogState();
}

class _AppDialogState extends State<AppDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.96),
      buttonPadding: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      title: widget.title,
      content: widget.content,
    );
  }
}
