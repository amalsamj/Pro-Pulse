import '../controller/booking_controller.dart';
import 'package:get/get.dart';

class BookingBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<BookingController>()) {
      Get.lazyPut<BookingController>(() => BookingController(), fenix: true);
    }
  }
}
