import 'dart:convert';
import 'package:astrology_app/controllers/auth_controller/auth_controller.dart';
import 'package:astrology_app/data/services/api_checker.dart';
import 'package:astrology_app/data/services/api_client.dart';
import 'package:astrology_app/data/services/api_constant.dart';
import 'package:get/get.dart';

class VerifyEmail extends GetxController {
  RxBool isLoading = false.obs;

  final AuthController _authController = Get.find<AuthController>();

  /// Verify OTP
  Future<void> verifyemail(String otpCode, String email) async {
    if (otpCode.isEmpty) return;

    isLoading(true);

    final headers = {'Content-Type': 'application/json'};
    final body = {
      "email": email.trim(),
      "otp_code": otpCode.trim(),
    };

    final response = await ApiClient.postData(
      ApiConstant.verifyEmail,
      jsonEncode(body),
      headers: headers,
    );

    if (response.statusCode == 200) {
      Get.toNamed('/mainScreen', arguments: response.body['access']);
    } else {
      ApiChecker.checkApi(response);
    }

    isLoading(false);
  }

  /// Resend OTP
  Future<void> resendOtp(String email) async {
    if (!_authController.enableResend.value) return;

    _authController.startTimer(); // Restart the countdown
    isLoading(true);

    final headers = {'Content-Type': 'application/json'};
    final body = {"email": email.trim()};

    // ✅ Use the correct resend OTP endpoint
    final response = await ApiClient.postData(
      ApiConstant.resendOtp,
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
