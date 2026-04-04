// synastry_chart.dart
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


class SynastryChart extends StatefulWidget {
  final VoidCallback onNext;
  const SynastryChart({super.key, required this.onNext});

  @override
  State<SynastryChart> createState() => _SynastryChart();
}

class _SynastryChart extends State<SynastryChart> {
  final ChartController controller = Get.find<ChartController>();

  final TextEditingController name1Controller = TextEditingController();
  final TextEditingController city1Controller = TextEditingController();
  final TextEditingController country1Controller = TextEditingController();
  DateTime? selectedDate1;
  TimeOfDay? selectedTime1;

  final TextEditingController name2Controller = TextEditingController();
  final TextEditingController city2Controller = TextEditingController();
  final TextEditingController country2Controller = TextEditingController();
  DateTime? selectedDate2;
  TimeOfDay? selectedTime2;

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
                "Partner 1: Birth Information",
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
                    _inputField("Name", "Enter your accurate name", controller: name1Controller),
                    SizedBox(height: ResponsiveHelper.space(15)),
                    _inputField("Date of Birth", selectedDate1 == null ? "dd/mm/yyyy" : "${selectedDate1!.day.toString().padLeft(2, '0')}/${selectedDate1!.month.toString().padLeft(2, '0')}/${selectedDate1!.year}",
                        icon: Icons.calendar_today, onTap: () => pickDate(1)),
                    SizedBox(height: ResponsiveHelper.space(15)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Birth Country", style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14), fontWeight: FontWeight.w500)),
                        SizedBox(height: ResponsiveHelper.space(8)),
                        AutocompleteLocationField(
                          controller: country1Controller,
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
                          controller: city1Controller,
                          hintText: "Enter accurate birth city name",
                          getSuggestions: (q) => LocationService.searchCities(country1Controller.text, q),
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveHelper.space(15)),
                    _inputField("Birth Time", selectedTime1 == null ? "Enter accurate birth time" : "${selectedTime1!.hour}:${selectedTime1!.minute.toString().padLeft(2, '0')}",
                        icon: Icons.access_time, onTap: () => pickTime(1)),
                  ],
                ),
              ),

              SizedBox(height: ResponsiveHelper.space(25)),

              Text(
                "Partner 2: Birth Information",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.fontSize(18),
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: ResponsiveHelper.space(25)),

              Container(
                padding: EdgeInsets.all(ResponsiveHelper.padding(20)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.radius(14)),
                  color: CustomColors.secondbackgroundColor,
                  border: Border.all(color: const Color(0xFF2F3448)),
                ),
                child: Column(
                  children: [
                    _inputField("Name", "Enter your accurate name", controller: name2Controller),
                    SizedBox(height: ResponsiveHelper.space(15)),
                    _inputField("Date of Birth", selectedDate2 == null ? "dd/mm/yyyy" : "${selectedDate2!.day.toString().padLeft(2, '0')}/${selectedDate2!.month.toString().padLeft(2, '0')}/${selectedDate2!.year}",
                        icon: Icons.calendar_today, onTap: () => pickDate(2)),
                    SizedBox(height: ResponsiveHelper.space(15)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Birth Country", style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14), fontWeight: FontWeight.w500)),
                        SizedBox(height: ResponsiveHelper.space(8)),
                        AutocompleteLocationField(
                          controller: country2Controller,
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
                          controller: city2Controller,
                          hintText: "Enter accurate birth city name",
                          getSuggestions: (q) => LocationService.searchCities(country2Controller.text, q),
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveHelper.space(15)),
                    _inputField("Birth Time", selectedTime2 == null ? "Enter accurate birth time" : "${selectedTime2!.hour}:${selectedTime2!.minute.toString().padLeft(2, '0')}",
                        icon: Icons.access_time, onTap: () => pickTime(2)),
                  ],
                ),
              ),

              SizedBox(height: ResponsiveHelper.space(60)),

              CustomButton(
                text: "Next",
                onpress: () {
                  if (_validateInputs()) {
                    controller.setChartData({
                      'type': 'Synastry',
                      'partner1': {
                        'name': name1Controller.text,
                        'dateOfBirth': selectedDate1,
                        'birthCity': city1Controller.text,
                        'birthCountry': country1Controller.text,
                        'birthTime': selectedTime1,
                      },
                      'partner2': {
                        'name': name2Controller.text,
                        'dateOfBirth': selectedDate2,
                        'birthCity': city2Controller.text,
                        'birthCountry': country2Controller.text,
                        'birthTime': selectedTime2,
                      },
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
    if (name1Controller.text.isEmpty ||
        city1Controller.text.isEmpty ||
        country1Controller.text.isEmpty ||
        selectedDate1 == null ||
        selectedTime1 == null ||
        name2Controller.text.isEmpty ||
        city2Controller.text.isEmpty ||
        country2Controller.text.isEmpty ||
        selectedDate2 == null ||
        selectedTime2 == null) {
      showCustomSnackBar("All fields are required.");
      return false;
    }
    return true;
  }

  Future<void> pickDate(int partner) async {
    DateTime? d = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (d != null) {
      setState(() {
        if (partner == 1) {
          selectedDate1 = d;
        } else {
          selectedDate2 = d;
        }
      });
    }
  }

  Future<void> pickTime(int partner) async {
    TimeOfDay? t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 10, minute: 00),
    );

    if (t != null) {
      setState(() {
        if (partner == 1) {
          selectedTime1 = t;
        } else {
          selectedTime2 = t;
        }
      });
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
