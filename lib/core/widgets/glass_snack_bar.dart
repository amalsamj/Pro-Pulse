import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pro_pulse_medical_app/core/constants/app_colors.dart';
import 'package:pro_pulse_medical_app/core/constants/app_text_styles.dart';

Widget glassButton({
  required String label,
  required VoidCallback onPressed,
  required bool isValid,
  double? width,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(18.r),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: SizedBox(
        width: width,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor:
                isValid
                    ? AppColors.primary
                    : Colors.white.withValues(alpha: 0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.r),
            ),
            padding: EdgeInsets.symmetric(vertical: 14.h),
            shadowColor: Colors.transparent,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ),
  );
}

void showGlassSnack({
  required String title,
  required String message,
  bool isError = false,
}) {
  Get.snackbar(
    '',
    '',
    titleText: Text(
      title,
      style: AppTextStyles.title(
        size: 15.sp,
        weight: FontWeight.w700,
        color: isError ? Colors.redAccent : AppColors.primary,
      ),
    ),
    messageText: Text(
      message,
      style: AppTextStyles.body(size: 13.sp, color: Colors.black87),
    ),
    snackPosition: SnackPosition.TOP,
    margin: EdgeInsets.all(16.r),
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
    borderRadius: 18.r,
    backgroundColor: Colors.white.withValues(alpha: 0.92),
    borderColor:
        isError
            ? Colors.redAccent.withValues(alpha: 0.35)
            : AppColors.primary.withValues(alpha: 0.35),
    borderWidth: 1,
    boxShadows: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.12),
        blurRadius: 18,
        offset: const Offset(0, 8),
      ),
    ],
    icon: Icon(
      isError ? Icons.error_rounded : Icons.check_circle_rounded,
      color: isError ? Colors.redAccent : AppColors.primary,
      size: 28.r,
    ),
    shouldIconPulse: false,
    duration: const Duration(seconds: 3),
    animationDuration: const Duration(milliseconds: 450),
    forwardAnimationCurve: Curves.easeOutBack,
  );
}
