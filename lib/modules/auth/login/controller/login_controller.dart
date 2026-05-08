import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_pulse_medical_app/app/routes/app_routes.dart';
import 'package:pro_pulse_medical_app/core/widgets/glass_snack_bar.dart';

class LoginController extends GetxController {
  final mobileController = TextEditingController();
  final otpController = TextEditingController();

  /// Reactive variable to control screen state
  RxBool showOtpField = false.obs;
  RxBool isMobileValid = false.obs;
  String mobileNumber = '';
  var otp = "".obs;
  final resendSeconds = 0.obs;
  Timer? _resendTimer;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args['mobile'] != null) {
      mobileNumber = args['mobile'];
    }
    debugPrint("Arguments received: ${Get.arguments}");
  }

  void validateMobile(String value) {
    final mobile = value.trim();
    isMobileValid.value =
        mobile.length == 10 && RegExp(r'^[0-9]+$').hasMatch(mobile);
  }

  RxBool isOtpValid = false.obs;

  void validateOtp(String input) {
    otp.value = input;
    isOtpValid.value = input.length == 6;
  }

  void startResendTimer({int seconds = 60}) {
    _resendTimer?.cancel();
    resendSeconds.value = seconds;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendSeconds.value <= 1) {
        resendSeconds.value = 0;
        timer.cancel();
        return;
      }

      resendSeconds.value--;
    });
  }

  void resendOtp() {
    if (resendSeconds.value > 0) return;

    otpController.clear();
    otp.value = '';
    isOtpValid.value = false;
    startResendTimer();
    showGlassSnack(
      title: 'OTP Sent',
      message: 'A new OTP has been sent to $mobileNumber',
    );
  }

  void verifyOtp(String value) {
    otp.value = value;

    if (otp.value == "123456") {
      // showGlassSnack(
      //   title: "Success",
      //   message: "OTP verified successfully",
      // );
      final verifiedMobile =
          mobileController.text.isNotEmpty
              ? mobileController.text
              : mobileNumber;
      Get.offNamed(Routes.signup, arguments: {'mobile': verifiedMobile});
    } else {
      otpController.clear();
      showGlassSnack(
        title: "Invalid OTP",
        message: "Please enter the correct OTP",
        isError: true,
      );
    }
  }

  void sendOtp() {
    final mobile = mobileController.text.trim();

    if (mobile.length == 10 && RegExp(r'^[0-9]+$').hasMatch(mobile)) {
      showOtpField.value = true;

      // ✅ Show green success snackbar
      mobileNumber = mobile;
      startResendTimer();
      Get.toNamed(Routes.loginOtp, arguments: {'mobile': mobile});

      // TODO: Call Firebase or backend here
    } else {
      // ❌ Show red error snackbar
      showGlassSnack(
        title: "Invalid Number",
        message: "Please enter a valid 10-digit mobile number",
        isError: true,
      );
    }
  }

  @override
  void onClose() {
    _resendTimer?.cancel();
    mobileController.dispose();
    otpController.dispose();
    super.onClose();
  }
}
