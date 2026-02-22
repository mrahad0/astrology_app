import 'package:astrology_app/controllers/auth_controller/auth_controller.dart';
import 'package:astrology_app/controllers/auth_controller/verifyemail_controller.dart';
import 'package:astrology_app/helpers/time_formatter.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OtpForCreate extends StatefulWidget {
  const OtpForCreate({super.key});

  @override
  State<OtpForCreate> createState() => _OtpForCreate();
}

class _OtpForCreate extends State<OtpForCreate> {
  final VerifyEmail _verifyEmail = Get.put(VerifyEmail());
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController _pinPutController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _authController.startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _authController.disposeTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 74,
      height: 50,
      textStyle: const TextStyle(
          fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.white38),
        borderRadius: BorderRadius.circular(5),
      ),
    );

    return Scaffold(
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Obx(() => Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      color: Colors.white,
                      icon: const Icon(Icons.arrow_back_ios_new),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Verify Email',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 250),
                const Center(
                  child: Text(
                    "Code has been sent",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 24),
                Pinput(
                  defaultPinTheme: defaultPinTheme,
                  controller: _pinPutController,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return "Please enter the OTP code";
                    }
                    if (v.length < 6) {
                      return "Enter a valid code";
                    }
                    return null;
                  },
                  length: 6,
                ),
                const SizedBox(height: 24),

                // ---------- Resend OTP ----------
                _authController.enableResend.value
                    ? TextButton(
                  onPressed: () async {
                    await _verifyEmail.resendOtp(Get.arguments);
                  },
                  child: Text(
                    "Resend Code",
                    style: TextStyle(
                        color: CustomColors.primaryColor),
                  ),
                )
                    : RichText(
                  text: TextSpan(
                    text: formatTime(
                      _authController.secondsRemaining.value,
                    ),
                    style: TextStyle(
                        color: CustomColors.primaryColor,
                        fontSize: 14),
                    children: const [
                      TextSpan(
                        text: "  Resend Confirmation Code.",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 150),

                // ---------- Verify Button ----------
                Obx(() => CustomButton(
                  text: "Verify",
                  isLoading: _authController.isLoading.value,
                  onpress: () {
                    if (_formKey.currentState!.validate()) {
                      _verifyEmail.verifyemail(
                          _pinPutController.text, Get.arguments);
                    }
                  },
                )),
              ],
            )),
          ),
        ),
      ),
    );
  }
}

