import 'package:astrology_app/controllers/auth_controller/forgetPass_controller.dart';
import 'package:astrology_app/routes/routes.dart';
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

  TextEditingController _emailCtrl=TextEditingController();

  final ForgetPassController _forgetController = Get.put(ForgetPassController());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.arrow_back_ios_new),
                    onPressed: () {
                      Get.back();
                    },
                  ),

                  SizedBox(width: 10,),

                  Text('Forgot Password',style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500
                  ),),
                ],
              ),

              SizedBox(
                height: 250,
              ),

              Text(
                "Select which contact details should we use to reset your password.",
                style: TextStyle(fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),),

              SizedBox(height: 24,),

              Align(alignment: Alignment.topLeft,
                  child: Text(
                    "E-mail",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14
                    ),)),

              const SizedBox(height: 10),

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

              SizedBox(height: 157),

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
    );
  }
}
