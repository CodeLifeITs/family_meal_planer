import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'common_functions.dart';

Widget textFieldItem(BuildContext context, TextEditingController controller,
    String title, List<PopupMenuItem> foodItems, Function callBack) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.bold, color: primaryColor),
      ),
      const SizedBox(
        height: 3,
      ),
      SizedBox(
        height: 60,
        child: Center(
          child: TextField(
              controller: controller,
              textAlign: TextAlign.center,
              maxLength: 30,
              maxLengthEnforcement:
                  MaxLengthEnforcement.truncateAfterCompositionEnds,
              style: const TextStyle(
                  color: primaryColor, fontWeight: FontWeight.bold),
              textAlignVertical: TextAlignVertical.bottom,
              decoration: kTextFieldDecoration.copyWith(
                hintText: title.substring(0, title.length - 1),
                suffixIcon: PopupMenuButton(
                  onSelected: (value) {
                    callBack(value, controller);
                  },
                  offset: const Offset(-10, 10),
                  itemBuilder: (ctx) => foodItems,
                  child: const Icon(
                    Icons.arrow_drop_down_rounded,
                    color: primaryColor,
                  ),
                ),
              )),
        ),
      )
    ],
  );
}

myNotifier(BuildContext context, String message,
    {String label = "",
    required Function function,
    int duration = 2,
    Color buttonColor = Colors.white}) async {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      backgroundColor: primaryColor,
      duration: Duration(seconds: duration),
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.down,
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
      action: label != ""
          ? SnackBarAction(
              label: label,
              disabledTextColor: Colors.white,
              textColor: buttonColor,
              onPressed: () async {
                await function();
              },
            )
          : null));
}
