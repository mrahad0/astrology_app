import 'package:astrology_app/utils/responsive.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';


void showCustomSnackBar(String? message, {bool isError = true, bool getXSnackBar = false}) {
  if(message != null && message.isNotEmpty) {
    if(getXSnackBar) {
      Get.showSnackbar(GetSnackBar(
        backgroundColor: isError ? Colors.red.shade400 : Colors.green,
        message: message,
        duration: const Duration(seconds: 3),
        snackStyle: SnackStyle.FLOATING,
        margin: EdgeInsets.all(ResponsiveHelper.padding(10)),
        borderRadius: ResponsiveHelper.radius(8),
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
      ));
    }else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        dismissDirection: DismissDirection.horizontal,
        margin: EdgeInsets.only(
          right: ResponsiveHelper.padding(10),
          top: ResponsiveHelper.padding(10),
          bottom: ResponsiveHelper.padding(10),
          left: ResponsiveHelper.padding(10),
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: isError ? Colors.red.shade400 : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.radius(8))),
        content: Text(message, style: TextStyle(fontSize: ResponsiveHelper.fontSize(14), fontWeight: FontWeight.w500)),
      ));
    }
  }
}
