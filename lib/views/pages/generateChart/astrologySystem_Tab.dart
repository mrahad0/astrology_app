import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AstrologysystemTab extends StatefulWidget {
  final VoidCallback onNext;
  const AstrologysystemTab({super.key, required this.onNext});

  @override
  State<AstrologysystemTab> createState() => _AstrologysystemTab();
}

class _AstrologysystemTab extends State<AstrologysystemTab> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CustomColors.secondbackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:Color(0xff2A2F45),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Select Chart Type",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: buildCard(0, "Natal \nChart", "assets/icons/natal.svg")),
                        SizedBox(width: 8,),
                        Expanded(child: buildCard(1, "Transit \nChart", "assets/icons/transit.svg")),
                        SizedBox(width: 8,),
                        Expanded(child: buildCard(2, "Synastry \nChart","assets/icons/synastry.svg")),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // ---- Next Button ----

              CustomButton(
                text: "Next",
                onpress: () {
                  if (selectedIndex == 0) {
                    Get.toNamed(Routes.natalChart);
                  }
                  else if (selectedIndex == 1) {
                    Get.toNamed(Routes.transitChart );
                  }
                  else if (selectedIndex == 2) {
                    Get.toNamed(Routes.synastryChart);
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

  Widget buildCard(int index, String title, String url) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() => selectedIndex = index);
      },
      child: Container(
        width: 100,
        height: 110,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xff1B1F33),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.purple : const Color(0xff2A2F45),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            SvgPicture.asset(url),
            const SizedBox(height: 12),
            Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(color: isSelected ? Colors.purple : Colors.white, fontSize: 14,fontWeight: FontWeight.w600))
          ],
        ),
      ),
    );
  }
}
