import 'package:astrology_app/controllers/profile_controller/personal_info_edit_controller.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonalInfoEdit extends StatefulWidget {
  const PersonalInfoEdit({Key? key}) : super(key: key);

  @override
  State<PersonalInfoEdit> createState() => _PersonalInfoEditState();
}

class _PersonalInfoEditState extends State<PersonalInfoEdit> {
  final PersonalInfoEditController controller =
  Get.put(PersonalInfoEditController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Edit Personal Info",
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SafeArea(
          child: SingleChildScrollView(
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
                  /// ---------- HEADER ----------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Edit Personal Info',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: controller.saveData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2A2F4A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  /// ---------- PROFILE IMAGE ----------
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: const Color(0xFF3A3F5A),
                          backgroundImage: _buildProfileImage(),
                          child: _showPlaceholderIcon()
                              ? const Icon(Icons.person,
                              size: 50, color: Colors.grey)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => controller.pickImage(context),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFF3A3F5A),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF1A1F3A),
                                  width: 2,
                                ),
                              ),
                              child: const Icon(Icons.add,
                                  size: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  /// ---------- FORM ----------
                  CustomTextField(
                    label: "Name",
                    controller: controller.nameController,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: "Email",
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    enabled: false, // read-only
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: "Date of Birth",
                    controller: controller.dobController,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: "Time of Birth",
                    controller: controller.timeController,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: "Birth Country",
                    controller: controller.countryController,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: "Birth City",
                    controller: controller.cityController,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  /// ---------- IMAGE HELPERS ----------
  ImageProvider? _buildProfileImage() {
    if (controller.profileImage != null) {
      return FileImage(controller.profileImage!);
    }
    if (controller.profileImageUrl.isNotEmpty) {
      return NetworkImage(controller.profileImageUrl.value);
    }
    return null;
  }

  bool _showPlaceholderIcon() {
    return controller.profileImage == null &&
        controller.profileImageUrl.isEmpty;
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool enabled;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 14, color: Colors.white)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          enabled: enabled,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF0F1329),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}



