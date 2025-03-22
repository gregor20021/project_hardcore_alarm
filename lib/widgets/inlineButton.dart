import 'package:flutter/material.dart';

class InlineButton<T> extends StatelessWidget {
  static double _disabledOpacity = 0.3;
  final Future<T> Function() onPressed;
  final IconData icon;
  final String? text;
  final double? height;
  final Color? color;
  final Color? textColor;
  final Color? iconColor;
  final bool enabled;
  const InlineButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.text,
    this.height = 60,
    this.color,
    this.textColor,
    this.iconColor,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    bool requestLoading = false;
    return StatefulBuilder(builder: (context, setState) {
      return InkWell(
        splashFactory: enabled ? InkRipple.splashFactory : NoSplash.splashFactory,
        enableFeedback: enabled,
        splashColor: enabled ? Theme.of(context).primaryColor.withOpacity(0.5) : Colors.transparent,
        onTap: () async {
          if (!enabled) return;
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
            //color: color ?? Theme.of(context).primaryColor.withOpacity(enabled ? 1 : _disabledOpacity),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Theme.of(context).primaryColor.withOpacity(enabled ? 1 : _disabledOpacity),
              width: 2,
            ),
          ),
          height: height,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!requestLoading)
                  Padding(
                    padding: EdgeInsets.only(right: text != null ? 10 : 0),
                    child: Icon(
                      icon,
                      color: iconColor?.withOpacity(enabled ? 1 : _disabledOpacity) ?? Colors.white.withOpacity(enabled ? 1 : _disabledOpacity),
                      size: 26,
                    ),
                  ),
                if (!requestLoading && text != null)
                  Text(
                    text!,
                    style: TextStyle(
                      color: textColor?.withOpacity(enabled ? 1 : _disabledOpacity) ?? Colors.white.withOpacity(enabled ? 1 : _disabledOpacity),
                    ),
                  ),
                if (requestLoading)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                    child: SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: textColor ?? Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
