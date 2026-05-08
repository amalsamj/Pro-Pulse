import 'package:get/get.dart';
import 'package:pro_pulse_medical_app/modules/auth/signup/controller/signup_controller.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupController>(() => SignupController(), fenix: true);
  }
}
