import 'package:alarm_app/controllers/InputErrorController.dart';
import 'package:alarm_app/widgets/smallHeading.dart';
import 'package:flutter/material.dart';
import 'package:alarm_app/globals.dart' as shared;



class InputDropdown extends StatelessWidget {
  final String? heading;
  final List<String> items;
  final IconData? headingIcon;
  final TextEditingController controller;
  final bool? enabled;
  final void Function()? onClicked;
  final void Function(String val)? onChanged;
  final double? iconSize;
  final Widget? rightInnerWidget;
  final InputErrorController? error;
  const InputDropdown({super.key, this.heading, this.headingIcon, required this.controller, required this.items, this.enabled = true, this.onClicked, this.iconSize, this.rightInnerWidget, this.error, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, inputSetState) {
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          onClicked == null
                              ? Expanded(
                                  child: DropdownMenuTheme(
                                    data: DropdownMenuThemeData(
                                      inputDecorationTheme: const InputDecorationTheme(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        focusedErrorBorder: InputBorder.none,
                                      ),
                                      menuStyle: MenuStyle(
                                        backgroundColor: WidgetStatePropertyAll(Theme.of(context).scaffoldBackgroundColor),
                                      ),
                                      textStyle: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    child: DropdownMenu<String>(
                                      dropdownMenuEntries: List.of(
                                        items.map(
                                          (e) => DropdownMenuEntry<String>(
                                            value: e,
                                            label: e,
                                            style: ButtonStyle(
                                              textStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.bodyMedium),
                                              foregroundColor: WidgetStatePropertyAll(Theme.of(context).textTheme.bodyMedium!.color),
                                            ),
                                          ),
                                        ),
                                      ),
                                      controller: controller,
                                      enabled: enabled ?? true,
                                      onSelected: (String? value) {
                                        if (onChanged != null) {
                                          onChanged!(value!);
                                        }
                                      },
                                      menuHeight: 600,
                                    ),
                                  ),
                                )
                              : Text(
                                  controller.text,
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                          if (rightInnerWidget != null) rightInnerWidget!,
                        ],
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
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    error!.error!,
                    style: TextStyle(
                      color: shared.errorColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
        ],
      );
    });
  }
}
