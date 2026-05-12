import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/utils/responsive.dart';
import 'package:astrology_app/views/base/custom_appBar.dart';
import 'package:flutter/material.dart';

class CombinedInterpretationScreen extends StatelessWidget {
  const CombinedInterpretationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/reading_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          title: "Combined Interpretation",
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: ResponsiveHelper.iconSize(20)),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- The Combined Interpretation Card ---
                  Container(
                    padding: EdgeInsets.all(ResponsiveHelper.padding(20)),
                    decoration: BoxDecoration(
                      color: CustomColors.secondbackgroundColor,
                      borderRadius: BorderRadius.circular(ResponsiveHelper.radius(16)),
                      border: Border.all(color: const Color(0xFF2F3448)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Section 3',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveHelper.fontSize(14),
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.space(8)),
                        Text(
                          'Combined Interpretation',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.fontSize(18),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.space(16)),
                        Text(
                          "This section brings together the meanings of the individual placements and aspects described earlier. Instead of looking at each astrological factor separately from individual types of astrology, it considers how they interact with one another to form broader patterns in the charts. The goal is to provide a more holistic view of personality tendencies, life themes and potential areas of development reflected in the overall astrological configuration. The combined interpretation provides a unified understanding. By viewing these elements together, it highlights broader patterns and themes that may not appear when each system is examined separately.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveHelper.fontSize(14),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: ResponsiveHelper.space(24)),
                  
                  // --- Share and Download Buttons ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildActionButton(
                        icon: Icons.share_outlined,
                        label: 'Share',
                        onTap: () {
                          // TODO: Implement share
                        },
                      ),
                      SizedBox(width: ResponsiveHelper.space(16)),
                      _buildActionButton(
                        icon: Icons.download_outlined,
                        label: 'Download',
                        onTap: () {
                          // TODO: Implement download
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.padding(24),
          vertical: ResponsiveHelper.padding(12),
        ),
        decoration: BoxDecoration(
          color: CustomColors.secondbackgroundColor,
          borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
          border: Border.all(color: const Color(0xFF2F3448)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: ResponsiveHelper.iconSize(18)),
            SizedBox(width: ResponsiveHelper.space(8)),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.fontSize(14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
