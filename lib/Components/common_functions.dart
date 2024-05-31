import 'package:flutter/material.dart';

import 'common_widgets.dart';

const primaryColor = Color(0xFF8C9EFF);

const appLogo = Icons.fastfood;

push(BuildContext context, var screen) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => screen),
  );
}

pushAndRemoveUntil(BuildContext context, var screen) {
  Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => screen), (Route route) => false);
}

toast(BuildContext context, String text, [int duration = 1]) {
  myNotifier(context, text, duration: duration, function: () {});
}

InputDecoration kTextFieldDecoration = InputDecoration(
  hintText: "Category",
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: const BorderSide(color: primaryColor, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: const BorderSide(
      color: primaryColor,
      width: 2.0,
    ),
  ),
);

String dateFormat(DateTime dateTime) {
  return "${dateTime.day}-${dateTime.month}-${dateTime.year}";
}

String dateFormatText(DateTime dateTime) {
  return "${dateTime.day}/${monthsInYear[dateTime.month]}/${dateTime.year}";
}

const Map<int, String> monthsInYear = {
  1: "Jan",
  2: "Feb",
  3: "Mar",
  4: 'Apr',
  5: 'May',
  6: 'June',
  7: "Jul",
  8: 'Aug',
  9: 'Sep',
  10: 'Oct',
  11: 'Nov',
  12: "Dec"
};
