import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pro_pulse_medical_app/core/constants/app_colors.dart';
import 'package:pro_pulse_medical_app/core/constants/app_text_styles.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final bool isOutlined;
  final double? width;
  final double height;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isEnabled = true,
    this.isOutlined = false,
    this.width,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor =
        isEnabled
            ? (isOutlined ? Colors.white : AppColors.primary)
            : Colors.grey.shade200;

    final textColor =
        isEnabled
            ? (isOutlined ? AppColors.primary : Colors.white)
            : Colors.black54;

    final borderColor =
        isOutlined
            ? (isEnabled ? AppColors.primary : Colors.grey.shade300)
            : Colors.transparent;

    return SizedBox(
      width: width ?? double.infinity,
      height: height.h,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: bgColor,
          disabledBackgroundColor: Colors.grey.shade200,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.r),
            side: BorderSide(color: borderColor, width: 1.2),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.outfit(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
