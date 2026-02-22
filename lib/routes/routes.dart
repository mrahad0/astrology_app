import 'package:astrology_app/views/pages/ai_reading/ai_comprehensive.dart';
import 'package:astrology_app/views/pages/ai_reading/ai_reading.dart';
import 'package:astrology_app/views/pages/ai_reading/saved_chart.dart';
import 'package:astrology_app/views/pages/authentication/forgotpass_screen.dart';
import 'package:astrology_app/views/pages/authentication/login_screen.dart';
import 'package:astrology_app/views/pages/authentication/otp_screen.dart';
import 'package:astrology_app/views/pages/authentication/otp_for_create.dart';
import 'package:astrology_app/views/pages/chartPage/chart_Screen.dart';
import 'package:astrology_app/views/pages/generateChart/synastry_chart.dart';
import 'package:astrology_app/views/pages/generateChart/transit_chart.dart';
import 'package:astrology_app/views/pages/generateChart/natal_chart.dart';
import 'package:astrology_app/views/pages/generateChart/chartTypeTab.dart';
import 'package:astrology_app/views/pages/generateChart/details_chart/mainDetail_chart/mainDetail_chart.dart';
import 'package:astrology_app/views/pages/generateChart/details_chart/western_datails.dart';
import 'package:astrology_app/views/pages/generateChart/generate_chart_screen/generate_chart_screen.dart';
import 'package:astrology_app/views/pages/main_screen/main_Screen.dart';
import 'package:astrology_app/views/pages/payment_card/payment_card.dart';
import 'package:astrology_app/views/pages/payment_card/payment_type.dart';
import 'package:astrology_app/views/pages/profile/accounts/astro_data/astro_data.dart';
import 'package:astrology_app/views/pages/profile/accounts/change_pass.dart';
import 'package:astrology_app/views/pages/profile/accounts/info_edit.dart';
import 'package:astrology_app/views/pages/profile/accounts/personal_info.dart';
import 'package:astrology_app/views/pages/profile/accounts/privacy_policy.dart';
import 'package:astrology_app/views/pages/subscription/single_info.dart';
import 'package:astrology_app/views/pages/subscription/single_purchase.dart';
import 'package:astrology_app/views/pages/subscription/single_report.dart';
import 'package:astrology_app/views/pages/subscription/subscription_page.dart';
import 'package:get/get.dart';
import '../views/pages/authentication/newpass_screen.dart';
import '../views/pages/authentication/register_screen.dart';
import '../views/pages/generateChart/review_Tab.dart';

class Routes {
  static String loginScreen = "/";
  static String signUpScreen = "/SignUpScreen";
  static String forgotScreen = "/ForgotScreen";
  static String otpScreen = "/OtpScreen";
  static String otpForCreate = "/OtpForCreate";
  static String newPassScreen = "/NewPassScreen";
  static String mainScreen = "/MainScreen";
  static String chartPage = "/ChartPage";
  static String generateChartScreen = "/GenerateChart";
  static String savedChart = "/saved-chart";
  static String aiReading = "/AiReading";
  static String aiComprehensive = "/ai-comprehensive";
  static String privacyPolicy = "/PrivacyPolicy";
  static String changePass = "/ChangePassword";
  static String natalChart = "/NatalChart";
  static String transitChart = "/TransitChart";
  static String synastryChart = "/SynastryChart";
  static String chartType = "/ChartType";
  static String subscriptionPage = "/SubscriptionPage";
  static String paymentCard = "/PaymentCard";
  static String paymentType = "/PaymentType";
  static String reviewPage = "/ReviewPage";
  static String westernDetails = "/WesternDetails";
  static String mainDetailChart = "/MainDetailChart";
  static String personalInfo = "/PersonalInfo";
  static String personalInfoEdit = "/PersonalInfoEdit";
  static String astroData = "/AstroData";
  static String addAstroData = "/AddAstroData";
  static String singlePurchasePlan = "/SinglePurchasePlan";
  static String singleInfo = "/SingleInfo";
  static String singleReport = "/SingleReport";
}

