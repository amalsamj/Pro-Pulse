import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pro_pulse_medical_app/core/constants/app_colors.dart';

Widget glassButton({
  required String label,
  required VoidCallback? onPressed,
  required bool isEnabled,
  double? width,
}) {
  return SizedBox(
    width: width ?? double.infinity,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(18.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor:
                isEnabled
                    ? AppColors.primary
                    : Colors.white.withValues(alpha: 0.1),
            disabledBackgroundColor: Colors.white.withValues(alpha: 0.1),
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
