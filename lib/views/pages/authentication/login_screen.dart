import 'package:astrology_app/controllers/auth_controller/auth_controller.dart';
import 'package:astrology_app/controllers/auth_controller/login_controller.dart';
import 'package:astrology_app/routes/routes.dart';
import 'package:astrology_app/utils/responsive.dart';
import 'package:astrology_app/views/base/custom_button.dart';
import 'package:astrology_app/views/base/custom_textField.dart';
import 'package:astrology_app/views/base/custom_password_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController _loginController = Get.put(LoginController());
  final AuthController _authController = Get.put(AuthController());

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
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.isTablet
                    ? ResponsiveHelper.horizontalPadding
                    : 20,
                vertical: ResponsiveHelper.padding(20),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: ResponsiveHelper.maxContentWidth ?? double.infinity,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Image.asset(
                      "assets/images/logo.png1.png",
                      height: ResponsiveHelper.height(250),
                      width: ResponsiveHelper.width(250),
                    ),

                    SizedBox(height: ResponsiveHelper.space(10)),

                    Text(
                      "Universal Astro Expert",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.fontSize(24),
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    SizedBox(height: ResponsiveHelper.space(30)),

                    // Email
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "E-mail",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: ResponsiveHelper.fontSize(14),
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.space(10)),

                    CustomTextFromField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        }
                        return null;
                      },
                      controller: _loginController.emailController,
                      hintText: "Enter your email",
                    ),

                    SizedBox(height: ResponsiveHelper.space(20)),

                    // Password
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Password",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: ResponsiveHelper.fontSize(14),
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.space(10)),

                    CustomPasswordField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password";
                        }
                        return null;
                      },
                      controller: _loginController.passwordController,
                      hintText: "Enter your password",
                    ),

                    SizedBox(height: ResponsiveHelper.space(10)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() => Row(
                          children: [
                            Checkbox(
                              value: _authController.isRememberMe.value,
                              onChanged: (value) {
                                _authController.isRememberMe.value = value!;
                              },
                              side: BorderSide(color: Colors.white),
                              checkColor: Colors.white,
                              activeColor: Color(0xff6F3DFF),
                            ),
                            Text(
                              "Remember me",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: ResponsiveHelper.fontSize(14),
                              ),
                            ),
                          ],
                        )),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.forgotScreen);
                          },
                          child: Text(
                            "Forgot password?",
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w500,
                              fontSize: ResponsiveHelper.fontSize(14),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: ResponsiveHelper.space(25)),

                    Obx(
                          () => CustomButton(
                        text: "Sign In",
                        isLoading: _loginController.isLoading.value,
                        onpress: () {
                          if (_formKey.currentState!.validate()) {
                            _loginController.login(
                              _loginController.emailController.text,
                              _loginController.passwordController.text,
                            );
                          }
                        },
                      ),
                    ),

                    SizedBox(height: ResponsiveHelper.space(25)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an Account? ",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: ResponsiveHelper.fontSize(14),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.signUpScreen);
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Color(0xFF9726F2),
                              fontWeight: FontWeight.w600,
                              fontSize: ResponsiveHelper.fontSize(14),
                            ),
                          ),
                        ),
                      ],
                    ),
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
