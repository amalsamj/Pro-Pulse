import '../controller/patient_controller.dart';
import 'package:get/get.dart';

class PatientBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<PatientController>()) {
      Get.lazyPut<PatientController>(() => PatientController(), fenix: true);
    }
  }
}
