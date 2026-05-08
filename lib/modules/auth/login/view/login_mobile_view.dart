import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:pro_pulse_medical_app/app/routes/app_routes.dart';
import 'package:pro_pulse_medical_app/core/constants/app_colors.dart';
import 'package:pro_pulse_medical_app/core/constants/app_spacing.dart';
import 'package:pro_pulse_medical_app/core/constants/app_text_styles.dart';
import 'package:pro_pulse_medical_app/core/widgets/app_button.dart';
import 'package:pro_pulse_medical_app/core/widgets/keyboard_dismiss.dart';
import 'package:pro_pulse_medical_app/modules/auth/login/controller/login_controller.dart';

class MobileLoginView extends GetView<LoginController> {
  const MobileLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned(
                  top: 100, // adjust based on your layout
                  left: 0,
                  right: 0,
                  child: Text(
                    " Stay healthy,\nour priority.",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.authHero().copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                )
                .animate()
                .fadeIn(duration: Duration(seconds: 2))
                .slide(duration: Duration(seconds: 2)),

            // 🔹 Centered Glassmorphic Login Card
            // 🔹 Positioned Glassmorphic Login Box
            Positioned(
                  bottom: 70.h, // 👈 Adjust this value to move it down
                  left: 24.w,
                  right: 24.w,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 24.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const PlainLottieLogo(),
                            // appLogo(),
                            // SizedBox(height: 10.h,),
                            // Text(
                            //   "LOGIN",
                            //   style: AppTextStyles.authTitle(),
                            //   textAlign: TextAlign.center,
                            // ),
                            AppSpacing.h15,
                            // 🔹 Input Field
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14.r),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 12,
                                  sigmaY: 12,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(14.r),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.3,
                                      ),
                                    ),
                                  ),

                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                  ),
                                  child: Row(
                                    children: [
                                      AppSpacing.w8,
                                      // 🔹 Prefix with Divider
                                      Row(
                                        children: [
                                          Text(
                                            "+91",
                                            style: AppTextStyles.authInput(
                                              size: 17,
                                              letterSpacing: 2.5,
                                            ),
                                          ),
                                          AppSpacing.w15,
                                          Container(
                                            height: 20.h,
                                            width: 1,
                                            color: Colors.red.withValues(
                                              alpha: 0.5,
                                            ),
                                          ),
                                          AppSpacing.w15,
                                        ],
                                      ),

                                      // 🔹 TextField
                                      Expanded(
                                        child: TextField(
                                          controller:
                                              controller.mobileController,
                                          keyboardType: TextInputType.phone,
                                          onChanged: controller.validateMobile,
                                          maxLength: 10,
                                          style: AppTextStyles.authInput(
                                            size: 17,
                                            letterSpacing: 2.5,
                                          ),
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],

                                          decoration: InputDecoration(
                                            counterText: "",
                                            hintText: "Mobile Number",
                                            hintStyle: AppTextStyles.authHint(
                                              size: 17,
                                            ),
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  vertical: 14.h,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            AppSpacing.h15,
                            // 🔹 Send OTP
                            Obx(
                              () => AppButton(
                                label: "SEND OTP",
                                onPressed: controller.sendOtp,
                                isEnabled: controller.isMobileValid.value,
                              ),
                            ),
                            AppSpacing.h14,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "No account? ",
                                  style: AppTextStyles.authBody().copyWith(
                                    color: Colors.black,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Get.toNamed(Routes.signup),
                                  child: Text(
                                    "Register Now",
                                    style: AppTextStyles.authLink().copyWith(
                                      color: AppColors.primary,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                .animate()
                .fade(duration: Duration(seconds: 2), begin: 0, end: 8)
                .slide(
                  duration: Duration(seconds: 1),
                  begin: const Offset(0, 1), // From bottom
                  end: Offset.zero,
                  curve: Curves.easeOut,
                ),
          ],
        ),
      ),
    );
  }
}

class PlainLottieLogo extends StatelessWidget {
  const PlainLottieLogo({
    super.key,
    this.asset = 'assets/images/w1.json',
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.repeat = true,
  });

  final String asset;
  final double? width;
  final double? height;
  final BoxFit fit;
  final bool repeat;

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      asset,
      width: width,
      height: height,
      fit: fit,
      repeat: repeat,
    );
  }
}

Widget appLogo() {
  return SizedBox(
    // height: 80,
    // width: 80,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset("assets/logo_no_bg.png", fit: BoxFit.cover),
    ),
  );
}
