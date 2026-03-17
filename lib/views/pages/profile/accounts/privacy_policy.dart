// lib/views/pages/profile/accounts/privacy_policy.dart
import 'package:astrology_app/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import '../../../../controllers/privacy_controller/privacy_controller.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PrivacypolicyController());

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: ResponsiveHelper.width(4),
              ),
            );
          }

          if (controller.policyList.isEmpty) {
            return Center(
              child: Text(
                "No Privacy Policy Found",
                style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14)),
              ),
            );
          }

          final policy = controller.policyList.first;

          return SingleChildScrollView(
            padding: EdgeInsets.all(ResponsiveHelper.padding(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back_ios, color: Colors.white, size: ResponsiveHelper.iconSize(20)),
                    ),
                    SizedBox(width: ResponsiveHelper.space(20)),
                    Text(
                      policy.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.fontSize(24),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveHelper.space(30)),

                /// 👇 HTML CONTENT HERE
                Html(
                  data: policy.privacyPolicy.replaceAll('&nbsp;', ' '),
                  style: {
                    "p": Style(fontSize: FontSize(ResponsiveHelper.fontSize(16)), color: Colors.white),
                    "h3": Style(
                        fontSize: FontSize(ResponsiveHelper.fontSize(20)),
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    "h4": Style(
                        fontSize: FontSize(ResponsiveHelper.fontSize(18)),
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                    "li": Style(fontSize: FontSize(ResponsiveHelper.fontSize(16)), color: Colors.white),
                  },
                ),

                SizedBox(height: ResponsiveHelper.space(30)),
                Text(
                  "Last Updated: ${policy.updatedAt.toLocal()}",
                  style: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(12),
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}