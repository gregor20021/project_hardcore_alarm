import 'package:flutter/material.dart';

class SmallTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  const SmallTitle({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:  Icon(icon),
        ),
        Text(title),
      ],
    );
  }
}
