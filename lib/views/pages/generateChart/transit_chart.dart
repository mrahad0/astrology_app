import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_appBar.dart';
import 'package:astrology_app/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransitChart extends StatefulWidget {
  final VoidCallback onNext;
  const TransitChart({super.key, required this.onNext});

  @override
  State<TransitChart> createState() => _TransitChartState();
}

class _TransitChartState extends State<TransitChart> {
  DateTime? futureDate;
  DateTime? pastDate;

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
              // ---------------- Step Bar ----------------
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
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),

              // ---------------- Container with 2 Date Fields ----------------
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: CustomColors.secondbackgroundColor,
                  border: Border.all(color: const Color(0xFF2F3448)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _dateField(
                        title: "Future Date",
                        value: futureDate,
                        onTap: pickStartDate,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _dateField(
                        title: "Past Date",
                        value: pastDate,
                        onTap: pickEndDate,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 60),
              CustomButton(
                text: "Next",
                onpress: () => Get.toNamed(Routes.chartType),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- Date Field Widget ----------------
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

  // ---------------- Date Pickers ----------------
  Future<void> pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: futureDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => futureDate = picked);
  }

  Future<void> pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: pastDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => pastDate = picked);
  }

  // ---------------- Step Bar ----------------
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
