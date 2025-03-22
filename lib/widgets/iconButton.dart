import 'package:flutter/material.dart';

class IconOnlyButton<T> extends StatelessWidget {
  final Future<T> Function() onPressed;
  final IconData icon;
  final String? text;
  final double? height;
  final Color? color;
  const IconOnlyButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.text,
    this.height = 60,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    bool requestLoading = false;
    return StatefulBuilder(builder: (context, setState) {
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
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!requestLoading)
                Padding(
                  padding:  EdgeInsets.only(right: text != null ? 10 : 0),
                  child: Icon(
                    icon,
                    color: Theme.of(context).primaryColor,
                    size: 26,
                  ),
                ),
              if (!requestLoading && text != null)
                Text(
                  text!,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              if (requestLoading)
                CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
            ],
          ),
        ),
      );
    });
  }
}