List<GetPage> pages = [
  GetPage(
    name: Routes.loginScreen,
    transition: Transition.noTransition,
    transitionDuration: const Duration(milliseconds: 0),
    page: () => LoginScreen(),
  ),
  GetPage(
    name: Routes.signUpScreen,
    transition: Transition.noTransition,
    transitionDuration: const Duration(milliseconds: 0),
    page: () => SignupScreen(),
  ),
  GetPage(
    name: Routes.forgotScreen,
    transition: Transition.noTransition,
    transitionDuration: const Duration(milliseconds: 0),
    page: () => ForgotpassScreen(),
  ),
  GetPage(
    name: Routes.otpScreen,
    transition: Transition.noTransition,
    transitionDuration: const Duration(milliseconds: 0),
    page: () => OtpScreen(),
  ),
  GetPage(
    name: Routes.otpForCreate,
    transition: Transition.noTransition,
    transitionDuration: const Duration(milliseconds: 0),
    page: () => OtpForCreate(),
  ),
  GetPage(
    name: Routes.newPassScreen,
    transition: Transition.noTransition,
    transitionDuration: const Duration(milliseconds: 0),
    page: () => NewpassScreen(),
  ),
  GetPage(
    name: Routes.mainScreen,
    transition: Transition.noTransition,
    transitionDuration: const Duration(milliseconds: 0),
    page: () => MainScreen(),
  ),
  GetPage(
    name: Routes.chartPage,
    transition: Transition.noTransition,
    transitionDuration: const Duration(milliseconds: 0),
    page: () => ChartScreen(),
  ),
  GetPage(
    name: Routes.generateChartScreen,
    transition: Transition.noTransition,
    transitionDuration: const Duration(milliseconds: 0),
    page: () => GenerateChart(),
  ),
  GetPage(name: Routes.savedChart, page: () => SavedChart()),
  GetPage(
    name: Routes.aiReading,
    transition: Transition.noTransition,
    transitionDuration: const Duration(milliseconds: 0),
    page: () => AiReadingScreen(),
  ),
  GetPage(name: Routes.aiComprehensive, page: () => const AiComprehensive()),
  GetPage(
    name: Routes.privacyPolicy,
    transition: Transition.noTransition,
    transitionDuration: const Duration(milliseconds: 0),
    page: () => PrivacyPolicyScreen(),
  ),
  GetPage(
    name: Routes.changePass,
    transition: Transition.noTransition,
    transitionDuration: const Duration(milliseconds: 0),
    page: () => ChangePass(),
  ),
  GetPage(
    name: Routes.natalChart,
    transition: Transition.noTransition,
    transitionDuration: const Duration(milliseconds: 0),
    page: () => NatalChart(onNext: () {}),
  ),
  GetPage(
    name: Routes.transitChart,
    transition: Transition.noTransition,
    transitionDuration: const Duration(milliseconds: 0),
    page: () => TransitChart(onNext: () {}),
  ),
  GetPage(
    name: Routes.synastryChart,
    transition: Transition.noTransition,
    transitionDuration: const Duration(milliseconds: 0),
    page: () => SynastryChart(onNext: () {}),
  ),
  GetPage(
    name: Routes.chartType,
    transition: Transition.noTransition,
    transitionDuration: const Duration(milliseconds: 0),
    page: () => ChartTypeTab(onNext: () {}),
  ),
  GetPage(
    name: Routes.subscriptionPage,
    transition: Transition.noTransition,
    transitionDuration: const Duration(milliseconds: 0),
    page: () => SubscriptionPage(),
  ),
  GetPage(
    name: Routes.paymentCard,
    transition: Transition.noTransition,
    transitionDuration: const Duration(milliseconds: 0),
    page: () => PaymentCard(),
  ),
  GetPage(
    name: Routes.paymentType,
    transition: Transition.noTransition,
    transitionDuration: const Duration(milliseconds: 0),
    page: () => PaymentType(),
  ),
  GetPage(
    name: Routes.reviewPage,
    transition: Transition.noTransition,
    transitionDuration: const Duration(milliseconds: 0),
    page: () => ReviewGeneratePage(),
  ),
  GetPage(
    name: Routes.westernDetails,
    transition: Transition.noTransition,
    transitionDuration: const Duration(milliseconds: 0),
    page: () => WesternDatails(),
  ),
  GetPage(
    name: Routes.mainDetailChart,
    transition: Transition.noTransition,
    transitionDuration: const Duration(milliseconds: 0),
    page: () => MainDetailChart(),
  ),
  GetPage(
    name: Routes.personalInfo,
    transition: Transition.noTransition,
    transitionDuration: const Duration(milliseconds: 0),
    page: () => PersonalInfo(),
  ),
  GetPage(
    name: Routes.personalInfoEdit,
    transition: Transition.noTransition,
    transitionDuration: const Duration(milliseconds: 0),
    page: () => PersonalInfoEdit(),
  ),
  GetPage(
    name: Routes.astroData,
    transition: Transition.noTransition,
    transitionDuration: const Duration(milliseconds: 0),
    page: () => AstroDataScreen(),
  ),
  GetPage(
    name: Routes.singlePurchasePlan,
    transition: Transition.noTransition,
    transitionDuration: const Duration(milliseconds: 0),
    page: () => SinglePurchasePlan(),
  ),
  GetPage(
    name: Routes.singleInfo,
    transition: Transition.noTransition,
    transitionDuration: const Duration(milliseconds: 0),
    page: () => SingleInfo(),
  ),
  GetPage(
    name: Routes.singleReport,
    transition: Transition.noTransition,
    transitionDuration: const Duration(milliseconds: 0),
    page: () => SingleReport(),
  ),
];
