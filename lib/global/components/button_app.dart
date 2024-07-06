import 'package:secretarial_app/global/components/text_app_bold.dart';
import 'package:secretarial_app/global/utils/color_app.dart';
import 'package:flutter/cupertino.dart';

Widget buttonApp(
    {required String text, Color? color, double? width, double? height,void Function()? onTap,double? circular,FontWeight? fontWeight,double? sizeFont}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: width ?? 100,
      height: height ?? 100,
      decoration: BoxDecoration(
          color: color ?? ColorManager.gray6,
          borderRadius: BorderRadius.circular(circular ?? 10)),
      child: Center(child: textBold(text: text,fontWeight: fontWeight,color: ColorManager.white2,sizeFont:sizeFont ?? 20,)),
    ),
  );
}
