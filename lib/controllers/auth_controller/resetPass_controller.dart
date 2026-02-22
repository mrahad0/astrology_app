import 'dart:convert';
import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/data/services/api_checker.dart';
import 'package:astrology_app/data/services/api_client.dart';
import 'package:astrology_app/data/services/api_constant.dart';
import 'package:get/get.dart';

class ResetPassController extends GetxController {
  RxBool isLoading = false.obs;

  Future<void> resetPassword(
      String email,
      String newPassword,
      String confirmPassword,
      ) async {
    isLoading(true);

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "email": email.trim(),
      "new_password": newPassword.trim(),
      "confirm_password": confirmPassword.trim(),
    });

    final response = await ApiClient.postData(
      ApiConstant.resetPassword,
      body,
      headers: headers,
    );

    if (response.statusCode == 200) {
      Get.offAllNamed(Routes.loginScreen);
      Get.snackbar("Success", "Password reset successfully!");
    } else {
      ApiChecker.checkApi(response);
    }

    isLoading(false);
  }
}

