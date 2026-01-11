import 'dart:convert';
import 'package:get/get.dart';
import '../../Data/services/api_checker.dart';
import '../../Data/services/api_client.dart';
import '../../Data/services/api_constant.dart';
import '../../views/base/custom_snackBar.dart';

class ChangePassController extends GetxController {
  RxBool isLoading = false.obs;

  Future<bool> changePassword(
      String oldPassword,
      String newPassword,
      String confirmPassword,
      ) async {

    isLoading(true);

    final body = jsonEncode({
      "old_password": oldPassword.trim(),
      "new_password": newPassword.trim(),
      "confirm_password": confirmPassword.trim(),
    });

    final response = await ApiClient.postData(
      ApiConstant.userChangePassword,
      body,
    );

    isLoading(false);

    if (response.statusCode == 200) {
      showCustomSnackBar(
          response.body["message"] ?? "Password changed successfully!", isError: false);
      return true;
    } else {
      ApiChecker.checkApi(response);
      return false;
    }
  }
}

