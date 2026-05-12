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

      style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(16)),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: ResponsiveHelper.fontSize(16),
          fontWeight: FontWeight.w400,
        ),

        filled: true,
        fillColor: CustomColors.secondbackgroundColor,

        contentPadding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.padding(14),
          vertical: ResponsiveHelper.padding(16),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
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
