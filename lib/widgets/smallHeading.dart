import 'package:flutter/material.dart';

class SmallHeading extends StatelessWidget {
  final IconData? icon;
  final String text;
  final double? iconSize;
  final MainAxisAlignment? alignment;
  const SmallHeading({super.key, this.icon, required this.text, this.iconSize, this.alignment});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment ?? MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              icon,
              size: iconSize ?? 30,
              color: Theme.of(context).primaryColor,
            ),
          ),
        Text(text, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
