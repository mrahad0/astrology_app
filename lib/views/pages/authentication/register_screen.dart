import 'package:astrology_app/controllers/auth_controller/register_controller.dart';
import 'package:astrology_app/views/base/custom_button.dart';
import 'package:astrology_app/views/base/custom_textField.dart';
import 'package:astrology_app/views/base/custom_password_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final RegisterController _registerController = Get.put(RegisterController());
  bool isChecked = false;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final timeOfBirthController = TextEditingController();
  final dobController = TextEditingController();


  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    countryController.dispose();
    cityController.dispose();
    super.dispose();
  }



  // ------------------ SUBMIT --------------------
  void _submit() {

    if(_formKey.currentState!.validate()&&isChecked==true){
      _registerController.register(
          {
            "name": nameController.text,
            "email": emailController.text.trim(),
            "i_agree": isChecked,
            "password":  passwordController.text,
            "confirm_password":  rePasswordController.text,
            "profile": {
              "date_of_birth":dobController.text ,
              "time_of_birth": timeOfBirthController.text,
              "birth_country": countryController.text.trim(),
              "birth_city": cityController.text.trim(),
            }
          }
      );
    }

  }

  final GlobalKey<FormState> _formKey= GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap:() => Navigator.pop(context),
                  child: Row(
                    children: [
                      Icon(Icons.arrow_back_ios, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        "Create a new account",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                _label("Name"),
                CustomTextFromField(
                  controller: nameController,
                  hintText: "Enter your name",
                  validator: (value){
                    if(value!.isEmpty){
                      return "Name is required";
                    }
                    return null;
                  },

                ),


                _label("Email"),
                CustomTextFromField(
                  controller: emailController,
                  hintText: "Enter your email",
                  validator: (value){
                    if(value!.isEmpty){
                      return "Email is required";
                    }
                    return null;
                  },
                ),


                _label("Password"),
                CustomPasswordField(
                  controller: passwordController,
                  hintText: "Enter your password",
                  validator: (value){
                    if(value!.isEmpty){
                      return "Password is required";
                    }
                    return null;
                  },
                ),


                _label("Re-password"),
                CustomPasswordField(
                  controller: rePasswordController,
                  hintText: "Re-enter your password",
                  validator: (value){
                    if(value!.isEmpty){
                      return "Password is required";
                    }else if(value != passwordController.text){
                      return "Password doesn't match";
                    }
                    return null;
                  }
                ),

                _label("Date of Birth"),
                CustomTextFromField(
                    hintText: "Choose date",
                    onTap: _pickDate,
                    readOnly: true,
                    controller: dobController,
                    suffixIcon: Icon(Icons.calendar_month,color:Colors.white70,),
                    validator: (value){
                      if(value!.isEmpty){
                        return "Date is required";
                      }
                      return null;
                    }

                ),

                _label("Time of Birth"),
                CustomTextFromField(
                  hintText: "Choose time",
                  onTap: _pickTime,
                  readOnly: true,
                  controller: timeOfBirthController,
                    suffixIcon: Icon(Icons.access_time,color:Colors.white70,),
                  validator: (value){
                    if(value!.isEmpty){
                      return "Time is required";
                    }
                    return null;
                  }

                ),

                _label("Birth Country"),
                CustomTextFromField(
                  controller: countryController,
                  hintText: "Enter country",
                  validator: (value){
                    if(value!.isEmpty){
                      return "Country is required";
                    }
                    return null;
                  },
                ),


                _label("Birth City"),
                CustomTextFromField(
                  controller: cityController,
                  hintText: "Enter city",
                  validator: (value){
                    if(value!.isEmpty){
                      return "City is required";
                    }
                    return null;
                  },
                ),

                Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (v) => setState(() => isChecked = v!),
                      side: BorderSide(color: Colors.white),
                    ),
                    Expanded(
                      child: Text(
                        "I agree with privacy & policy.",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Obx(() => CustomButton(
                    text: "Create Account",
                    isLoading: _registerController.isLoading.value,
                    onpress: _submit)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -------------- Helper UI -------------
  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 6),
    child: Text(
      text,
      style: TextStyle(color: Colors.white70, fontSize: 14),
    ),
  );





  // ---------------- DATE PICKER -----------------
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) =>
          Theme(data: ThemeData.dark(), child: child!),
    );

    if (picked != null) setState(() => dobController.text = _formatDate(picked));
  }

  // ---------------- TIME PICKER -----------------
  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) =>
          Theme(data: ThemeData.dark(), child: child!),
    );

    if (picked != null) setState(() => timeOfBirthController.text = _formatTime(picked));
  }

  String _formatDate(DateTime date) =>
      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

  String _formatTime(TimeOfDay t) =>
      "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:00";
}

