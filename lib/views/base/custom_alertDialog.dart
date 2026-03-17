import 'package:astrology_app/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';


class CustomAlertdialog {
  final String title;
  final String content;
  final Callback onPressed;

  BuildContext context;

  CustomAlertdialog({required this.context, required this.title, required this.content, required this.onPressed});

  void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveHelper.radius(16)),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: ResponsiveHelper.fontSize(16),
            ),
          ),
          content: SizedBox(
            width: ResponsiveHelper.isTablet ? 400 : MediaQuery.of(context).size.width,
            child: Text(
              content,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: ResponsiveHelper.fontSize(14),
              ),
            ),
          ),
          actionsPadding: EdgeInsets.only(
            bottom: ResponsiveHelper.padding(16),
            left: ResponsiveHelper.padding(16),
            right: ResponsiveHelper.padding(16),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            // Cancel
            SizedBox(
              width: ResponsiveHelper.width(110),
              height: ResponsiveHelper.height(40),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade400),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black, fontSize: ResponsiveHelper.fontSize(14)),
                ),
              ),
            ),

            // Upgrade
            SizedBox(
              width: ResponsiveHelper.width(110),
              height: ResponsiveHelper.height(40),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8B3DFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  onPressed();
                },
                child: Text(
                  "Upgrade",
                  style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
