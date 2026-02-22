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


  RxString profileImageUrl = ''.obs;

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
    try {
      isLoading(true);

      final response = await ApiClient.getData(ApiConstant.userprofile);

      if (response.statusCode == 200) {
        userInfo.value = UserProfile.fromJson(response.body);

        final profile = userInfo.value?.profile;

        // Populate text controllers
        nameController.text = userInfo.value?.name ?? '';
        emailController.text = userInfo.value?.email ?? '';
        dobController.text = profile?.dateOfBirth ?? '';
        timeController.text = profile?.timeOfBirth ?? '';
        countryController.text = profile?.birthCountry ?? '';
        cityController.text = profile?.birthCity ?? '';

        profileImageUrl.value = profile?.profilePictureUrl ?? '';
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      debugPrint("FETCH ERROR: $e");
    } finally {
      isLoading(false);
    }
  }
}

