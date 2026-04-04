// lib/views/pages/generateChart/transit_chart.dart
import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/utils/responsive.dart';
import 'package:astrology_app/views/base/custom_appBar.dart';
import 'package:astrology_app/views/base/custom_button.dart';
import 'package:astrology_app/views/base/custom_snackBar.dart';
import 'package:astrology_app/views/base/autocomplete_location_field.dart';
import 'package:astrology_app/data/services/location_service.dart';
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
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/generateChart_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          title: "Generate Chart",
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: ResponsiveHelper.iconSize(24)),
          ),
        ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(ResponsiveHelper.padding(20)),
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
              SizedBox(height: ResponsiveHelper.space(25)),

              Text(
                "Birth Information (For Natal Chart)",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.fontSize(18),
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: ResponsiveHelper.space(20)),

              // Birth Info Container
              Container(
                padding: EdgeInsets.all(ResponsiveHelper.padding(20)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.radius(14)),
                  color: CustomColors.secondbackgroundColor,
                  border: Border.all(color: const Color(0xFF2F3448)),
                ),
                child: Column(
                  children: [
                    _inputField("Name", "enter your name", controller: nameController),
                    SizedBox(height: ResponsiveHelper.space(15)),
                    _inputField("Date of Birth", birthDate == null ? "dd/mm/yyyy" : "${birthDate!.day.toString().padLeft(2, '0')}/${birthDate!.month.toString().padLeft(2, '0')}/${birthDate!.year}",
                        icon: Icons.calendar_today, onTap: pickBirthDate),
                    SizedBox(height: ResponsiveHelper.space(15)),
                    _inputField("Birth Time", birthTime == null ? "enter birth time" : "${birthTime!.hour}:${birthTime!.minute.toString().padLeft(2, '0')}",
                        icon: Icons.access_time, onTap: pickBirthTime),
                    SizedBox(height: ResponsiveHelper.space(15)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Birth Country", style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14), fontWeight: FontWeight.w500)),
                        SizedBox(height: ResponsiveHelper.space(8)),
                        AutocompleteLocationField(
                          controller: countryController,
                          hintText: "Enter accurate birth country name",
                          getSuggestions: LocationService.searchCountries,
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveHelper.space(15)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Birth City", style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14), fontWeight: FontWeight.w500)),
                        SizedBox(height: ResponsiveHelper.space(8)),
                        AutocompleteLocationField(
                          controller: cityController,
                          hintText: "Enter accurate birth city name",
                          getSuggestions: (q) => LocationService.searchCities(countryController.text, q),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: ResponsiveHelper.space(25)),

              Text(
                "Transit Date",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.fontSize(18),
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: ResponsiveHelper.space(20)),

              // Transit Date Container
              Container(
                padding: EdgeInsets.all(ResponsiveHelper.padding(20)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.radius(14)),
                  color: CustomColors.secondbackgroundColor,
                  border: Border.all(color: const Color(0xFF2F3448)),
                ),
                child: _dateField(
                  title: "Transit Date",
                  value: futureDate,
                  onTap: pickTransitDate,
                ),
              ),

              SizedBox(height: ResponsiveHelper.space(60)),
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
              SizedBox(height: ResponsiveHelper.space(20)),
            ],
          ),
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
          style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14), fontWeight: FontWeight.w500),
        ),
        SizedBox(height: ResponsiveHelper.space(8)),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: ResponsiveHelper.height(55),
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.padding(14)),
            decoration: BoxDecoration(
              color: CustomColors.secondbackgroundColor,
              borderRadius: BorderRadius.circular(ResponsiveHelper.radius(10)),
              border: Border.all(color: Colors.white38),
            ),
            child: Row(
              children: [
                Expanded(
                  child: onTap != null
                      ? Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      hint,
                      style: TextStyle(
                        color: hint.contains("dd/mm/yyyy") || hint.contains("Enter accurate")
                            ? Colors.grey
                            : Colors.white,
                        fontSize: ResponsiveHelper.fontSize(16),
                      ),
                    ),
                  )
                      : TextField(
                    controller: controller,
                    style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(16)),
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: TextStyle(color: Colors.grey, fontSize: ResponsiveHelper.fontSize(16)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                if (icon != null)
                  Icon(icon, color: Colors.grey, size: ResponsiveHelper.iconSize(20)),
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
        : "${value!.day.toString().padLeft(2, '0')}/${value!.month.toString().padLeft(2, '0')}/${value!.year}";

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.padding(14),
          vertical: ResponsiveHelper.padding(14),
        ),
        decoration: BoxDecoration(
          color: CustomColors.secondbackgroundColor,
          borderRadius: BorderRadius.circular(ResponsiveHelper.radius(10)),
          border: Border.all(color: Colors.white38),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14)),
            ),
            SizedBox(height: ResponsiveHelper.space(6)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    text.isEmpty ? "dd/mm/yyyy" : text,
                    style: TextStyle(
                      color: text.isEmpty ? Colors.grey : Colors.white,
                      fontSize: ResponsiveHelper.fontSize(16),
                    ),
                  ),
                ),
                Icon(Icons.calendar_today, size: ResponsiveHelper.iconSize(18), color: Colors.grey),
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
        height: ResponsiveHelper.height(4),
        margin: EdgeInsets.only(right: ResponsiveHelper.space(6)),
        decoration: BoxDecoration(
          color: filled ? Colors.purple : const Color(0xFF2F3448),
          borderRadius: BorderRadius.circular(ResponsiveHelper.radius(20)),
        ),
      ),
    );
  }
}
