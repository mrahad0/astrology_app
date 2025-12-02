import 'dart:convert';
import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/data/services/api_checker.dart';
import 'package:astrology_app/data/services/api_client.dart';
import 'package:astrology_app/data/services/api_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  RxBool isLoading = false.obs;

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String dob,
    required String tob,
    required String country,
    required String city,
    required bool agree,
  }) async {
    // Prevent multiple calls
    if (isLoading.value) {
      print("====> Already processing, ignoring duplicate call");
      return;
    }

    // Validate all inputs before API call
    if (!_validateInputs(
      name: name,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      dob: dob,
      tob: tob,
      country: country,
      city: city,
      agree: agree,
    )) {
      return;
    }

    try {
      isLoading(true);

      final Map<String, dynamic> body = {
        "name": name.trim(),
        "email": email.trim().toLowerCase(),
        "i_agree": agree,
        "password": password,
        "confirm_password": confirmPassword,
        "profile": {
          "date_of_birth": dob,
          "time_of_birth": tob,
          "birth_country": country.trim(),
          "birth_city": city.trim(),
        }
      };

      print("====> API Call: ${ApiConstant.register}");
      print("====> API Body: $body");

      final headers = {"Content-Type": "application/json"};

      final response = await ApiClient.postData(
        ApiConstant.register,
        jsonEncode(body),
        headers: headers,
      );

      print("====> Response Status: ${response.statusCode}");
      print("====> Response Body: ${response.body}");

      // Check if response is null or status code is unusual
      if (response.statusCode == 1 || response.body == null) {
        print("====> Network Error or Timeout");
        _showErrorSnackbar("Network error. Please check your internet connection.");
        return;
      }

      // Success: 200 or 201
      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSuccessSnackbar("Account created successfully!");
        print("====> Navigate to OTP screen");

        // Small delay to show success message
        await Future.delayed(Duration(milliseconds: 500));

        Get.offAllNamed(Routes.otpForCreate, arguments: email.trim().toLowerCase());
      } else if (response.statusCode == 400) {
        // Bad request - possibly email already exists
        try {
          final responseData = jsonDecode(response.body);
          final errorMessage = responseData['message'] ??
              responseData['error'] ??
              'Registration failed';
          _showErrorSnackbar(errorMessage);
        } catch (e) {
          _showErrorSnackbar("Invalid request. Please check your information.");
        }
      } else if (response.statusCode == 422) {
        // Validation error
        _showErrorSnackbar("Validation error. Please check your information.");
      } else {
        // Other errors
        ApiChecker.checkApi(response);
      }
    } on Exception catch (e) {
      print("====> Register Error: $e");
      _showErrorSnackbar("Registration failed. Please try again.");
    } catch (e) {
      print("====> Unexpected Error: $e");
      _showErrorSnackbar("Something went wrong. Please try again.");
    } finally {
      isLoading(false);
    }
  }

  /// Validates all registration inputs
  bool _validateInputs({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String dob,
    required String tob,
    required String country,
    required String city,
    required bool agree,
  }) {
    // Name validation
    if (name.trim().isEmpty) {
      _showErrorSnackbar("Please enter your name");
      return false;
    }

    if (name.trim().length < 2) {
      _showErrorSnackbar("Name must be at least 2 characters");
      return false;
    }

    // Email validation
    if (email.trim().isEmpty) {
      _showErrorSnackbar("Please enter your email");
      return false;
    }

    if (!GetUtils.isEmail(email.trim())) {
      _showErrorSnackbar("Please enter a valid email address");
      return false;
    }

    // Password validation
    if (password.isEmpty) {
      _showErrorSnackbar("Please enter a password");
      return false;
    }

    if (password.length < 6) {
      _showErrorSnackbar("Password must be at least 6 characters");
      return false;
    }

    // Confirm password validation
    if (confirmPassword.isEmpty) {
      _showErrorSnackbar("Please confirm your password");
      return false;
    }

    if (password != confirmPassword) {
      _showErrorSnackbar("Passwords do not match");
      return false;
    }

    // Date of birth validation
    if (dob.trim().isEmpty) {
      _showErrorSnackbar("Please select your date of birth");
      return false;
    }

    // Time of birth validation
    if (tob.trim().isEmpty) {
      _showErrorSnackbar("Please select your time of birth");
      return false;
    }

    // Country validation
    if (country.trim().isEmpty) {
      _showErrorSnackbar("Please enter your birth country");
      return false;
    }

    // City validation
    if (city.trim().isEmpty) {
      _showErrorSnackbar("Please enter your birth city");
      return false;
    }

    // Agreement validation
    if (!agree) {
      _showErrorSnackbar("Please agree to the privacy policy");
      return false;
    }

    return true;
  }

  /// Shows error snackbar with consistent styling
  void _showErrorSnackbar(String message) {
    Get.snackbar(
      "Error",
      message,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(10),
      duration: Duration(seconds: 3),
      isDismissible: true,
    );
  }

  /// Shows success snackbar
  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      "Success",
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(10),
      duration: Duration(seconds: 2),
      isDismissible: true,
    );
  }

  @override
  void onClose() {
    super.onClose();
  }
}