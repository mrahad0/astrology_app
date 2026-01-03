import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../controllers/chart_controller/saved_chart_controller.dart';
import '../../../../base/custom_button.dart';
import '../../../ai_reading/saved_charts_details.dart';

class AstroDataScreen extends StatefulWidget {
  const AstroDataScreen({super.key});

  @override
  State<AstroDataScreen> createState() => AstroDataScreenState();
}

class AstroDataScreenState extends State<AstroDataScreen> {

  final controller = Get.put(SavedChartController());

  @override
  void initState() {
    super.initState();
    controller.fetchSavedCharts();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(
        title: "Astro Data",
        leading: GestureDetector(
          onTap: () => Navigator.pop(context), child: Icon(Icons.arrow_back_ios, color: Colors.white,)),),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Obx((){
            if(controller.isLoading.value){
              return const Center(child: CircularProgressIndicator());
            }
            if(controller.savedCharts.isEmpty){
              return const Center(child: Text("No saved charts"));
            }
            return SingleChildScrollView(

                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    const SizedBox(height: 22),

                ...controller.savedCharts.map((chart) {

              return Padding(

                padding: const EdgeInsets.only(bottom: 14),
                child: chartCard(
                  type: "${chart?.chartCategory} (${chart.systemType})",
                  name: chart.name,
                  date: chart.date,
                  location: "${chart.city}, ${chart.country}",
                ),
              );
            }).toList(),
              ])
            );
          }),),),


      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed(Routes.generateChartScreen);
        },
        backgroundColor: CustomColors.primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Astro Data',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }


  Widget chartCard({
    required String type,
    required String name,
    required String date,
    required String location,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xff2E334A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(type,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
          const SizedBox(height: 4),
          Text(name, style: const TextStyle(fontSize: 13, color: Color(0xffA0A4B8))),
          const SizedBox(height: 4),
          Text(date, style: const TextStyle(fontSize: 13, color: Color(0xffA0A4B8))),
          const SizedBox(height: 4),
          Text(location, style: const TextStyle(fontSize: 13, color: Color(0xffA0A4B8))),
          const SizedBox(height: 18),
          CustomButton(
            text: "View",
            onpress: () {
              Get.to(SavedChartsDetails());
            },
          )
        ],
      ),
    );
  }
}