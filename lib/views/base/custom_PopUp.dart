import 'package:astrology_app/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


void showSuccessPopup(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return SuccessPopup();
    },
  );
}


class SuccessPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(20)),
      ),
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.padding(30)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ResponsiveHelper.radius(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SvgPicture.asset("assets/icons/PopUp icon.svg"),
            SizedBox(height: ResponsiveHelper.space(20)),
            Text(
              'Your password has been reset successfully.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ResponsiveHelper.fontSize(16),
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: ResponsiveHelper.space(10)),
          ],
        ),
      ),
    );
  }
}
