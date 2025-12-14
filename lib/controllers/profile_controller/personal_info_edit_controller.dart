import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../Data/services/api_checker.dart';
import '../../Data/services/api_client.dart';
import '../../Data/services/api_constant.dart';
import '../../data/models/profile_model.dart';

class PersonalInfoEditController extends GetxController {
  RxBool isLoading = false.obs;

  // Text Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();
  final timeController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();

  // Image
  Rx<File?> profileImageFile = Rx<File?>(null);
  File? get profileImage => profileImageFile.value;
  set profileImage(File? file) => profileImageFile.value = file;

  // Profile Data
  Rx<UserProfile?> userProfile = Rx<UserProfile?>(null);

  // Profile image URL for UI
  RxString profileImageUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  /// ---------------- FETCH PROFILE ----------------
  Future<void> fetchUserProfile() async {
    try {
      isLoading(true);

      final response = await ApiClient.getData(ApiConstant.userprofile);

      if (response.statusCode == 200) {
        userProfile.value = UserProfile.fromJson(response.body);

        final profile = userProfile.value?.profile;

        nameController.text = userProfile.value?.name ?? '';
        emailController.text = userProfile.value?.email ?? '';
        dobController.text = profile?.dateOfBirth ?? '';
        timeController.text = profile?.timeOfBirth ?? '';
        countryController.text = profile?.birthCountry ?? '';
        cityController.text = profile?.birthCity ?? '';

        // ✅ Use full URL for NetworkImage
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

  /// ---------------- UPDATE PROFILE ----------------
  Future<void> saveData() async {
    try {
      isLoading(true);

      final body = {
        'name': nameController.text.trim(),
        'date_of_birth': dobController.text.trim(),
        'time_of_birth': timeController.text.trim(),
        'birth_country': countryController.text.trim(),
        'birth_city': cityController.text.trim(),
      };

      List<MultipartBody> files = [];
      if (profileImage != null) {
        files.add(MultipartBody('profile_picture', profileImage!));
      }

      final response = await ApiClient.patchMultipartData(
        ApiConstant.userprofile,
        body,
        multipartBody: files,
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Profile updated successfully");
        await fetchUserProfile();
        profileImageFile.value = null; // reset picked image
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      debugPrint("UPDATE ERROR: $e");
      Get.snackbar("Error", "Failed to update profile");
    } finally {
      isLoading(false);
    }
  }

  /// ---------------- PICK IMAGE ----------------
  Future<void> pickImage(BuildContext context) async {
    final picker = ImagePicker();

    final source = await showDialog<ImageSource>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Select Image Source"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: const Text("Camera"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: const Text("Gallery"),
          ),
        ],
      ),
    );

    if (source != null) {
      final picked = await picker.pickImage(source: source);
      if (picked != null) {
        profileImage = File(picked.path);
      }
    }
  }

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
}









