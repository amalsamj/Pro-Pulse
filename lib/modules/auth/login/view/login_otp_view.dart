import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:pro_pulse_medical_app/core/constants/app_colors.dart';
import 'package:pro_pulse_medical_app/core/constants/app_spacing.dart'
    show AppSpacing;
import 'package:pro_pulse_medical_app/core/constants/app_text_styles.dart';
import 'package:pro_pulse_medical_app/core/widgets/app_button.dart';
import 'package:pro_pulse_medical_app/core/widgets/keyboard_dismiss.dart'
    show KeyboardDismisser;
import 'package:pro_pulse_medical_app/modules/auth/login/controller/login_controller.dart';
import 'package:pro_pulse_medical_app/modules/auth/login/view/login_mobile_view.dart';

class OtpVerificationView extends GetView<LoginController> {
  const OtpVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    controller.mobileNumber = args?['mobile'] ?? '';
    if (controller.resendSeconds.value == 0) {
      controller.startResendTimer();
    }

    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isShortScreen = screenHeight < 720;
    final horizontalPadding = 24.w;
    final pinSize = ((screenWidth - (horizontalPadding * 2) - 96.w) / 6).clamp(
      42.w,
      56.w,
    );
    final focusedPinSize = (pinSize + 4.w).clamp(46.w, 60.w);

    return KeyboardDismisser(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  isShortScreen ? 48.h : 78.h,
                  horizontalPadding,
                  MediaQuery.viewInsetsOf(context).bottom +
                      (isShortScreen ? 28.h : 54.h),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        constraints.maxHeight -
                        MediaQuery.viewInsetsOf(context).bottom -
                        (isShortScreen ? 76.h : 152.h),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                            'For every need,\nwe take the lead.',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.authHero(
                              size: isShortScreen ? 28 : 32,
                              color: AppColors.accent,
                            ),
                          )
                          .animate()
                          .fadeIn(duration: const Duration(seconds: 2))
                          .slide(duration: const Duration(seconds: 2)),
                      // AppSpacing.height(isShortScreen ? 38 : 56),
                      _OtpCard(
                            controller: controller,
                            pinSize: pinSize,
                            focusedPinSize: focusedPinSize,
                            isShortScreen: isShortScreen,
                          )
                          .animate()
                          .fade(
                            duration: const Duration(seconds: 2),
                            begin: 0,
                            end: 8,
                          )
                          .slide(
                            duration: const Duration(seconds: 1),
                            begin: const Offset(0, 1),
                            end: Offset.zero,
                            curve: Curves.easeOut,
                          ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _OtpCard extends StatelessWidget {
  const _OtpCard({
    required this.controller,
    required this.pinSize,
    required this.focusedPinSize,
    required this.isShortScreen,
  });

  final LoginController controller;
  final double pinSize;
  final double focusedPinSize;
  final bool isShortScreen;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: isShortScreen ? 22.h : 26.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// LOGO
          const PlainLottieLogo(asset: 'assets/images/logo2.json'),

          /// TEXT
          Text(
            'OTP has been sent to ${controller.mobileNumber}',
            textAlign: TextAlign.center,
            style: AppTextStyles.body(
              size: isShortScreen ? 14 : 16,
              color: Colors.black87,
            ),
          ),

          AppSpacing.height(20),

          /// OTP FIELD
          Pinput(
            length: 6,
            controller: controller.otpController,

            defaultPinTheme: PinTheme(
              width: pinSize,
              height: pinSize,
              textStyle: AppTextStyles.pinText(
                size: 18,
                weight: FontWeight.w600,
              ).copyWith(color: Colors.black),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
            ),

            focusedPinTheme: PinTheme(
              width: focusedPinSize,
              height: focusedPinSize,
              textStyle: AppTextStyles.pinText(
                size: 20,
                weight: FontWeight.bold,
              ).copyWith(color: Colors.black),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: AppColors.primary, width: 1.5),
              ),
            ),

            submittedPinTheme: PinTheme(
              width: pinSize,
              height: pinSize,
              textStyle: AppTextStyles.pinText(
                size: 18,
              ).copyWith(color: Colors.black),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
            ),

            onChanged: controller.validateOtp,
            onCompleted: (value) {
              controller.otp.value = value;
              controller.validateOtp(value);
            },
          ),

          AppSpacing.height(20),

          /// RESEND
          Obx(() {
            final seconds = controller.resendSeconds.value;
            final canResend = seconds == 0;

            return GestureDetector(
              onTap: canResend ? controller.resendOtp : null,
              child: Text(
                canResend ? 'Resend OTP' : 'Resend OTP in ${seconds}s',
                style: AppTextStyles.body(
                  size: 13,
                  color: canResend ? AppColors.primary : Colors.grey,
                ).copyWith(
                  fontWeight: canResend ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            );
          }),

          AppSpacing.height(20),

          /// BUTTON
          Obx(
            () => AppButton(
              label: "Verify OTP",
              onPressed:
                  controller.isOtpValid.value
                      ? () => controller.verifyOtp(controller.otp.value)
                      : null,
              isEnabled: controller.isOtpValid.value,
            ),
          ),
        ],
      ),
    );
  }
}
