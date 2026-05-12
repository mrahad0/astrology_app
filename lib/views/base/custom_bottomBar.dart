
import 'package:astrology_app/utils/responsive.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:flutter/material.dart';


class CustomBottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.padding(10)),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(40)),
        border: Border.all(color: const Color(0xFF2F3448)),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(0, Icons.bar_chart, "Chart"),
          _navItem(1, Icons.auto_awesome_outlined, "Reading"),
          _navItem(2, Icons.notifications_none, "Notification"),
          _navItem(3, Icons.person_outline, "Profile"),
        ],
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    bool isSelected = index == selectedIndex;

    return GestureDetector(
      onTap: () => onItemTapped(index),
      behavior: HitTestBehavior.translucent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: isSelected
            ? EdgeInsets.symmetric(horizontal: ResponsiveHelper.padding(18), vertical: ResponsiveHelper.padding(10))
            : EdgeInsets.all(ResponsiveHelper.padding(10)),
        decoration: isSelected
            ? BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ResponsiveHelper.radius(30)),
        )
            : null,
        child: Row(
          children: [
            Icon(
              icon,
              size: ResponsiveHelper.iconSize(22),
              color: isSelected ? Colors.black : Colors.white,
            ),
            if (isSelected) ...[
              SizedBox(width: ResponsiveHelper.space(8)),
              Text(
                label,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: ResponsiveHelper.fontSize(14),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
