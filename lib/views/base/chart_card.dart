import 'package:astrology_app/utils/responsive.dart';
import 'package:flutter/material.dart';
class ChartCard extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const ChartCard({
    required this.text,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: ResponsiveHelper.width(100),
        padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
          gradient: isSelected
              ? LinearGradient(colors: [Colors.purpleAccent, Colors.purple])
              : null,
          border: Border.all(
              color: isSelected ? Colors.purple : Colors.grey.shade300, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: ResponsiveHelper.iconSize(32), color: isSelected ? Colors.white : Colors.black),
            SizedBox(height: ResponsiveHelper.space(8)),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveHelper.fontSize(14)),
            ),
          ],
        ),
      ),
    );
  }
}
