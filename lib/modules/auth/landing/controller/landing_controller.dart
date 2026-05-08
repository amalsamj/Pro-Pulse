import 'package:get/get.dart';

class LandingController extends GetxController {
  final hasAcceptedTerms = false.obs;

  void toggleTerms(bool? value) {
    hasAcceptedTerms.value = value ?? false;
  }
}
