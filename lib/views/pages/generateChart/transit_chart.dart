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
  final TextEditingController locationController = TextEditingController();
  DateTime? birthDate;
  TimeOfDay? birthTime;

  // Transit dates
  DateTime? futureStartDate;
  DateTime? pastDate;

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
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.padding(20), vertical: ResponsiveHelper.padding(10)),
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

                // Top Birth Information Section
                Container(
                  padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(ResponsiveHelper.radius(16)),
                    color: CustomColors.secondbackgroundColor,
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Birth Information",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveHelper.fontSize(18),
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: ResponsiveHelper.space(20)),
                      Row(
                        children: [
                          Expanded(
                            child: _dateField(
                              title: "Future start date",
                              value: futureStartDate,
                              onTap: pickFutureStartDate,
                            ),
                          ),
                          SizedBox(width: ResponsiveHelper.space(12)),
                          Expanded(
                            child: _dateField(
                              title: "Past Date",
                              value: pastDate,
                              onTap: pickPastDate,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: ResponsiveHelper.space(25)),

                // Bottom Birth Information Section
                Container(
                  padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(ResponsiveHelper.radius(16)),
                    color: CustomColors.secondbackgroundColor,
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Birth Information",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveHelper.fontSize(18),
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: ResponsiveHelper.space(20)),
                      _inputField("Name", "Enter your name", controller: nameController),
                      SizedBox(height: ResponsiveHelper.space(15)),
                      _inputField("Date of Birth", birthDate == null ? "mm/dd/yyyy" : "${birthDate!.month.toString().padLeft(2, '0')}/${birthDate!.day.toString().padLeft(2, '0')}/${birthDate!.year}",
                          icon: Icons.calendar_month_outlined, onTap: pickBirthDate),
                      SizedBox(height: ResponsiveHelper.space(15)),
                      _inputField("Birth Time", birthTime == null ? "Enter accurate birth time" : "${birthTime!.hour}:${birthTime!.minute.toString().padLeft(2, '0')}",
                          onTap: pickBirthTime),
                      SizedBox(height: ResponsiveHelper.space(15)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Birth Location", style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14), fontWeight: FontWeight.w500)),
                          SizedBox(height: ResponsiveHelper.space(8)),
                          AutocompleteLocationField(
                            controller: locationController,
                            hintText: "Enter city, country",
                            getSuggestions: LocationService.searchGlobalLocations,
                            onSelected: (selection) {
                              if (selection.contains(',')) {
                                final parts = selection.split(',');
                                cityController.text = parts[0].trim();
                                countryController.text = parts[1].trim();
                              } else {
                                cityController.text = selection.trim();
                                countryController.text = "";
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: ResponsiveHelper.space(40)),
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
                        'futureStartDate': futureStartDate,
                        'pastDate': pastDate,
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
        futureStartDate == null ||
        pastDate == null) {
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
              borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
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
                        color: (hint.contains("mm/dd/yyyy") || hint.contains("Enter"))
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
                  Icon(icon, color: Colors.white.withOpacity(0.6), size: ResponsiveHelper.iconSize(24)),
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
        ? "mm/dd/yyyy"
        : "${value!.month.toString().padLeft(2, '0')}/${value!.day.toString().padLeft(2, '0')}/${value!.year}";

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
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.padding(14),
            ),
            decoration: BoxDecoration(
              color: CustomColors.secondbackgroundColor,
              borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: value == null ? Colors.grey : Colors.white,
                    fontSize: ResponsiveHelper.fontSize(16),
                  ),
                ),
                Icon(Icons.calendar_month_outlined, size: ResponsiveHelper.iconSize(24), color: Colors.white.withOpacity(0.6)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: birthDate ?? DateTime(2000),
      firstDate: DateTime(1),
      lastDate: DateTime(100000),
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

  Future<void> pickFutureStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: futureStartDate ?? DateTime.now(),
      firstDate: DateTime(1),
      lastDate: DateTime(100000),
    );
    if (picked != null) setState(() => futureStartDate = picked);
  }

  Future<void> pickPastDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: pastDate ?? DateTime.now(),
      firstDate: DateTime(1),
      lastDate: DateTime(100000),
    );
    if (picked != null) setState(() => pastDate = picked);
  }

  Widget _stepBar(bool filled) {
    return Expanded(
      child: Container(
        height: ResponsiveHelper.height(4),
        margin: EdgeInsets.only(right: ResponsiveHelper.space(6)),
        decoration: BoxDecoration(
          color: filled ? const Color(0xFF9726f2) : const Color(0xFF2F3448),
          borderRadius: BorderRadius.circular(ResponsiveHelper.radius(20)),
        ),
      ),
    );
  }
}
