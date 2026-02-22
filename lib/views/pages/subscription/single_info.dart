import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_appBar.dart';
import 'package:astrology_app/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SingleInfo extends StatefulWidget {
  const SingleInfo({super.key});

  @override
  State<SingleInfo> createState() => _SingleInfo();
}

class _SingleInfo extends State<SingleInfo> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Single Info",
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            /// ---- SCROLLABLE FORM ----
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: CustomColors.secondbackgroundColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF262A40).withOpacity(0.5),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Title
                            const Text(
                              "Birth Information",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 24),

                            /// Name
                            const Text(
                              "Name",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: nameController,
                              hint: "Enter accurate your name",
                            ),
                            const SizedBox(height: 20),

                            /// Date of Birth
                            const Text(
                              "Date of Birth",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildDateField(
                              controller: dateController,
                              hint: "mm/dd/yyyy",
                            ),
                            const SizedBox(height: 20),

                            /// Birth City
                            const Text(
                              "Birth City",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: cityController,
                              hint: "Enter accurate birth city name",
                            ),
                            const SizedBox(height: 20),

                            /// Birth Country
                            const Text(
                              "Birth Country",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: countryController,
                              hint: "Enter accurate birth country",
                            ),
                            const SizedBox(height: 20),

                            /// Birth Time
                            const Text(
                              "Birth Time",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: timeController,
                              hint: "Enter accurate birth time",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      CustomButton(
                        text: "Generate",
                        onpress: () {
                          Get.toNamed(Routes.singleReport);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// ---- GENERATE BUTTON ----
          ],
        ),
      ),
    );
  }

  /// ----------------------------
  /// TEXT FIELD WIDGET
  /// ----------------------------
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
        filled: true,
        fillColor: const Color(0xFF0F1329).withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF262A40)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF262A40)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF3A3F5A)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  /// ----------------------------
  /// DATE FIELD WIDGET
  /// ----------------------------
  Widget _buildDateField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      readOnly: true,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
        filled: true,
        fillColor: const Color(0xFF0F1329).withOpacity(0.5),
        suffixIcon: const Icon(
          Icons.calendar_today,
          color: Colors.white60,
          size: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF262A40)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF262A40)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF3A3F5A)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: Color(0xFF7C3AED),
                  surface: Color(0xFF141827),
                  onSurface: Colors.white,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          setState(() {
            controller.text =
                "${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}";
          });
        }
      },
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    dateController.dispose();
    cityController.dispose();
    countryController.dispose();
    timeController.dispose();
    super.dispose();
  }
}
