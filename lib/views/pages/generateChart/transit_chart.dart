// lib/views/pages/generateChart/transit_chart.dart
import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_appBar.dart';
import 'package:astrology_app/views/base/custom_button.dart';
import 'package:astrology_app/views/base/custom_snackBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/chart_controller/chart_controller.dart';

class TransitChart extends StatefulWidget {
  final VoidCallback onNext;
  const TransitChart({super.key, required this.onNext});

  @override
  State<TransitChart> createState() => _TransitChartState();
}

class _TransitChartState extends State<TransitChart> {
  final ChartController controller = Get.find<ChartController>();

  // Transit needs natal birth info
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  DateTime? birthDate;
  TimeOfDay? birthTime;

  // Plus transit date
  DateTime? futureDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Generate Chart",
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _stepBar(true),
                  _stepBar(true),
                  _stepBar(false),
                  _stepBar(false),
                ],
              ),
              const SizedBox(height: 25),

              const Text(
                "Birth Information (For Natal Chart)",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),

              // Birth Info Container
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: CustomColors.secondbackgroundColor,
                  border: Border.all(color: const Color(0xFF2F3448)),
                ),
                child: Column(
                  children: [
                    _inputField("Name", "enter your name", controller: nameController),
                    const SizedBox(height: 15),
                    _inputField("Date of Birth", birthDate == null ? "mm/dd/yyyy" : "${birthDate!.month}/${birthDate!.day}/${birthDate!.year}",
                        icon: Icons.calendar_today, onTap: pickBirthDate),
                    const SizedBox(height: 15),
                    _inputField("Birth Time", birthTime == null ? "enter birth time" : "${birthTime!.hour}:${birthTime!.minute.toString().padLeft(2, '0')}",
                        icon: Icons.access_time, onTap: pickBirthTime),
                    const SizedBox(height: 15),
                    _inputField("Birth City", "Enter city", controller: cityController),
                    const SizedBox(height: 15),
                    _inputField("Birth Country", "Enter country", controller: countryController),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Transit Date",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),

              // Transit Date Container
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: CustomColors.secondbackgroundColor,
                  border: Border.all(color: const Color(0xFF2F3448)),
                ),
                child: _dateField(
                  title: "Transit Date",
                  value: futureDate,
                  onTap: pickTransitDate,
                ),
              ),

              const SizedBox(height: 60),
              CustomButton(
                text: "Next",
                onpress: () {
                  if (_validateInputs()) {
                    controller.setChartData({
                      'type': 'Transit',
                      'name': nameController.text,
                      'dateOfBirth': birthDate,
                      'birthTime': birthTime,
                      'birthCity': cityController.text,
                      'birthCountry': countryController.text,
                      'futureDate': futureDate,
                    });
                    Get.toNamed(Routes.chartType);
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateInputs() {
    if (nameController.text.isEmpty ||
        cityController.text.isEmpty ||
        countryController.text.isEmpty ||
        birthDate == null ||
        birthTime == null ||
        futureDate == null) {
      showCustomSnackBar("All fields are required.");
      return false;
    }
    return true;
  }

  Widget _inputField(String title, String hint,
      {IconData? icon, Function()? onTap, TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 48, // ✅ fixed height দিয়ে দিন সব field এর জন্য
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF111424),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF2F3448)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: onTap != null // যদি onTap থাকে (date/time field)
                      ? Align(
                    alignment: Alignment.centerLeft, // ✅ text কে vertically center করবে
                    child: Text(
                      hint,
                      style: TextStyle(
                        color: hint.contains("mm/dd/yyyy") || hint.contains("Enter accurate")
                            ? Colors.grey  // placeholder text grey
                            : Colors.white, // selected value white
                        fontSize: 16,
                      ),
                    ),
                  )
                      : TextField( // normal text field
                    controller: controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero, // ✅ extra padding remove
                    ),
                  ),
                ),
                if (icon != null)
                  Icon(icon, color: Colors.grey, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _dateField({
    required String title,
    DateTime? value,
    Function()? onTap,
  }) {
    final String text = value == null
        ? ""
        : "${value.day}/${value.month}/${value.year}";

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF111424),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF2F3448)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    text.isEmpty ? "dd/mm/yyyy" : text,
                    style: TextStyle(
                      color: text.isEmpty ? Colors.grey : Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: birthDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => birthDate = picked);
  }

  Future<void> pickBirthTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: birthTime ?? TimeOfDay(hour: 10, minute: 0),
    );
    if (picked != null) setState(() => birthTime = picked);
  }

  Future<void> pickTransitDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: futureDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => futureDate = picked);
  }

  Widget _stepBar(bool filled) {
    return Expanded(
      child: Container(
        height: 4,
        margin: const EdgeInsets.only(right: 6),
        decoration: BoxDecoration(
          color: filled ? Colors.purple : const Color(0xFF2F3448),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

