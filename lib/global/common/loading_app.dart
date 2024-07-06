
 import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:secretarial_app/global/utils/color_app.dart';

Widget loadingAppWidget(){
  return const Padding(
    padding: EdgeInsets.all(30.0),
    child: Center(child: SpinKitCircle(
      color: Color.fromRGBO(143, 148, 251, 1),
      size: 70.0,
    )),
  );
}

