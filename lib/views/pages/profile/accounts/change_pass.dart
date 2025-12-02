import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_button.dart';
import 'package:astrology_app/views/base/custom_password_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePass extends StatefulWidget {
  const ChangePass({super.key});

  @override
  State<ChangePass> createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 20),
                Text(
                  "Change Password",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 50),

            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Current Password",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
            const SizedBox(height: 12),

            CustomPasswordField(
              controller: currentPasswordController,
              hintText: "Enter Current Password",
            ),
            const SizedBox(height: 12),

            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "New Password",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
              ),
            ),
            const SizedBox(height: 12),

            CustomPasswordField(
              controller: newPasswordController,
              hintText: "Enter New Password",
            ),
            const SizedBox(height: 12),

            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Confirm New Password",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
            const SizedBox(height: 12),

            CustomPasswordField(
              controller: confirmPasswordController,
              hintText: "Enter Confirm New Password",
            ),

            SizedBox(height: 40),

            CustomButton(
              text: "Update Password",
              onpress: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password Changed Successfully!'),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
