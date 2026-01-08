import 'dart:convert';
import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/data/services/api_checker.dart';
import 'package:astrology_app/data/services/api_client.dart';
import 'package:astrology_app/data/services/api_constant.dart';
import 'package:astrology_app/views/base/custom_snackBar.dart';
import 'package:get/get.dart';


class RegisterController extends GetxController {
  RxBool isLoading = false.obs;

  Future<void> register(Map<String, dynamic> body) async {
    try {
      isLoading(true);

      final headers = {"Content-Type": "application/json"};

      final response = await ApiClient.postData(
        ApiConstant.register,
        jsonEncode(body),
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar("Account created successfully!", isError: false);
        Get.toNamed(Routes.otpForCreate, arguments: body['email'].trim());
      } else {
        ApiChecker.checkApi(response);
      }
    } finally {
      isLoading(false);
    }
  }
}
