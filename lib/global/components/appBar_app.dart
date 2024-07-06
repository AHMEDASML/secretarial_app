import 'package:secretarial_app/global/utils/color_app.dart';
import 'package:flutter/material.dart';

AppBar appBarApp({
  required String text,
  double? fontSize,
  Widget? widget,

  VoidCallback? onBackPress,
}) {
  return AppBar(
    title:  Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
        color: Colors.white,
      ),
    ),
    centerTitle: true,
    backgroundColor: Color.fromRGBO(143, 148, 251, 1),
    elevation: 4.0,
    shadowColor: Colors.black.withOpacity(0.5),
    leading:    widget?? Text(''),

    actions: [


    ],
  );
}
