import 'package:astrology_app/controllers/auth_controller/forgetPass_controller.dart';
import 'package:astrology_app/utils/responsive.dart';
import 'package:astrology_app/views/base/custom_button.dart';
import 'package:astrology_app/views/base/custom_textField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotpassScreen extends StatefulWidget {
  const ForgotpassScreen({super.key});

  @override
  State<ForgotpassScreen> createState() => _ForgotpassScreenState();
}

class _ForgotpassScreenState extends State<ForgotpassScreen> {

  final TextEditingController _emailCtrl = TextEditingController();

  final ForgetPassController _forgetController = Get.put(ForgetPassController());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/auth_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Form(
          key: _formKey,
        child: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              vertical: ResponsiveHelper.padding(20),
              horizontal: ResponsiveHelper.isTablet ? ResponsiveHelper.horizontalPadding : 20,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: ResponsiveHelper.maxContentWidth ?? double.infinity,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap:() => Navigator.pop(context),
                    child: Row(
                      children: [
                        Icon(Icons.arrow_back_ios, color: Colors.white),
                        SizedBox(width: ResponsiveHelper.space(10)),
                        Text(
                          "Forget Password",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveHelper.fontSize(24),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: ResponsiveHelper.space(250)),

                  Text(
                    "Select which contact details should we use to reset your password.",
                    style: TextStyle(fontSize: ResponsiveHelper.fontSize(16),
                        fontWeight: FontWeight.w500,
                        color: Colors.white),),

                  SizedBox(height: ResponsiveHelper.space(24)),

                  Align(alignment: Alignment.topLeft,
                      child: Text(
                        "Email",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: ResponsiveHelper.fontSize(14)
                        ),)),

                  SizedBox(height: ResponsiveHelper.space(10)),

                  CustomTextFromField(
                    hintText: "Enter your Email",
                    controller: _emailCtrl,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "email is required!";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: ResponsiveHelper.space(157)),

                  Obx(() =>
                      CustomButton(
                        text: "Continue",
                        isLoading: _forgetController.isLoading.value,
                        onpress: () {
                       if (_formKey.currentState!.validate()) {
                         _forgetController.forgetpassword(_emailCtrl.text);
                       }
                      },))
                ],
              ),
            ),
            ),
          ),
        ),
      ),
      ),
    );
  }
}
