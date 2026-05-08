import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_colors.dart';

class GlassInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final bool readOnly;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final String? suffixText;
  final Widget? prefix;
  final Widget? suffixIcon;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  const GlassInputField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.onChanged,
    this.readOnly = false,
    this.focusNode,
    this.onTap,
    this.suffixText,
    this.prefix,
    this.suffixIcon,
    this.maxLength,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(14.r),
          // border: Border.all(color: Colors.grey.withOpacity(0.25), width: 1),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: TextField(
          controller: controller,
          maxLength: maxLength,
          focusNode: focusNode,
          onTap: onTap,
          readOnly: readOnly,
          onChanged: onChanged,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          textCapitalization: TextCapitalization.words,
          style: AppTextStyles.authInput(color: Colors.black),
          decoration: InputDecoration(
            iconColor: AppColors.accent,
            prefixIcon:
                prefix == null
                    ? null
                    : Padding(
                      padding: EdgeInsets.only(left: 6.w),
                      child: prefix,
                    ),
            counterText: '',
            hintText: hintText,

            hintStyle: AppTextStyles.authHint().copyWith(
              color: Colors.blueGrey,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              vertical: 14.h,
              horizontal: 7.w,
            ),
            suffixIcon:
                suffixIcon == null
                    ? null
                    : Padding(
                      padding: EdgeInsets.only(left: 20.w),
                      child: suffixIcon,
                    ),

            suffixText: suffixText,
            suffixStyle: AppTextStyles.authHint().copyWith(
              color: AppColors.accent,
            ),
          ),
        ),
      ),
    );
  }
}

class GlassReadonlyField extends StatelessWidget {
  final String label;
  final String value;
  final double? width;

  const GlassReadonlyField({
    super.key,
    required this.label,
    required this.value,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(14.r),
          // border: Border.all(color: Colors.grey.withOpacity(0.25)),
        ),
        child: Text(
          value.isNotEmpty ? value : label,
          style: AppTextStyles.authBody(
            size: 15,
            color: value.isNotEmpty ? Colors.black : Colors.blueGrey,
          ).copyWith(fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}

class GlassDOBField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final VoidCallback onTap;
  final Widget? suffixIcon;

  const GlassDOBField({
    required this.controller,
    required this.hint,
    required this.onTap,
    super.key,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(14.r),
          // border: Border.all(color: Colors.grey.withOpacity(0.25)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: TextField(
          controller: controller,
          readOnly: true,
          onTap: onTap,
          style: AppTextStyles.authInput(color: Colors.black),
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon:
                suffixIcon == null
                    ? null
                    : Padding(
                      padding: EdgeInsets.only(left: 20.w),
                      child: suffixIcon,
                    ),
            hintStyle: AppTextStyles.authHint().copyWith(
              color: Colors.blueGrey,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              vertical: 14.h,
              horizontal: 7.w,
            ),
          ),
        ),
      ),
    );
  }
}
