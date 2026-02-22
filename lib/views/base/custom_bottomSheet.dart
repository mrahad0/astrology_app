import 'package:astrology_app/data/utils/app_constants.dart';
import 'package:astrology_app/helpers/prefs_helpers.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Routes/routes.dart';
void showLogoutBottomSheet(BuildContext context) {
  Get.bottomSheet(
    SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        decoration: BoxDecoration(
          color: CustomColors.backgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ছোট উপরের drag bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 15),

            // 🔴 Logout Title
            const Text(
              "Logout",
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),

            // Description Text
            const Text(
              "Are you sure you want to log out?",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 25),

            // 🔘 Buttons Row
            Row(
              children: [
                // Yes, Logout Button
                Expanded(
                  child: OutlinedButton(
                    onPressed:Navigator.of(context).pop,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),


                const SizedBox(width: 12),


                // Cancel Button
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
                        borderRadius: BorderRadius.circular(100),
                      ),
                      padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                    ),
                    child: const Text(
                      "Yes, Logout",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
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