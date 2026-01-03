import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddAstroDataScreen extends StatefulWidget {
  const AddAstroDataScreen({super.key});

  @override
  State<AddAstroDataScreen> createState() => _AddAstroDataScreenState();
}

class _AddAstroDataScreenState extends State<AddAstroDataScreen> {
  final TextEditingController firstNameController = TextEditingController(text: 'Mosud');
  final TextEditingController lastNameController = TextEditingController(text: 'Bitkel');
  final TextEditingController timeController = TextEditingController(text: '12:00 pm');
  final TextEditingController dateController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController countryController = TextEditingController(text: 'Singapore');
  final TextEditingController cityController = TextEditingController(text: 'Kampong Glam');

  String selectedGender = 'Select Your Gender';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Add Astro Data",
        leading: GestureDetector(
            onTap: () => Navigator.pop(context), child: Icon(Icons.arrow_back_ios, color: Colors.white,)),),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ---- BIRTH DATA ENTRY CARD ----
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xff262A40)),
                    borderRadius: BorderRadius.circular(14),
                    color: CustomColors.secondbackgroundColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Birth Data Entry",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 24),

                      /// First Name
                      const Text(
                        "First Name",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      _buildTextField(firstNameController),
                      const SizedBox(height: 20),

                      /// Last Name
                      const Text(
                        "Last Name",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      _buildTextField(lastNameController),
                      const SizedBox(height: 20),

                      /// Gender
                      const Text(
                        "Gender",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      _buildDropdown(
                        value: selectedGender,
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      /// Birthday
                      const Text(
                        "Birthday",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDateTextField(
                              controller: dateController,
                              hint: "Date",
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildDateTextField(
                              controller: monthController,
                              hint: "Month",
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildDateTextField(
                              controller: yearController,
                              hint: "Year",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      /// Time of Birth
                      const Text(
                        "Time of Birth",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      _buildTimeField(timeController),
                      const SizedBox(height: 20),

                      /// Birth Country
                      const Text(
                        "Birth Country",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      _buildTextField(countryController),
                      const SizedBox(height: 20),

                      /// Birth City
                      const Text(
                        "Birth City",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      _buildTextField(cityController),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// ---- SAVE BUTTON ----
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Astro Data saved!'),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Generate',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ----------------------------
  /// TEXT FIELD WIDGET
  /// ----------------------------
  Widget _buildTextField(TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xff0F1329),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xff262A40)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xff262A40)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xff3A3F5A)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  /// ----------------------------
  /// DROPDOWN WIDGET
  /// ----------------------------
  Widget _buildDropdown({
    required String value,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xff0F1329),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xff262A40)),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        dropdownColor: const Color(0xff141827),
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
        style: const TextStyle(color: Colors.white, fontSize: 15),
        items: [value].map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  /// ----------------------------
  /// DATE BUTTON WIDGET
  /// ----------------------------
  Widget _buildDateButton(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xff0F1329),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xff262A40)),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  /// ----------------------------
  /// DATE TEXT FIELD WIDGET
  /// ----------------------------
  Widget _buildDateTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white60),
        filled: true,
        fillColor: const Color(0xff0F1329),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xff262A40)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xff262A40)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xff3A3F5A)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      ),
    );
  }

  /// ----------------------------
  /// TIME FIELD WIDGET
  /// ----------------------------
  Widget _buildTimeField(TextEditingController controller) {
    return TextField(
      controller: controller,
      readOnly: true,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xff0F1329),
        suffixIcon: const Icon(Icons.access_time, color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xff262A40)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xff262A40)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xff3A3F5A)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: Color(0xFF7C3AED),
                  surface: Color(0xff141827),
                  onSurface: Colors.white,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          setState(() {
            controller.text = picked.format(context);
          });
        }
      },
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    timeController.dispose();
    dateController.dispose();
    monthController.dispose();
    yearController.dispose();
    countryController.dispose();
    cityController.dispose();
    super.dispose();
  }
}
