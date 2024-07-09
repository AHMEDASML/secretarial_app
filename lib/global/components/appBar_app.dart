import 'package:get/get.dart';
import 'package:secretarial_app/global/utils/color_app.dart';
import 'package:flutter/material.dart';

AppBar appBarApp({
  required String text,
  double? fontSize,
  Widget? widget,
  VoidCallback? onBackPress,
}) {
  return AppBar(
    title: Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: fontSize ?? 24,
        color: Colors.white,
      ),
    ),
    centerTitle: true,
    backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
    elevation: 4.0,
    shadowColor: Colors.black.withOpacity(0.5),
    leading: widget ?? IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: onBackPress ?? () {
        // Default back button action
        Get.back();
      },
    ),
    actions: [],
  );
}
