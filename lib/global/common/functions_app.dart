import 'package:secretarial_app/global/data/local/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
 import 'package:secretarial_app/global/utils/key_shared.dart';
import 'package:secretarial_app/global/data/local/cache_helper.dart';

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

void navigateAndFinish(
  context,
  widget,
) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) {
        return false;
      },
    );

language() {
  Locale initialLang = CacheHelper.getData(key: LANGUAGE) == null
      // ? Get.deviceLocale!
      ? Locale('ar')
      : Locale(CacheHelper.getData(key: LANGUAGE));
  return initialLang;
}
