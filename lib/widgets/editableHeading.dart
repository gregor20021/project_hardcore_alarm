import 'package:flutter/material.dart';

class EditableHeading extends StatefulWidget {
  final TextEditingController controller;
  final IconData? icon;

  const EditableHeading({super.key, required this.controller, this.icon});

  @override
  State<EditableHeading> createState() => _EditableHeadingState();
}

class _EditableHeadingState extends State<EditableHeading> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget.icon != null ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Icon(widget.icon),
        ) : Container(),
        isEditing
            ? Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: widget.controller,
                      onFieldSubmitted: (value) {
                        setState(() {
                          isEditing = false;
                        });
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isEditing = false;
                      });
                    },
                    child: const Icon(Icons.check),
                  ),
                ],
              ),
            )
            : InkWell(
              onTap: () {
                setState(() {
                  isEditing = true;
                });
              },
              child: Row(
                children: [
                  Text(
                    widget.controller.text,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isEditing = true;
                      });
                    },
                    child: const Icon(Icons.edit),
                  ),
                ],
              ),
            ),
      ],
    );
  }
}
