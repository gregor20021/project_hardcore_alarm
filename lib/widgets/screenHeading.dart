import 'package:flutter/material.dart';

class ScreenHeading extends StatelessWidget {
  final IconData icon;
  final String text;
  final double? iconSize;
  final double? fontSize;
  final double? spacing;
  final MainAxisAlignment? alignment;
  const ScreenHeading({super.key, required this.icon, required this.text, this.iconSize, this.fontSize, this.spacing, this.alignment});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment ?? MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(right: spacing ?? 8),
          child: Icon(
            icon,
            size: iconSize ?? 35,
            color: Theme.of(context).primaryColor,
          ),
        ),
        Flexible(
          child: Text( 
            text,
             style: TextStyle(
              fontSize: fontSize ?? 16,
            ),
          ),
        ),
      ],
    );
  }
}
