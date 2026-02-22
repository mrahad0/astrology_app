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
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (controller.policyList.isEmpty) {
            return const Center(
              child: Text(
                "No Privacy Policy Found",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final policy = controller.policyList.first;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios,
                          color: Colors.white),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      policy.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                /// 👇 HTML CONTENT HERE
                Html(
                  data: policy.privacyPolicy.replaceAll('&nbsp;', ' '),
                  style: {
                    "p": Style(fontSize: FontSize(16), color: Colors.white),
                    "h3": Style(
                        fontSize: FontSize(20),
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    "h4": Style(
                        fontSize: FontSize(18),
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                    "li": Style(fontSize: FontSize(16), color: Colors.white),
                  },
                ),

                const SizedBox(height: 30),
                Text(
                  "Last Updated: ${policy.updatedAt.toLocal()}",
                  style: const TextStyle(
                    fontSize: 12,
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