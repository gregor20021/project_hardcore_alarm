import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatefulWidget {
  final LoadingIndicatorOptions options;
  const LoadingIndicator({super.key, required this.options});

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        height: widget.options.direction == Axis.vertical ? widget.options.size : widget.options.crossAxisSize,
        width: widget.options.direction == Axis.horizontal ? widget.options.size : widget.options.crossAxisSize,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Flex(
            direction: widget.options.direction == Axis.vertical ? Axis.horizontal : Axis.vertical,
            children: [
              for (int currentRun = 0; currentRun < widget.options.columnsOfElements; currentRun++)
                Expanded(
                  child: Flex(
                    direction: widget.options.direction,
                    children: [
                      for (int currentElement = 0; currentElement < widget.options.numberOfElements; currentElement++)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: RotatedBox(
                              quarterTurns: widget.options.direction == Axis.vertical ? 0 : 1,
                              child: LinearProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(widget.options.color),
                                backgroundColor: widget.options.color,
                                borderRadius: widget.options.borderRadius,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}

class LoadingIndicatorOptions {
  late final Color color;
  late final Axis direction;
  late final int numberOfElements;
  late final int columnsOfElements;
  late final BorderRadius borderRadius;
  late final double size;
  late final double? crossAxisSize;

  LoadingIndicatorOptions({Color? color, Axis? direction, int? numberOfElements, int? columnsOfElements, BorderRadius? borderRadius, double? size, double? crossAxisSize}) {
    this.color = color ?? Colors.grey.withOpacity(0.04);
    this.direction = direction ?? Axis.vertical;
    this.numberOfElements = numberOfElements ?? 3;
    this.columnsOfElements = columnsOfElements ?? 1;
    this.borderRadius = borderRadius ?? BorderRadius.circular(10);
    this.size = size ?? 100;
    this.crossAxisSize = crossAxisSize;
  }
}
