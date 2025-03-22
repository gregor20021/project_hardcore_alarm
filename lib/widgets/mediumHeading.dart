import 'package:flutter/material.dart';

class MediumHeading extends StatelessWidget {
  final String text;
  final IconData icon;
  const MediumHeading({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon, size: 30,),
      ),
      Text(text,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
    ],);
  }
}
