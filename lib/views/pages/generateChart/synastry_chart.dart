// synastry_chart.dart
import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_appBar.dart';
import 'package:astrology_app/views/base/custom_button.dart';
import 'package:astrology_app/views/base/custom_snackBar.dart';
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
                "Partner 1: Birth Information",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: CustomColors.secondbackgroundColor,
                  border: Border.all(color: const Color(0xFF2F3448)),
                ),
                child: Column(
                  children: [
                    _inputField("Name", "Enter your accurate name", controller: name1Controller),
                    const SizedBox(height: 15),
                    _inputField("Date of Birth", selectedDate1 == null ? "mm/dd/yyyy" : "${selectedDate1!.month}/${selectedDate1!.day}/${selectedDate1!.year}",
                        icon: Icons.calendar_today, onTap: () => pickDate(1)),
                    const SizedBox(height: 15),
                    _inputField("Birth City", "Enter accurate birth city name", controller: city1Controller),
                    const SizedBox(height: 15),
                    _inputField("Birth Country", "Enter accurate birth country name", controller: country1Controller),
                    const SizedBox(height: 15),
                    _inputField("Birth Time", selectedTime1 == null ? "Enter accurate birth time" : "${selectedTime1!.hour}:${selectedTime1!.minute.toString().padLeft(2, '0')}",
                        icon: Icons.access_time, onTap: () => pickTime(1)),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Partner 2: Birth Information",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 25),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: CustomColors.secondbackgroundColor,
                  border: Border.all(color: const Color(0xFF2F3448)),
                ),
                child: Column(
                  children: [
                    _inputField("Name", "Enter your accurate name", controller: name2Controller),
                    const SizedBox(height: 15),
                    _inputField("Date of Birth", selectedDate2 == null ? "mm/dd/yyyy" : "${selectedDate2!.month}/${selectedDate2!.day}/${selectedDate2!.year}",
                        icon: Icons.calendar_today, onTap: () => pickDate(2)),
                    const SizedBox(height: 15),
                    _inputField("Birth City", "Enter accurate birth city name", controller: city2Controller),
                    const SizedBox(height: 15),
                    _inputField("Birth Country", "Enter accurate birth country name", controller: country2Controller),
                    const SizedBox(height: 15),
                    _inputField("Birth Time", selectedTime2 == null ? "Enter accurate birth time" : "${selectedTime2!.hour}:${selectedTime2!.minute.toString().padLeft(2, '0')}",
                        icon: Icons.access_time, onTap: () => pickTime(2)),
                  ],
                ),
              ),

              const SizedBox(height: 60),

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

              const SizedBox(height: 20),
            ],
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
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 48,
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


