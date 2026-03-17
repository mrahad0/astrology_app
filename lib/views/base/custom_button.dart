import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/utils/responsive.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
 CustomButton({super.key,required this.text,this.onpress,this.isLoading = false
 });

  final String? text;
  final Function()? onpress;
 final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : SizedBox(
        width: double.infinity,
        height: ResponsiveHelper.height(50),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.radius(10)),
            ),
          ),
          onPressed:onpress,
          child:  Text(text!,
            style: TextStyle(fontSize: ResponsiveHelper.fontSize(14), fontWeight: FontWeight.w600,color: Colors.white),
          ),
        ),
      );
  }
}
