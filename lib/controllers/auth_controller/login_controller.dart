import 'dart:convert';

import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/data/services/api_checker.dart';
import 'package:astrology_app/data/services/api_client.dart';
import 'package:astrology_app/data/services/api_constant.dart';
import 'package:astrology_app/data/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/prefs_helpers.dart' show PrefsHelper;

class LoginController extends GetxController {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RxBool isRememberMe = false.obs;
  RxBool isLoading = false.obs;

  void onRememberMeChanged(bool value) => isRememberMe(value);

  login(String email, String password) async {
    isLoading(true);

    var headers = {'Content-Type': 'application/json'};

    var response = await ApiClient.postData(
      ApiConstant.login,
      jsonEncode({"email": email, "password": password}),
      headers: headers,
    );

    if (response.statusCode == 200) {
      await PrefsHelper.setString(
        AppConstants.bearerToken,
        response.body["tokens"]["access"],
      );
      Get.offAllNamed(Routes.mainScreen);
    } else {
      ApiChecker.checkApi(response);
    }

    isLoading(false);
  }
}
