import 'dart:io';
import 'package:astrology_app/data/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Data/services/api_client.dart';
import '../../Data/services/api_constant.dart';
import '../../Data/services/api_checker.dart';
import 'package:image_picker/image_picker.dart';


class PersonalInfoEditController extends GetxController {
  RxBool isLoading = false.obs;

  // Text Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  // Profile image
  Rx<File?> profileImageFile = Rx<File?>(null);
  File? get profileImage => profileImageFile.value;
  set profileImage(File? file) => profileImageFile.value = file;

  // User Profile Data
  Rx<UserProfile?> userProfile = Rx<UserProfile?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  /// ------------------------- FETCH PROFILE -------------------------
  Future<void> fetchUserProfile() async {
    try {
      isLoading(true);

      final response = await ApiClient.getData(ApiConstant.userprofile);

      if (response.statusCode == 200) {
        userProfile.value = UserProfile.fromJson(response.body);

        // Populate text fields
        nameController.text = userProfile.value?.name ?? "";
        emailController.text = userProfile.value?.email ?? "";
        dobController.text = userProfile.value?.profile?.dateOfBirth ?? "";
        timeController.text = userProfile.value?.profile?.timeOfBirth ?? "";
        countryController.text = userProfile.value?.profile?.birthCountry ?? "";
        cityController.text = userProfile.value?.profile?.birthCity ?? "";
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      debugPrint("FETCH ERROR: $e");
    } finally {
      isLoading(false);
    }
  }

  /// ------------------------- UPDATE PROFILE (PATCH MULTIPART) -------------------------
  Future<void> saveData() async {
    try {
      isLoading(true);

      // Build body with DRF-compatible flat field names
      Map<String, String> body = {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'date_of_birth': dobController.text.trim(),
        'time_of_birth': timeController.text.trim(),
        'birth_country': countryController.text.trim(),
        'birth_city': cityController.text.trim(),
      };

      // Log for debugging
      debugPrint("=== Preparing PATCH to ${ApiConstant.userprofile}");
      debugPrint("=== Fields: $body");
      debugPrint("=== File path: ${profileImage?.path}");

      List<MultipartBody> files = [];
      if (profileImage != null) {
        // DRF expects 'profile_picture' field name (flat)
        files.add(MultipartBody('profile_picture', profileImage!));
      }

      final response = await ApiClient.patchMultipartData(
        ApiConstant.userprofile,
        body,
        multipartBody: files,
      );

      debugPrint("UPDATE STATUS: ${response.statusCode}");
      debugPrint("UPDATE BODY: ${response.body}");

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Profile updated successfully!");
        await fetchUserProfile();
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      debugPrint("UPDATE ERROR: $e");
      Get.snackbar("Error", "Failed to update profile. Try again!");
    } finally {
      isLoading(false);
    }
  }

  /// ------------------------- PICK IMAGE -------------------------
  Future<File?> showImageSourceDialog(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

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
        return profileImage;
      }
    }
    return null;
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







