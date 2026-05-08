import 'package:get/get.dart';
import 'package:liquid_swipe/PageHelpers/LiquidController.dart';
import 'package:pro_pulse_medical_app/app/routes/app_routes.dart';
import 'package:pro_pulse_medical_app/core/services/app_service.dart';

class OnboardingController extends GetxController {
  late LiquidController liquidController;
  final RxInt currentPage = 0.obs;
  bool _isCompleting = false;

  @override
  void onInit() {
    super.onInit();
    liquidController = LiquidController();
  }

  Future<void> completeOnboarding() async {
    if (_isCompleting) return;
    _isCompleting = true;

    final appService = await Get.find<AppService>().init();
    await appService.markOnboardingSeen();
    Get.offNamed(Routes.landing);
  }
}
