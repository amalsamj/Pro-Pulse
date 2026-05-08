import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pro_pulse_medical_app/modules/welcome/widgets/screen_4.dart';
import 'package:pro_pulse_medical_app/modules/welcome/widgets/screen_2.dart';
import 'package:pro_pulse_medical_app/modules/welcome/widgets/screen_3.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:pro_pulse_medical_app/modules/welcome/widgets/screen_1.dart';
import 'package:pro_pulse_medical_app/modules/welcome/controller/onboarding_controller.dart';

Widget dummyRedirectPage = Scaffold(
  backgroundColor: const Color(0xFFF6F8FB),
  body: Stack(
    fit: StackFit.expand,
    children: [
      // Background Image
      Image.asset('assets/images/welcome1.jpg', fit: BoxFit.cover),

      // Light Blur Layer
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          color: Colors.black.withValues(alpha: 0.2), // optional tint
        ),
      ),
    ],
  ),
);

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: Stack(
        children: [
          LiquidSwipe(
            pages: [
              GlassOnboardingPage(pageIndex: 0),
              GlassOnboardingPage2(pageIndex: 1),
              GlassOnboardingPage3(pageIndex: 2),
              GlassOnboardingPage4(pageIndex: 3),
              dummyRedirectPage,
            ],
            enableLoop: false,
            enableSideReveal: false,
            waveType: WaveType.liquidReveal,
            fullTransitionValue: 600,
            positionSlideIcon: 0.5,
            slideIconWidget: null,

            /// 🔥 This keeps the dots in sync
            liquidController: controller.liquidController,
            onPageChangeCallback: (index) {
              controller.currentPage.value = index;

              // Complete onboarding after the final swipe.
              if (index == 4) {
                Future.delayed(const Duration(milliseconds: 100), () {
                  controller.completeOnboarding();
                });
              }
            },
          ),

          // Skip / Arrow
          Positioned(
            bottom: 40.h,
            left: 25.w,
            child: GestureDetector(
              onTap: controller.completeOnboarding,
              child: Icon(
                HeroIcons.arrow_long_right,
                color: Colors.white,
                size: 35.r,
              ),
            ),
          ),

          // Dot Indicators
          Positioned(
            bottom: 55.h,
            right: 20.w,
            child: Obx(
              () => AnimatedSmoothIndicator(
                activeIndex: controller.currentPage.value,
                count: 4, // number of pages
                effect: ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  spacing: 6,
                  activeDotColor: Colors.white,
                  dotColor: Colors.white.withValues(alpha: 0.4),
                  expansionFactor: 3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
