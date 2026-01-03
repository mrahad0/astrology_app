import 'package:astrology_app/controllers/auth_controller/resetPass_controller.dart';
import 'package:astrology_app/routes/routes.dart';
import 'package:astrology_app/views/base/custom_PopUp.dart';
import 'package:astrology_app/views/base/custom_button.dart';
import 'package:astrology_app/views/base/custom_password_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewpassScreen extends StatefulWidget {
  const NewpassScreen({super.key});

  @override
  State<NewpassScreen> createState() => _NewpassScreenState();
}

class _NewpassScreenState extends State<NewpassScreen> {
  late String email;

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();

  final _resetPassController = Get.put(ResetPassController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    email = Get.arguments?["email"] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.arrow_back_ios_new),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Forgot Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 250),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Create New Password",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 24),
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
              SizedBox(height: 12),
              CustomPasswordField(
                controller: newPasswordController,
                hintText: "Enter your password",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "New Password is required";
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Re Type New Password",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                ),
              ),
              SizedBox(height: 12),
              CustomPasswordField(
                controller: rePasswordController,
                hintText: "Re-enter your password",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Re-Enter Password";
                  }
                  if (value != newPasswordController.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),
              SizedBox(height: 83),
              Obx(() => CustomButton(
                text: "Create Now",
                isLoading: _resetPassController.isLoading.value,
                onpress: () async {
                  if (_formKey.currentState!.validate()) {
                    await _resetPassController.resetPassword(
                      email,
                      newPasswordController.text.trim(),
                      rePasswordController.text.trim(),
                    );
                  }
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}

