import 'dart:io';
import 'package:astrology_app/data/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../Data/services/api_client.dart';
import '../../Data/services/api_constant.dart';
import '../../Data/services/api_checker.dart';
import 'package:image_picker/image_picker.dart';
import '../../helpers/prefs_helpers.dart';
import '../../Data/utils/app_constants.dart';

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

  // User profile
  Rx<UserProfile?> userProfile = Rx<UserProfile?>(null);

  final ApiClient apiClient = ApiClient();

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  /// Fetch user info from API
  Future<void> fetchUserProfile() async {
    try {
      isLoading(true);
      final response = await ApiClient.getData(ApiConstant.userprofile);
      if (response.statusCode == 200) {
        userProfile.value = UserProfile.fromJson(response.body);

        // Populate controllers safely
        nameController.text = userProfile.value?.name ?? "";
        emailController.text = userProfile.value?.email ?? "";
        dobController.text = userProfile.value?.profile?.dateOfBirth ?? "";
        timeController.text = userProfile.value?.profile?.timeOfBirth ?? "";
        countryController.text = userProfile.value?.profile?.birthCountry ?? "";
        cityController.text = userProfile.value?.profile?.birthCity ?? "";
      } else {
        ApiChecker.checkApi(response);
      }
    } finally {
      isLoading(false);
    }
  }

  /// Save updated info with image (multipart)
  Future<void> saveData() async {
    try {
      isLoading(true);

      final token = await PrefsHelper.getString(AppConstants.bearerToken);

      var uri = Uri.parse(ApiConstant.userprofile);
      var request = http.MultipartRequest('PUT', uri);
      request.headers['Authorization'] = 'Bearer $token';

      // Add text fields
      request.fields['name'] = nameController.text.trim();
      request.fields['email'] = emailController.text.trim();
      request.fields['profile[date_of_birth]'] = dobController.text.trim();
      request.fields['profile[time_of_birth]'] = timeController.text.trim();
      request.fields['profile[birth_country]'] = countryController.text.trim();
      request.fields['profile[birth_city]'] = cityController.text.trim();

      // Add image if selected
      if (profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profile_picture', // Must match backend field name
          profileImage!.path,
        ));
      }

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Profile updated successfully!");
        await fetchUserProfile(); // Refresh profile data
      } else {
        print("Error saving profile: ${response.body}");
        ApiChecker.checkApi(response as Response);
      }
    } finally {
      isLoading(false);
    }
  }

  /// Pick image from camera/gallery
  Future<File?> showImageSourceDialog(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Select Image Source"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, ImageSource.camera),
              child: const Text("Camera")),
          TextButton(
              onPressed: () => Navigator.pop(context, ImageSource.gallery),
              child: const Text("Gallery")),
        ],
      ),
    );

    if (source != null) {
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        profileImage = File(pickedFile.path);
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



