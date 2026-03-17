// lib/views/pages/profile/accounts/personal_info.dart
import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/controllers/profile_controller/personal_info_controller.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/utils/responsive.dart';
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
          onTap:() => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios, color: Colors.white, size: ResponsiveHelper.iconSize(20)),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: const Color(0xFF9A3BFF),
                strokeWidth: ResponsiveHelper.width(4),
              ),
            );
          }

          if (controller.userInfo.value == null) {
            return Center(
              child: Text(
                "No user info available",
                style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14)),
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
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
                    // Header with Edit Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Personal Information',
                          style: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(16), fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => Get.toNamed(Routes.personalInfoEdit),
                          icon: Icon(Icons.edit_outlined, size: ResponsiveHelper.iconSize(16)),
                          label: Text('Edit Info', style: TextStyle(fontSize: ResponsiveHelper.fontSize(12))),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFF3A3F5A)),
                            backgroundColor: const Color(0xFF252A45),
                            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.padding(12), vertical: ResponsiveHelper.padding(8)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(ResponsiveHelper.radius(8)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveHelper.space(24)),

                    // Profile Picture
                    Center(
                      child: Container(
                        width: ResponsiveHelper.width(100),
                        height: ResponsiveHelper.height(100),
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
                                controller.profileImageUrl.value,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: const Color(0xFF2A2F4A),
                                  child: Icon(Icons.person, size: ResponsiveHelper.iconSize(50), color: Colors.grey),
                                ),
                              ),
                            );
                          } else {
                            return Icon(Icons.person, size: ResponsiveHelper.iconSize(50), color: Colors.grey);
                          }
                        }),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.space(32)),

                    // Text Fields
                    CustomTextField(label: 'Name', controller: controller.nameController),
                    SizedBox(height: ResponsiveHelper.space(20)),
                    CustomTextField(
                        label: 'Email', controller: controller.emailController, keyboardType: TextInputType.emailAddress),
                    SizedBox(height: ResponsiveHelper.space(20)),
                    CustomTextField(label: 'Date of Birth', controller: controller.dobController),
                    SizedBox(height: ResponsiveHelper.space(20)),
                    CustomTextField(label: 'Time of Birth', controller: controller.timeController),
                    SizedBox(height: ResponsiveHelper.space(20)),
                    CustomTextField(label: 'Birth Country', controller: controller.countryController),
                    SizedBox(height: ResponsiveHelper.space(20)),
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
            style: TextStyle(
              fontSize: ResponsiveHelper.fontSize(14),
              color: Colors.white,
              fontWeight: FontWeight.w400,
            )),
        SizedBox(height: ResponsiveHelper.space(8)),
        TextField(
          readOnly: true,
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(15)),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF0F1329),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.radius(8)),
              borderSide: const BorderSide(color: Color(0xFF2A2F4A)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.radius(8)),
              borderSide: const BorderSide(color: Color(0xFF2A2F4A)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.radius(8)),
              borderSide: const BorderSide(color: Color(0xFF3A3F5A)),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.padding(16), vertical: ResponsiveHelper.padding(14)),
          ),
        ),
      ],
    );
  }
}
