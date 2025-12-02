import 'package:astrology_app/controllers/auth_controller/auth_controller.dart';
import 'package:get/get.dart';

Future init()async{
  Get.put(AuthController());
}