import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showGlassSnack({
  required String title,
  required String message,
  bool isError = false,
}) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.white,
    colorText: isError ? Colors.red.shade700 : Colors.black,
    borderRadius: 12,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    padding: const EdgeInsets.all(16),
    isDismissible: true,
    duration: const Duration(milliseconds: 3000),
    boxShadows: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
    borderColor: isError ? Colors.red.shade200 : Colors.grey.shade300,
    borderWidth: 1,
  );
}

