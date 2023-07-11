import 'package:flutter/material.dart';

void myFixedSnackBar(
  BuildContext context,
  String text,
  Color bgColor,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        textAlign: TextAlign.start,
        style: TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
      duration: Duration(
        seconds: 3,
      ),
      behavior: SnackBarBehavior.fixed,
      backgroundColor: bgColor,
    ),
  );
}
