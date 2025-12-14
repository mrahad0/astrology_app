import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/controllers/profile_controller/personal_info_controller.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonalInfo extends StatelessWidget {
  PersonalInfo({Key? key}) : super(key: key);

  final PersonalInfoController controller = Get.put(PersonalInfoController());

  @override
  Widget build(BuildContext context) {
    controller.fetchUserInfo();

    return Scaffold(
      appBar: CustomAppBar(
        title: "Personal Information",
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          if (controller.userInfo.value == null) {
            return Center(
              child: Text(
                "No user info available",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final user = controller.userInfo.value!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: CustomColors.secondbackgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF2A2F4A)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with Edit Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Personal Information',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => Get.toNamed(Routes.personalInfoEdit),
                          icon: const Icon(Icons.edit_outlined, size: 16),
                          label: const Text('Edit Info'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFF3A3F5A)),
                            backgroundColor: const Color(0xFF252A45),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Profile Picture
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF3A3F5A),
                          width: 2,
                        ),
                      ),
                      child: Obx(() {
                        if (controller.profileImageUrl.isNotEmpty) {
                          return ClipOval(
                            child: Image.network(
                              controller.profileImageUrl.value, // ✅ full URL
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: const Color(0xFF2A2F4A),
                                child: const Icon(Icons.person, size: 50, color: Colors.grey),
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            color: const Color(0xFF2A2F4A),
                            child: const Icon(Icons.person, size: 50, color: Colors.grey),
                          );
                        }
                      }),
                    ),
                  ),
                    const SizedBox(height: 32),

                    // Text Fields
                    CustomTextField(label: 'Name', controller: controller.nameController),
                    const SizedBox(height: 20),
                    CustomTextField(
                        label: 'Email', controller: controller.emailController, keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 20),
                    CustomTextField(label: 'Date of Birth', controller: controller.dobController),
                    const SizedBox(height: 20),
                    CustomTextField(label: 'Time of Birth', controller: controller.timeController),
                    const SizedBox(height: 20),
                    CustomTextField(label: 'Birth Country', controller: controller.countryController),
                    const SizedBox(height: 20),
                    CustomTextField(label: 'Birth City', controller: controller.cityController),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// CustomTextField remains the same
class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            )),
        const SizedBox(height: 8),
        TextField(
          readOnly: true,
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF0F1329),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF2A2F4A)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF2A2F4A)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF3A3F5A)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}
