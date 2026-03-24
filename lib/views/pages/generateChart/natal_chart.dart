// natal_chart.dart
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


class NatalChart extends StatefulWidget {
  final VoidCallback onNext;
  const NatalChart({super.key, required this.onNext});

  @override
  State<NatalChart> createState() => _NatalChart();
}

class _NatalChart extends State<NatalChart> {
  final ChartController controller = Get.find<ChartController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

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
                "Birth Information",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.fontSize(18),
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: ResponsiveHelper.space(20)),

              Container(
                padding: EdgeInsets.all(ResponsiveHelper.padding(20)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.radius(14)),
                  color: CustomColors.secondbackgroundColor,
                  border: Border.all(color: const Color(0xFF2F3448)),
                ),
                child: Column(
                  children: [
                    _inputField("Name", "Enter your accurate name", controller: nameController),
                    SizedBox(height: ResponsiveHelper.space(15)),
                    _inputField("Date of Birth", selectedDate == null ? "dd/mm/yyyy" : "${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}",
                        icon: Icons.calendar_today, onTap: pickDate),
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
                    SizedBox(height: ResponsiveHelper.space(15)),
                    _inputField("Birth Time", selectedTime == null ? "Enter accurate birth time" : "${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')}",
                        icon: Icons.access_time, onTap: pickTime),
                  ],
                ),
              ),

              SizedBox(height: ResponsiveHelper.space(60)),

              CustomButton(
                text: "Next",
                onpress: () {
                  if (_validateInputs()) {
                    controller.setChartData({
                      'type': 'Natal',
                      'name': nameController.text,
                      'dateOfBirth': selectedDate,
                      'birthCity': cityController.text,
                      'birthCountry': countryController.text,
                      'birthTime': selectedTime,
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
        selectedDate == null ||
        selectedTime == null) {
     showCustomSnackBar("All fields are required.");
      return false;
    }
    return true;
  }

  Future<void> pickDate() async {
    DateTime? d = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (d != null) {
      setState(() => selectedDate = d);
    }
  }

  Future<void> pickTime() async {
    TimeOfDay? t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 10, minute: 00),
    );

    if (t != null) {
      setState(() => selectedTime = t);
    }
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
              color: const Color(0xFF111424),
              borderRadius: BorderRadius.circular(ResponsiveHelper.radius(10)),
              border: Border.all(color: const Color(0xFF2F3448)),
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
