import 'package:flutter/animation.dart';
import 'package:pro_pulse_medical_app/app/routes/app_routes.dart';
import 'package:pro_pulse_medical_app/core/services/app_service.dart';
import 'package:get/get.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late RxBool fadeIn = false.obs;

  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    Future.delayed(const Duration(milliseconds: 500), () {
      fadeIn.value = true;
    });

    Future.delayed(const Duration(seconds: 2), _openNextRoute);
  }

  Future<void> _openNextRoute() async {
    final appService = await Get.find<AppService>().init();

    if (appService.isLoggedIn) {
      Get.offNamed(Routes.home);
      return;
    }

    if (!appService.hasSeenOnboarding) {
      Get.offNamed(Routes.onboarding);
      return;
    }

    Get.offNamed(Routes.landing);
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
