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
            : AppColors.disableButton;

    final textColor =
        isEnabled
            ? (isOutlined ? AppColors.primary : Colors.white)
            : Colors.black54;

    final borderColor =
        isOutlined
            ? (isEnabled ? AppColors.primary : AppColors.disableButton)
            : Colors.transparent;

    return SizedBox(
      width: width ?? double.infinity,
      height: height.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: bgColor,
          disabledBackgroundColor: AppColors.disableButton,
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

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isEnabled;
  final Widget? child;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: isEnabled ? AppColors.primary : Colors.grey.shade200,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.r),
          ),
        ),
        child:
            child ??
            Text(
              text,
              style: AppTextStyles.authButton().copyWith(
                color: isEnabled ? Colors.white : Colors.black54,
              ),
            ),
      ),
    );
  }
}
