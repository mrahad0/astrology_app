import 'package:astrology_app/utils/color.dart';
import 'package:flutter/material.dart';

class CustomTextFromField extends StatelessWidget {
  CustomTextFromField({
    super.key,
    this.controller,
    this.hintText,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    this.onTap,
    this.suffixIcon,
    this.readOnly
  });

  final TextEditingController? controller;
  final String? hintText;
  bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  Function()? onTap;
  Widget? suffixIcon;
  bool? readOnly;



  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap:onTap,
      controller: controller,
      readOnly: readOnly??false,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: suffixIcon,
        hintStyle: const TextStyle(
          color: Color(0xffABABAB),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),

        filled: true,
        fillColor: CustomColors.secondbackgroundColor,

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white38),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white38),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),

        errorStyle: const TextStyle(
          color: Colors.redAccent,
          fontSize: 12,
        ),
      ),
    );
  }
}

