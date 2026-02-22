import 'dart:async';
import 'package:get/get.dart';

class AuthController extends GetxController {
  RxInt secondsRemaining = 30.obs;
  RxBool enableResend = false.obs;
  RxBool isRememberMe = false.obs;
  RxBool isLoading = false.obs;
  Timer? timer;

  void onRememberMeChanged(bool value) => isRememberMe(value);

  void disposeTimer() {
    timer?.cancel();
    secondsRemaining.value = 30;
    enableResend.value = false;
  }

  void startTimer() {
    timer?.cancel();
    secondsRemaining.value = 30;
    enableResend.value = false;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        enableResend.value = true;
        timer.cancel();
      }
    });
  }
}

