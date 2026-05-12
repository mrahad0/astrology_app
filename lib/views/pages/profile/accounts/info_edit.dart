// lib/views/pages/profile/accounts/info_edit.dart
import 'package:astrology_app/controllers/profile_controller/personal_info_edit_controller.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/utils/responsive.dart';
import 'package:astrology_app/views/base/custom_appBar.dart';
import 'package:astrology_app/views/base/autocomplete_location_field.dart';
import 'package:astrology_app/data/services/location_service.dart';
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
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/profile_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
        title: "Edit Personal Info",
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios, color: Colors.white, size: ResponsiveHelper.iconSize(20)),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: const Color(0xFF9A3BFF),
              strokeWidth: ResponsiveHelper.width(4),
            ),
          );
        }

        return SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(ResponsiveHelper.padding(10)),
            child: Container(
              padding: EdgeInsets.all(ResponsiveHelper.padding(15)),
              decoration: BoxDecoration(
                color: CustomColors.secondbackgroundColor,
                borderRadius: BorderRadius.circular(ResponsiveHelper.radius(16)),
                border: Border.all(color: const Color(0xFF2A2F4A)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ---------- HEADER ----------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Edit Personal Info',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(16),
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: controller.saveData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2A2F4A),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveHelper.padding(20), vertical: ResponsiveHelper.padding(10)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ResponsiveHelper.radius(8)),
                          ),
                          elevation: 0,
                        ),
                        child: Text('Save', style: TextStyle(fontSize: ResponsiveHelper.fontSize(14))),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveHelper.space(24)),

                  /// ---------- PROFILE IMAGE ----------
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: ResponsiveHelper.radius(50),
                          backgroundColor: const Color(0xFF3A3F5A),
                          backgroundImage: _buildProfileImage(),
                          child: _showPlaceholderIcon()
                              ? Icon(Icons.person,
                              size: ResponsiveHelper.iconSize(50), color: Colors.grey)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => controller.pickImage(context),
                            child: Container(
                              width: ResponsiveHelper.width(32),
                              height: ResponsiveHelper.height(32),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3A3F5A),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF1A1F3A),
                                  width: 2,
                                ),
                              ),
                              child: Icon(Icons.add,
                                  size: ResponsiveHelper.iconSize(18), color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.space(32)),

                  /// ---------- FORM ----------
                  CustomTextField(
                    label: "Name",
                    controller: controller.nameController,
                  ),
                  SizedBox(height: ResponsiveHelper.space(20)),
                  CustomTextField(
                    label: "Email",
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    enabled: false, // read-only
                  ),
                  SizedBox(height: ResponsiveHelper.space(20)),
                  CustomTextField(
                    label: "Date of Birth",
                    controller: controller.dobController,
                  ),
                  SizedBox(height: ResponsiveHelper.space(20)),
                  CustomTextField(
                    label: "Time of Birth",
                    controller: controller.timeController,
                  ),
                  SizedBox(height: ResponsiveHelper.space(20)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Birth Location", style: TextStyle(fontSize: ResponsiveHelper.fontSize(14), color: Colors.white)),
                      SizedBox(height: ResponsiveHelper.space(8)),
                      AutocompleteLocationField(
                        controller: controller.locationController,
                        hintText: "Enter city, country",
                        getSuggestions: LocationService.searchGlobalLocations,
                        onSelected: (selection) {
                          if (selection.contains(',')) {
                            final parts = selection.split(',');
                            controller.cityController.text = parts[0].trim();
                            controller.countryController.text = parts[1].trim();
                          } else {
                            controller.cityController.text = selection.trim();
                            controller.countryController.text = "";
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
     ),
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
            style: TextStyle(fontSize: ResponsiveHelper.fontSize(14), color: Colors.white)),
        SizedBox(height: ResponsiveHelper.space(8)),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          enabled: enabled,
          style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14)),
          decoration: InputDecoration(
            filled: true,
            fillColor: CustomColors.secondbackgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.radius(8)),
              borderSide: const BorderSide(color: Color(0xFF2F3448)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.radius(8)),
              borderSide: const BorderSide(color: Color(0xFF2F3448)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.radius(8)),
              borderSide: const BorderSide(color: Color(0xFF2F3448)),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.padding(16), vertical: ResponsiveHelper.padding(14)),
          ),
        ),
      ],
    );
  }
}
