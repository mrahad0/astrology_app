import 'package:astrology_app/data/utils/app_constants.dart';
import 'package:astrology_app/helpers/prefs_helpers.dart';
import 'package:astrology_app/routes/routes.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'helpers/di.dart' as di;

void main() async {
  await di.init();
  runApp(Astrology_App());
}

class Astrology_App extends StatefulWidget {
  @override
  State<Astrology_App> createState() => _Astrology_AppState();
}

class _Astrology_AppState extends State<Astrology_App> {
  @override
  void initState() {
    super.initState();
    _jumToNextPage();
  }

  _jumToNextPage() async {
      var token = await PrefsHelper.getString(AppConstants.bearerToken);
      debugPrint("issue token : $token");
      if (token.isNotEmpty) {
        Get.offAllNamed(
            Routes.mainScreen); //   Navigator.pushReplacementNamed(context, Routes.loginScreen);
      } else {
        Get.offAllNamed(Routes.loginScreen);
      }
  }

  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Astrology App",
      theme: ThemeData(
        fontFamily: "Manrope",
        primaryColor: CustomColors.primaryColor,
        scaffoldBackgroundColor: Colors.transparent,
        canvasColor: Colors.transparent,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          background: Colors.transparent,
          surface: Colors.transparent,
        ),
        // REMOVE WHITE FLASH ON NAVIGATION
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),

        appBarTheme: AppBarTheme(backgroundColor: Colors.transparent),
      ),

      // Global background image
      builder: (context, child) {
        return Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/astrology_background.png",
                fit: BoxFit.cover,
              ),
            ),
            child ?? SizedBox.shrink(),
          ],
        );
      },

      initialRoute: Routes.loginScreen,
      getPages: pages,
    );
  }
}
