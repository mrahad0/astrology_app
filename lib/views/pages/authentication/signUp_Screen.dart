import 'package:astrology_app/controllers/auth_controller/register_controller.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_button.dart';
import 'package:astrology_app/views/base/custom_textField.dart';
import 'package:astrology_app/views/base/custom_password_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final RegisterController _registerController = Get.put(RegisterController());

  bool isChecked = false;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  // Text Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();

  // Validation error variables
  String? nameError,
      emailError,
      passError,
      rePassError,
      countryError,
      cityError,
      dobError,
      tobError,
      agreeError;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    countryController.dispose();
    cityController.dispose();
    super.dispose();
  }

  // ------------------ VALIDATION --------------------
  bool _validate() {
    setState(() {
      nameError = nameController.text.isEmpty ? "Name is required" : null;
      emailError = emailController.text.isEmpty ? "Email is required" : null;
      passError = passwordController.text.isEmpty ? "Password is required" : null;
      rePassError = rePasswordController.text != passwordController.text
          ? "Password doesn't match"
          : null;

      countryError =
      countryController.text.isEmpty ? "Country is required" : null;
      cityError = cityController.text.isEmpty ? "City is required" : null;

      dobError = selectedDate == null ? "Select date of birth" : null;
      tobError = selectedTime == null ? "Select time of birth" : null;

      agreeError = !isChecked ? "You must agree to continue" : null;
    });

    return nameError == null &&
        emailError == null &&
        passError == null &&
        rePassError == null &&
        countryError == null &&
        cityError == null &&
        dobError == null &&
        tobError == null &&
        agreeError == null;
  }

  // ------------------ SUBMIT --------------------
  void _submit() {
    if (!_validate()) {
      print("Validation failed");
      return;
    }

    if (_registerController.isLoading.value) return;

    final dob = selectedDate != null ? _formatDate(selectedDate!) : "";
    final tob = selectedTime != null ? _formatTime(selectedTime!) : "";

    _registerController.register(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
      confirmPassword: rePasswordController.text,
      dob: dob,
      tob: tob,
      country: countryController.text,
      city: cityController.text,
      agree: isChecked,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Row(
                  children: [
                    Icon(Icons.arrow_back_ios, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      "Create a new account",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              _label("Name"),
              CustomTextFromField(
                controller: nameController,
                hintText: "Enter your name",
              ),
              _error(nameError),

              _label("Email"),
              CustomTextFromField(
                controller: emailController,
                hintText: "Enter your email",
              ),
              _error(emailError),

              _label("Password"),
              CustomPasswordField(
                controller: passwordController,
                hintText: "Enter your password",
              ),
              _error(passError),

              _label("Re-password"),
              CustomPasswordField(
                controller: rePasswordController,
                hintText: "Re-enter your password",
              ),
              _error(rePassError),

              _label("Date of Birth"),
              _pickerField(
                value: selectedDate == null ? "" : _formatDate(selectedDate!),
                hint: "Choose date",
                onTap: _pickDate,
                icon: Icons.calendar_today,
              ),
              _error(dobError),

              _label("Time of Birth"),
              _pickerField(
                value:
                selectedTime == null ? "" : _formatTime(selectedTime!),
                hint: "Choose time",
                onTap: _pickTime,
                icon: Icons.access_time,
              ),
              _error(tobError),

              _label("Birth Country"),
              CustomTextFromField(
                controller: countryController,
                hintText: "Enter country",
              ),
              _error(countryError),

              _label("Birth City"),
              CustomTextFromField(
                controller: cityController,
                hintText: "Enter city",
              ),
              _error(cityError),

              Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (v) => setState(() => isChecked = v!),
                    side: BorderSide(color: Colors.white),
                  ),
                  Expanded(
                    child: Text(
                      "I agree with privacy & policy.",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
              _error(agreeError),

              SizedBox(height: 10),

              Obx(() => CustomButton(
                  text: "Create Account",
                  isLoading: _registerController.isLoading.value,
                  onpress: _submit)
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -------------- Helper UI -------------
  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 6),
    child: Text(
      text,
      style: TextStyle(color: Colors.white70, fontSize: 14),
    ),
  );

  Widget _error(String? text) => text == null
      ? SizedBox.shrink()
      : Padding(
    padding: const EdgeInsets.only(top: 4),
    child: Text(
      text,
      style: TextStyle(color: Colors.redAccent, fontSize: 12),
    ),
  );

  Widget _pickerField({
    required String value,
    required String hint,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white30),
          color: CustomColors.secondbackgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value.isEmpty ? hint : value,
                style:
                TextStyle(color: value.isEmpty ? Colors.grey : Colors.white),
              ),
            ),
            if (icon != null) Icon(icon, color: Colors.white54),
          ],
        ),
      ),
    );
  }

  // ---------------- DATE PICKER -----------------
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) =>
          Theme(data: ThemeData.dark(), child: child!),
    );

    if (picked != null) setState(() => selectedDate = picked);
  }

  // ---------------- TIME PICKER -----------------
  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) =>
          Theme(data: ThemeData.dark(), child: child!),
    );

    if (picked != null) setState(() => selectedTime = picked);
  }

  String _formatDate(DateTime date) =>
      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

  String _formatTime(TimeOfDay t) =>
      "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:00";
}

