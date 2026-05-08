import '../controller/shopping_controller.dart';
import 'package:get/get.dart';

class ShoppingBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ShoppingController>()) {
      Get.lazyPut<ShoppingController>(() => ShoppingController(), fenix: true);
    }
  }
}
