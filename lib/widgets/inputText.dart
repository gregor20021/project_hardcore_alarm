import 'package:alarm_app/controllers/InputErrorController.dart';
import 'package:alarm_app/widgets/smallHeading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alarm_app/globals.dart' as shared;



class InputField extends StatelessWidget {
  final String? heading;
  final IconData? headingIcon;
  final String? hintText;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final bool? enabled;
  final void Function(String val)? onChanged;
  final void Function()? unFocus;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function()? onClicked;
  final void Function()? onFocus;
  final double? iconSize;
  final bool? obscureText;
  final Widget? rightInnerWidget;
  final int? minLines;
  final int? maxLines;
  final InputErrorController? error;
  const InputField({super.key, this.heading, this.headingIcon, this.hintText, required this.controller, this.inputFormatters, this.keyboardType, this.enabled = true, this.onChanged, this.unFocus, this.textInputAction, this.focusNode, this.onClicked, this.iconSize, this.obscureText, this.rightInnerWidget, this.minLines, this.maxLines, this.onFocus, this.error});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, inputSetState) {
        if (error != null) {
          error!.addListener(() {
            if (context.mounted) {
              inputSetState(() {});
            }
          });
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (heading != null)
              Row(
                children: [
                  SmallHeading(icon: headingIcon, text: heading!, iconSize: iconSize),
                ],
              ),
            GestureDetector(
              onTap: () {
                if (onClicked != null) {
                  onClicked!();
                }
              },
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: error?.error != null && error!.error!.isNotEmpty ? shared.errorColor : Theme.of(context).primaryColor,
                          width: 1.3,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                          child: Row(
                            children: [
                              onClicked == null
                                  ? Expanded(
                                      child: TextFormField(
                                        onTap: () {
                                          if (onFocus != null) {
                                            onFocus!();
                                          }
                                        },
                                        controller: controller,
                                        style: Theme.of(context).textTheme.bodyMedium,
                                        decoration: InputDecoration(
                                          hintText: hintText,
                                          hintStyle: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                        inputFormatters: inputFormatters,
                                        keyboardType: keyboardType,
                                        enabled: enabled ?? true && onClicked == null,
                                        onChanged: onChanged,
                                        onTapOutside: (val) {
                                          if (unFocus != null) {
                                            unFocus!();
                                          }
                                        },
                                        onEditingComplete: () {
                                          if (unFocus != null) {
                                            unFocus!();
                                          }
                                        },
                                        onFieldSubmitted: (val) {
                                          if (unFocus != null) {
                                            unFocus!();
                                          }
                                        },
                                        textInputAction: textInputAction,
                                        focusNode: focusNode,
                                        obscureText: obscureText ?? false,
                                        minLines: minLines ?? 1,
                                        maxLines: maxLines ?? 1,
                                      ),
                                    )
                                  : Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 15),
                                    child: Text(
                                        controller.text,
                                      ),
                                  ),
                              if (rightInnerWidget != null) rightInnerWidget!,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (error?.error != null && error!.error!.isNotEmpty)
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        error!.error!,
                        style: TextStyle(
                          color: shared.errorColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        );
      }
    );
  }
}
