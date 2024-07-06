import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:secretarial_app/global/utils/color_app.dart';

class TextFieldApp extends StatelessWidget {
  final String hintText;
  final Widget prefixIcon;
  final Widget suffixIcon;
  final TextInputType textInputType;
  final int maxLines;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const TextFieldApp(
      {Key? key,
        required this.hintText,
        required this.prefixIcon,
        required this.suffixIcon,
        required this.textInputType,
        this.maxLines = 1,
        this.onChanged,
        this.controller,
        this.obscureText = false,
        this.inputFormatters, this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Container(
          decoration: BoxDecoration(

              boxShadow: const [
                BoxShadow(
                    color: Color.fromRGBO(23, 23, 26, 0.4),
                    blurRadius: 10.0,
                    offset: Offset(0, 5)
                )
              ],
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromRGBO(195, 197, 255, 1.0),
          ),


          child: TextFormField(
            validator: validator,
            inputFormatters: inputFormatters,
            obscureText: obscureText,
            controller: controller,
            keyboardType: textInputType,
            maxLines: maxLines,
            cursorColor: const Color.fromRGBO(143, 148, 251, 1),
            style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 1.0), fontSize: 16),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromRGBO(
                    77, 167, 255, 1.0)), // Custom color border
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromRGBO(143, 148, 251, 1)), // Custom color border
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
              ),
              suffixIconColor: const Color.fromRGBO(143, 148, 251, 1),
              prefixIconColor: const Color.fromRGBO(143, 148, 251, 1),
              // filled: true,
              fillColor: const Color.fromRGBO(184, 187, 255, 0.6), // Custom background color
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.black, fontSize: 16),
              contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==============================================





class ShortTextFieldDateApp extends StatelessWidget {
  final String hintText;
  final TextInputType textInputType;
  final TextEditingController? controller;
  final int inputFormatters;

  const ShortTextFieldDateApp({Key? key, required this.hintText,
    required this.textInputType, this.controller, required this.inputFormatters}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      inputFormatters: [
        LengthLimitingTextInputFormatter(inputFormatters),
      ],
      textAlign: TextAlign.center,
      controller: controller,
      // onChanged: onChanged,
      keyboardType: textInputType,
      style: TextStyle(color: ColorManager.secondBlue, fontSize: 16),
      decoration: InputDecoration(
        fillColor: Colors.transparent,
        hintText: hintText,

        hintStyle: TextStyle(

          color: ColorManager.gray1, fontSize: 16,),
      ),
    );
  }
}
