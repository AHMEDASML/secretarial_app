import 'package:secretarial_app/global/utils/color_app.dart';
import 'package:flutter/cupertino.dart';

Widget textSlime({required String text,
  double? sizeFont,FontWeight? fontWeight,Color? color}){
  return Text(
      text,
      style: TextStyle(
    fontSize: sizeFont ?? 14,
    fontWeight: fontWeight ?? FontWeight.w300,
    color: color ?? ColorManager.firstBlack,
  ));
}