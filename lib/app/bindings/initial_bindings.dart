import 'package:pro_pulse_medical_app/app/localization/language_controller.dart';
import 'package:pro_pulse_medical_app/core/services/app_service.dart';
import 'package:get/get.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AppService(), permanent: true);
    Get.put(LanguageController(), permanent: true);
  }
}
