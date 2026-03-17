import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/utils/responsive.dart';
import 'package:flutter/material.dart';

class CustomTextFromField extends StatelessWidget {
  const CustomTextFromField({
    super.key,
    this.controller,
    this.hintText,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    this.onTap,
    this.suffixIcon,
    this.readOnly,
    this.focusNode,
    this.onChanged,
    this.onFieldSubmitted,
  });

  final TextEditingController? controller;
  final String? hintText;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final bool? readOnly;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap:onTap,
      controller: controller,
      readOnly: readOnly??false,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      focusNode: focusNode,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14)),
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: suffixIcon,
        hintStyle: TextStyle(
          color: Color(0xffABABAB),
          fontSize: ResponsiveHelper.fontSize(14),
          fontWeight: FontWeight.w400,
        ),

        filled: true,
        fillColor: CustomColors.secondbackgroundColor,

        contentPadding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.padding(12),
          vertical: ResponsiveHelper.padding(14),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.radius(10)),
          borderSide: const BorderSide(color: Colors.white38),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.radius(10)),
          borderSide: const BorderSide(color: Colors.white38),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.radius(10)),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.radius(10)),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),

        errorStyle: TextStyle(
          color: Colors.redAccent,
          fontSize: ResponsiveHelper.fontSize(12),
        ),
      ),
    );
  }
}
