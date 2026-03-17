// lib/views/pages/profile/accounts/change_pass.dart
import 'package:astrology_app/utils/responsive.dart';
import 'package:astrology_app/views/base/custom_button.dart';
import 'package:astrology_app/views/base/custom_password_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/profile_controller/change_pass_controller.dart';

class ChangePass extends StatefulWidget {
  const ChangePass({super.key});

  @override
  State<ChangePass> createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {

  final TextEditingController currentPasswordController = TextEditingController();

  final TextEditingController newPasswordController = TextEditingController();

  final TextEditingController confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _changePassController = Get.put(ChangePassController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.padding(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: ResponsiveHelper.space(50)),
              Row(
                children: [
                  GestureDetector(
                    onTap:  () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: ResponsiveHelper.iconSize(20),
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.space(20)),
                  Text(
                    "Change Password",
                    style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(18), fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveHelper.space(50)),

              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Current Password",
                  style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(16),
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
              SizedBox(height: ResponsiveHelper.space(12)),

              CustomPasswordField(
                controller: currentPasswordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Current Password is required";
                  }
                  return null;
                },
                hintText: "Enter Current Password",
              ),
              SizedBox(height: ResponsiveHelper.space(12)),

              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "New Password",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: ResponsiveHelper.fontSize(14)),
                ),
              ),
              SizedBox(height: ResponsiveHelper.space(12)),

              CustomPasswordField(
                controller: newPasswordController,
                hintText: "Enter New Password",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "New Password is required";
                  }
                  return null;
                },
              ),
              SizedBox(height: ResponsiveHelper.space(12)),

              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Confirm New Password",
                  style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(16),
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
              SizedBox(height: ResponsiveHelper.space(12)),

              CustomPasswordField(
                controller: confirmPasswordController,
                hintText: "Enter Confirm New Password",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Confirm New Password";
                  }
                  if (value != newPasswordController.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),

              SizedBox(height: ResponsiveHelper.space(40)),

              Obx(
                () => CustomButton(
                  text: "Update Password",
                  isLoading: _changePassController.isLoading.value,
                  onpress: () async {
                    if (_formKey.currentState!.validate()) {
                      final success = await _changePassController.changePassword(
                        currentPasswordController.text.trim(),
                        newPasswordController.text.trim(),
                        confirmPasswordController.text.trim(),
                      );
                      if (success && context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  },
                ),
              ),
              SizedBox(height: ResponsiveHelper.space(20)),
            ],
          ),
        ),
      ),
    );
  }
}
