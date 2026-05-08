import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageController extends GetxController {
  final Rx<Locale> currentLocale = const Locale('en', 'US').obs;

  @override
  void onInit() {
    super.onInit();
    Get.updateLocale(currentLocale.value);
  }

  void changeLanguage(String code) {
    final locale = code == 'kn' ? const Locale('kn', 'IN') : const Locale('en', 'US');
    currentLocale.value = locale;
    Get.updateLocale(locale);
  }
}

