// import 'package:astrology_app/utils/color.dart';
// import 'package:astrology_app/views/base/custom_appBar.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class AstroDataScreen extends StatefulWidget {
//   const AstroDataScreen({super.key});
//
//   @override
//   State<AstroDataScreen> createState() => _AstroDataScreenState();
// }
//
// class _AstroDataScreenState extends State<AstroDataScreen> {
//   // Sample data list
//   final List<AstroData> astroDataList = [
//     AstroData(name: "Rahik rahika ahsan", gender: "Male", date: "12/11/2002"),
//     AstroData(name: "Rahik rahika ahsan", gender: "Male", date: "12/11/2002"),
//     AstroData(name: "Rahik rahika ahsan", gender: "Male", date: "12/11/2002"),
//     AstroData(name: "Rahik rahika ahsan", gender: "Male", date: "12/11/2002"),
//     AstroData(name: "Rahik rahika ahsan", gender: "Male", date: "12/11/2002"),
//     AstroData(name: "Rahik rahika ahsan", gender: "Male", date: "12/11/2002"),
//     AstroData(name: "Rahik rahika ahsan", gender: "Male", date: "12/11/2002"),
//     AstroData(name: "Rahik rahika ahsan", gender: "Male", date: "12/11/2002"),
//     AstroData(name: "Rahik rahika ahsan", gender: "Male", date: "12/11/2002"),
//     AstroData(name: "Rahik rahika ahsan", gender: "Male", date: "12/11/2002"),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(title: "Astro Data",leading: GestureDetector(onTap:(){Get.back();},child: Icon(Icons.arrow_back_ios,color: Colors.white,)),),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               /// ---- ADD ASTRO DATA BUTTON ----
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: ElevatedButton.icon(
//                   onPressed: () {
//                     // Navigate to add astro data page
//                     print("Add Astro Data");
//                   },
//                   icon: const Icon(Icons.add, size: 20),
//                   label: const Text(
//                     'Add Astro Data',
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: CustomColors.primaryColor,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 20,
//                       vertical: 12,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     elevation: 0,
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//
//               /// ---- ASTRO DATA LIST ----
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: astroDataList.length,
//                   itemBuilder: (context, index) {
//                     final data = astroDataList[index];
//                     return _astroDataCard(
//                       name: data.name,
//                       gender: data.gender,
//                       date: data.date,
//                       onTap: () {
//                         print("Tapped on: ${data.name}");
//                         // Navigate to detail page
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// ----------------------------
//   /// ASTRO DATA CARD WIDGET
//   /// ----------------------------
//   Widget _astroDataCard({
//     required String name,
//     required String gender,
//     required String date,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: CustomColors.secondbackgroundColor,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: const Color(0xff262A40)),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               name,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               gender,
//               style: const TextStyle(
//                 color: Colors.white70,
//                 fontSize: 14,
//               ),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               date,
//               style: const TextStyle(
//                 color: Colors.white60,
//                 fontSize: 14,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// /// ----------------------------
// /// ASTRO DATA MODEL
// /// ----------------------------
// class AstroData {
//   final String name;
//   final String gender;
//   final String date;
//
//   AstroData({
//     required this.name,
//     required this.gender,
//     required this.date,
//   });
// }



import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AstroDataScreen extends StatefulWidget {
  const AstroDataScreen({super.key});

  @override
  State<AstroDataScreen> createState() => _AstroDataScreenState();
}

class _AstroDataScreenState extends State<AstroDataScreen> {
  // Sample data list
  final List<AstroData> astroDataList = [
    AstroData(name: "Rahik rahika ahsan", gender: "Male", date: "12/11/2002", place: "Singapore"),
    AstroData(name: "Rahik ahsan", gender: "Male", date: "12/11/2002", place: "Bangladesh"),
    AstroData(name: "MD Ahad", gender: "Male", date: "12/11/2002", place: "India"),
    AstroData(name: "Mousud Bitkel", gender: "Male", date: "12/11/2002", place: "USA"),
    AstroData(name: "Rahik rahika ahsan", gender: "Male", date: "12/11/2002", place: "Singapore"),
    AstroData(name: "Rahik ahsan", gender: "Male", date: "12/11/2002", place: "Bangladesh"),
    AstroData(name: "Rahik rahika ahsan", gender: "Male", date: "12/11/2002", place: "Singapore"),
    AstroData(name: "MD Ahad", gender: "Male", date: "12/11/2002", place: "India"),
    AstroData(name: "Rahik rahika ahsan", gender: "Male", date: "12/11/2002", place: "Singapore"),
    AstroData(name: "Mousud Bitkel", gender: "Male", date: "12/11/2002", place: "USA"),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Astro Data",leading: GestureDetector(onTap:(){Get.back();},child: Icon(Icons.arrow_back_ios,color: Colors.white,)),),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
            itemCount: astroDataList.length,
            itemBuilder: (context, index) {
              final data = astroDataList[index];
              return _astroDataCard(
                name: data.name,
                gender: data.gender,
                date: data.date,
                place: data.place,
                onTap: () {
                  print("Tapped on: ${data.name}");
                  // Navigate to detail page
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed(Routes.addAstroData);
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

  /// ----------------------------
  /// ASTRO DATA CARD WIDGET
  /// ----------------------------
  Widget _astroDataCard({
    required String name,
    required String gender,
    required String date,
    required String place,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CustomColors.secondbackgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xff262A40)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              gender,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              date,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              place,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ----------------------------
/// ASTRO DATA MODEL
/// ----------------------------
class AstroData {
  final String name;
  final String gender;
  final String date;
  final String place;

  AstroData({
    required this.name,
    required this.gender,
    required this.date,
    required this.place,
  });
}