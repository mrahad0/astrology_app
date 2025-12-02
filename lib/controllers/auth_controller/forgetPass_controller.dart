import 'dart:convert';
import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/data/services/api_checker.dart';
import 'package:astrology_app/data/services/api_client.dart';
import 'package:astrology_app/data/services/api_constant.dart';
import 'package:get/get.dart';

class ForgetPassController extends GetxController {

  RxBool isLoading = false.obs;

  forgetpassword(String email) async {
    isLoading(true);

    var headers = {'Content-Type': 'application/json'};
    var response = await ApiClient.postData(
      ApiConstant.forgotPassword,
      jsonEncode({"email":email}),
      headers: headers,
    );
    if (response.statusCode == 200) {

      Get.toNamed(Routes.otpScreen,arguments: email);

    } else {
      ApiChecker.checkApi(response);
    }
    isLoading(false);
  }
}
