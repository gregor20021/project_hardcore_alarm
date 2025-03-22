import 'package:flutter/material.dart';

class SquareButton<T> extends StatelessWidget {
  final Future<T> Function() onPressed;
  final IconData icon;
  final String text;
  final double? width;
  final double? height;
  const SquareButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.text,
    this.width = 125,
    this.height = 125,
  });

  @override
  Widget build(BuildContext context) {
    bool requestLoading = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return GestureDetector(
          onTap: () async {
            setState(() {
              requestLoading = true;
            });
            await onPressed();
            setState(() {
              requestLoading = false;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).secondaryHeaderColor,
              borderRadius: BorderRadius.circular(10),
            ),
            width: width,
            height: height,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!requestLoading)Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      icon,
                      color: Theme.of(context).primaryColor,
                      size: 40,
                    ),
                  ),
                  if (!requestLoading)Text(
                    text,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  if (requestLoading)
                    const CircularProgressIndicator(
                      color: Colors.white,
                    ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
