import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/utils/responsive.dart';
import 'package:flutter/material.dart';

class CustomPasswordField extends StatefulWidget {
  const CustomPasswordField({
    super.key,
    this.controller,
    this.hintText,
    this.validator,
    this.keyboardType,
  });

  final TextEditingController? controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: _obscureText,
      validator: widget.validator,

      style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14)),
      decoration: InputDecoration(
        hintText: widget.hintText,
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

        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.white70,
            size: ResponsiveHelper.iconSize(22),
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }
}
