import 'package:astrology_app/data/utils/app_constants.dart';
import 'package:astrology_app/helpers/prefs_helpers.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Routes/routes.dart';
void showLogoutBottomSheet(BuildContext context) {
  Get.bottomSheet(
    SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.padding(20), vertical: ResponsiveHelper.padding(25)),
        decoration: BoxDecoration(
          color: CustomColors.backgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.radius(20))),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: ResponsiveHelper.width(40),
              height: ResponsiveHelper.height(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(ResponsiveHelper.radius(10)),
              ),
            ),
            SizedBox(height: ResponsiveHelper.space(15)),

            Text(
              "Logout",
              style: TextStyle(
                color: Colors.red,
                fontSize: ResponsiveHelper.fontSize(20),
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: ResponsiveHelper.space(10)),
            const Divider(),
            SizedBox(height: ResponsiveHelper.space(10)),

            Text(
              "Are you sure you want to log out?",
              style: TextStyle(
                fontSize: ResponsiveHelper.fontSize(16),
                color: Colors.grey,
              ),
            ),

            SizedBox(height: ResponsiveHelper.space(25)),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed:Navigator.of(context).pop,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(100)),
                      ),
                      padding:
                      EdgeInsets.symmetric(vertical: ResponsiveHelper.padding(14), horizontal: ResponsiveHelper.padding(8)),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: ResponsiveHelper.fontSize(14),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: ResponsiveHelper.space(12)),

                Expanded(
                  child: ElevatedButton(

                    onPressed: () async {
                      await PrefsHelper.remove(AppConstants.bearerToken);
                      Get.offAllNamed(Routes.loginScreen);
                      Get.snackbar("Logged out", "You have been logged out!");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(100)),
                      ),
                      padding:
                      EdgeInsets.symmetric(vertical: ResponsiveHelper.padding(14), horizontal: ResponsiveHelper.padding(8)),
                    ),
                    child: Text(
                      "Yes, Logout",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: ResponsiveHelper.fontSize(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}