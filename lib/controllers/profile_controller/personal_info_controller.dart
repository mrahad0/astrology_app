// import 'package:astrology_app/data/models/profile_model.dart';
// import 'package:astrology_app/data/services/api_checker.dart';
// import 'package:astrology_app/data/services/api_client.dart';
// import 'package:astrology_app/data/services/api_constant.dart';
// import 'package:flutter/material.dart';
//
// class PersonalInfoController {
//   final TextEditingController nameController = TextEditingController(text: 'Sadiq');
//   final TextEditingController emailController = TextEditingController(text: 'Sadiq1999@gmail.com');
//   final TextEditingController dobController = TextEditingController(text: '12/12/1999');
//   final TextEditingController timeController = TextEditingController(text: '12:00 pm');
//   final TextEditingController countryController = TextEditingController(text: 'Bangladesh');
//   final TextEditingController cityController = TextEditingController(text: 'Dhaka');
//
//   // Dispose all controllers
//   void dispose() {
//     nameController.dispose();
//     emailController.dispose();
//     dobController.dispose();
//     timeController.dispose();
//     countryController.dispose();
//     cityController.dispose();
//   }
//
//   // Get all data as a Map
//   Map<String, String> getData() {
//     return {
//       'name': nameController.text,
//       'email': emailController.text,
//       'dateOfBirth': dobController.text,
//       'timeOfBirth': timeController.text,
//       'birthCountry': countryController.text,
//       'birthCity': cityController.text,
//     };
//   }
//
//   // Clear all fields
//   void clearAll() {
//     nameController.clear();
//     emailController.clear();
//     dobController.clear();
//     timeController.clear();
//     countryController.clear();
//     cityController.clear();
//   }
// }

import 'package:astrology_app/data/models/profile_model.dart';
import 'package:astrology_app/data/services/api_checker.dart';
import 'package:astrology_app/data/services/api_client.dart';
import 'package:astrology_app/data/services/api_constant.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class PersonalInfoController extends GetxController {
  var isLoading = false.obs;
  var userInfo = Rxn<UserProfile>();

  // Text controllers for UI
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    dobController.dispose();
    timeController.dispose();
    countryController.dispose();
    cityController.dispose();
    super.onClose();
  }

  Future<void> fetchUserInfo() async {
    isLoading(true);

    final response = await ApiClient.getData(ApiConstant.userprofile);

    if (response.statusCode == 200) {
      userInfo.value = UserProfile.fromJson(response.body);

      // populate text controllers
      nameController.text = userInfo.value?.name ?? '';
      emailController.text = userInfo.value?.email ?? '';
      dobController.text = userInfo.value?.profile?.dateOfBirth ?? '';
      timeController.text = userInfo.value?.profile?.timeOfBirth ?? '';
      countryController.text = userInfo.value?.profile?.birthCountry ?? '';
      cityController.text = userInfo.value?.profile?.birthCity ?? '';
    } else {
      ApiChecker.checkApi(response);
    }

    isLoading(false);
  }
}
