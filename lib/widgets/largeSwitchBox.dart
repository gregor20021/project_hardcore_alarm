import 'package:flutter/material.dart';

class Largeswitchbox extends StatefulWidget {
  final double? width;
  final double? height;
  final bool value;
  final String? yesText;
  final String? noText;
  final Function(bool) onChanged;
  final BorderRadius borderRadius;
  final Color? yesColor;
  final Color? noColor;
  const Largeswitchbox({super.key, this.width, this.height, required this.value, this.yesText, this.noText, required this.onChanged, this.borderRadius = const BorderRadius.all(Radius.circular(20)), this.yesColor, this.noColor});

  @override
  State<Largeswitchbox> createState() => _LargeswitchboxState();
}

class _LargeswitchboxState extends State<Largeswitchbox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height ?? 60,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 2,
        ),
        borderRadius: widget.borderRadius,
      ),
      child: LayoutBuilder(builder: (context, layout) {
        return Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 170),
              curve: Curves.easeOut,
              top: 0,
              bottom: 0,
              left: widget.value == false ? 0 : layout.maxWidth / 2,
              right: widget.value == true ? 0 : layout.maxWidth / 2,
              child: Container(
                decoration: BoxDecoration(
                  color: widget.value == true ? widget.yesColor ?? Theme.of(context).primaryColor : widget.noColor ?? Theme.of(context).primaryColor,
                  borderRadius: widget.borderRadius,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (widget.value == true) {
                        widget.onChanged(false);
                      }
                    },
                    child: Center(
                      child: Text(
                        widget.noText ?? '',
                        style: Theme.of(context).textTheme.bodyMedium
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (widget.value == false) {
                        widget.onChanged(true);
                      }
                    },
                    child: Center(
                      child: Text(
                        widget.yesText ?? '',
                        style: Theme.of(context).textTheme.bodyMedium
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
