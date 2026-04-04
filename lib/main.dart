import 'package:astrology_app/data/utils/app_constants.dart';
import 'package:astrology_app/helpers/prefs_helpers.dart';
import 'package:astrology_app/routes/routes.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/chart_controller/chart_controller.dart';
import 'controllers/chart_controller/recent_chart_controller.dart';
import 'controllers/ai_compresive/ai_compresive_controller.dart';
import 'helpers/di.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize permanent controllers to keep data alive during app session
  Get.put(ChartController(), permanent: true);
  Get.put(InterpretationController(), permanent: true);
  Get.put(RecentChartController(), permanent: true);
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
          Routes.mainScreen);
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
        scaffoldBackgroundColor: CustomColors.backgroundColor,
        canvasColor: CustomColors.backgroundColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          background: CustomColors.backgroundColor,
          surface: CustomColors.backgroundColor,
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

      // Initialize ResponsiveHelper globally
      builder: (context, child) {
        ResponsiveHelper.init(context);
        return child ?? const SizedBox.shrink();
      },

      initialRoute: Routes.loginScreen,
      getPages: pages,
    );
  }
}
