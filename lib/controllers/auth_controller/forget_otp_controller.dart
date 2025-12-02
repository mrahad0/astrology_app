import 'dart:convert';
import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/controllers/auth_controller/auth_controller.dart';
import 'package:astrology_app/data/services/api_checker.dart';
import 'package:astrology_app/data/services/api_client.dart';
import 'package:astrology_app/data/services/api_constant.dart';
import 'package:get/get.dart';

class ForgetOtpController extends GetxController {
  RxBool isLoading = false.obs;

  final AuthController _authController = Get.find<AuthController>();

  /// Verify OTP
  Future<void> forgetotp(String otpCode, String email) async {
    if (otpCode.isEmpty) return;

    isLoading(true);

    final headers = {'Content-Type': 'application/json'};
    final body = {
      "email": email.trim(),
      "otp_code": otpCode.trim(),
    };

    final response = await ApiClient.postData(
      ApiConstant.forgetOtp,
      jsonEncode(body),
      headers: headers,
    );

    if (response.statusCode == 200) {
      // Navigate to NewPassScreen with only the email
      Get.toNamed(
        Routes.newPassScreen,
        arguments: {"email": email},
      );
    } else {
      ApiChecker.checkApi(response);
    }

    isLoading(false);
  }

  /// Resend OTP
  Future<void> forgetResendOtp(String email) async {
    if (!_authController.enableResend.value) return;

    _authController.startTimer(); // Restart the countdown
    isLoading(true);

    final headers = {'Content-Type': 'application/json'};
    final body = {"email": email.trim()};

    final response = await ApiClient.postData(
      ApiConstant.forgetResendOtp,
      jsonEncode(body),
      headers: headers,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.snackbar("Success", "OTP has been resent.");
    } else {
      ApiChecker.checkApi(response);
    }

    isLoading(false);
  }
}
