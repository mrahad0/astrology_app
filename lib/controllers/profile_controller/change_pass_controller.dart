import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePassController extends GetxController {
  // Text Controllers
  final currentPassController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();

  // Reactive variables
  var currentPassError = RxnString();
  var newPassError = RxnString();
  var confirmPassError = RxnString();

  var obscureCurrent = true.obs;
  var obscureNew = true.obs;
  var obscureConfirm = true.obs;

  // Validate fields
  bool validateFields() {
    currentPassError.value = null;
    newPassError.value = null;
    confirmPassError.value = null;

    if (currentPassController.text.isEmpty) {
      currentPassError.value = "Current password cannot be empty";
    }

    if (newPassController.text.isEmpty) {
      newPassError.value = "New password cannot be empty";
    } else if (newPassController.text.length < 6) {
      newPassError.value = "New password must be at least 6 characters";
    }

    if (confirmPassController.text.isEmpty) {
      confirmPassError.value = "Please confirm new password";
    } else if (confirmPassController.text != newPassController.text) {
      confirmPassError.value = "Passwords do not match";
    }

    return currentPassError.value == null &&
        newPassError.value == null &&
        confirmPassError.value == null;
  }

  @override
  void onClose() {
    currentPassController.dispose();
    newPassController.dispose();
    confirmPassController.dispose();
    super.onClose();
  }
}
