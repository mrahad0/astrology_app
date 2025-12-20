// natal_chart.dart
import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_appBar.dart';
import 'package:astrology_app/views/base/custom_button.dart';
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
    return Scaffold(
      appBar: CustomAppBar(
        title: "Generate Chart",
        leading: IconButton(
          onPressed: () => Get.back(),
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
                "Birth Information",
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
                    _inputField("Name", "enter your accurate name", controller: nameController),
                    const SizedBox(height: 15),
                    _inputField("Date of Birth", selectedDate == null ? "mm/dd/yyyy" : "${selectedDate!.month}/${selectedDate!.day}/${selectedDate!.year}",
                        icon: Icons.calendar_today, onTap: pickDate),
                    const SizedBox(height: 15),
                    _inputField("Birth City", "Enter accurate birth city name", controller: cityController),
                    const SizedBox(height: 15),
                    _inputField("Birth Country", "Enter accurate birth country name", controller: countryController),
                    const SizedBox(height: 15),
                    _inputField("Birth Time", selectedTime == null ? "Enter accurate birth time" : "${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')}",
                        icon: Icons.access_time, onTap: pickTime),
                  ],
                ),
              ),

              const SizedBox(height: 60),

              CustomButton(
                text: "Next",
                onpress: () {
                  controller.setChartData({
                    'type': 'Natal',
                    'name': nameController.text,
                    'dateOfBirth': selectedDate,
                    'birthCity': cityController.text,
                    'birthCountry': countryController.text,
                    'birthTime': selectedTime,
                  });
                  Get.toNamed(Routes.chartType);
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
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
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),

        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF111424),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF2F3448)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    enabled: onTap == null,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: InputBorder.none,
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



