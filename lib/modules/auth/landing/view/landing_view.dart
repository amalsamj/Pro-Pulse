import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_pulse_medical_app/core/widgets/app_button.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../controller/landing_controller.dart';

class LandingView extends GetView<LandingController> {
  const LandingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.fromLTRB(32.w, 0, 32.w, 26.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50.h),

                Image.asset(
                  'assets/images/logo.jpeg',
                  width: 102.w,
                  height: 102.w,
                  fit: BoxFit.contain,
                ),

                SizedBox(height: 14.h),

                const HeroChangingText(),
                SizedBox(height: 60.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 4.h, left: 15.w),
                      child: Obx(
                        () => GestureDetector(
                          onTap:
                              () => controller.toggleTerms(
                                !controller.hasAcceptedTerms.value,
                              ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 16.w,
                            height: 16.w,
                            decoration: BoxDecoration(
                              color:
                                  controller.hasAcceptedTerms.value
                                      ? AppColors.primary
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(4.r),
                              border: Border.all(
                                color:
                                    controller.hasAcceptedTerms.value
                                        ? AppColors.primary
                                        : const Color(0xFFD9D9D9),
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 15.w),

                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          style: GoogleFonts.outfit(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.35,
                            color: const Color(0xFF7A7A7A),
                          ),
                          children: [
                            TextSpan(text: 'I agree with Pro Pulse '),
                            _linkSpan('Terms And Conditions'),
                            const TextSpan(text: ' and acknowledge the '),
                            _linkSpan('Privacy notice'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 44.h),

                Obx(
                  () => AppButton(
                    label: 'Sign up',
                    onPressed: () => Get.toNamed(Routes.signup),
                    isEnabled: controller.hasAcceptedTerms.value,
                    height: 64,
                  ),
                ),

                SizedBox(height: 20.h),

                Obx(
                  () => AppButton(
                    label: 'Log in',
                    onPressed: () => Get.toNamed(Routes.login),
                    isEnabled: controller.hasAcceptedTerms.value,
                    isOutlined: true,
                    height: 64,
                  ),
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextSpan _linkSpan(String text) {
    return TextSpan(
      text: text,
      style: GoogleFonts.outfit(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        height: 1.35,
        color: AppColors.accent,
        decoration: TextDecoration.none,
        decorationThickness: 1.2,
      ),
    );
  }
}

class HeroChangingText extends StatefulWidget {
  const HeroChangingText({super.key});

  @override
  State<HeroChangingText> createState() => _HeroChangingTextState();
}

class _HeroChangingTextState extends State<HeroChangingText> {
  final List<String> services = [
    'Pulmo Rehab',
    'Physiotherapy',
    'Pain Relief',
    'Neuro Rehab',
    'Ortho Rehab',
    'Home Care',
  ];

  int index = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted) return;
      setState(() {
        index = (index + 1) % services.length;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        style: GoogleFonts.outfit(
          fontSize: 44.sp,
          height: 1.05,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF151515),
          letterSpacing: -1.2,
        ),
        children: [
          const TextSpan(text: 'Get \nspecialised\ncare for, '),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 450),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.35),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: Text(
                services[index],
                key: ValueKey(services[index]),
                style: GoogleFonts.outfit(
                  fontSize: 45.sp,
                  height: 1.05,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  letterSpacing: -1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
