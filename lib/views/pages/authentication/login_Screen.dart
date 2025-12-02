import 'package:astrology_app/controllers/auth_controller/auth_controller.dart';
import 'package:astrology_app/controllers/auth_controller/login_controller.dart';
import 'package:astrology_app/routes/routes.dart';
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
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Image.asset(
                    "assets/images/logo.png",
                    height: 150,
                  ),
                  const SizedBox(height: 25),

                  const Text(
                    "Universal Astrology",
                    style: TextStyle(
                      color: Color(0xFFA855F7),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Email
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "E-mail",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

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

                  const SizedBox(height: 20),

                  // Password
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Password",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

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

                  const SizedBox(height: 10),

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
                          const Text(
                            "Remember me",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      )),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.forgotScreen);
                        },
                        child: const Text(
                          "Forgot password?",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  Obx(
                        () => CustomButton(
                      text: "Sign In",
                      isLoading: _authController.isLoading.value,
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

                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don’t have an Account? ",
                        style: TextStyle(color: Colors.white70),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.signUpScreen);
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Color(0xFF9726F2),
                            fontWeight: FontWeight.w600,
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
    );
  }
}
