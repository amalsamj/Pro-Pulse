import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pro_pulse_medical_app/modules/welcome/controller/onboarding_controller.dart';

class GlassOnboardingPage2 extends StatelessWidget {
  final int pageIndex;
  GlassOnboardingPage2({super.key, required this.pageIndex});

  final path =
      Path()
        ..moveTo(0, 0)
        ..lineTo(-300, 0); // Move left

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();

    return Obx(() {
      final isActive = controller.currentPage.value == pageIndex;

      return Stack(
        children: [
          /// Background Image
          Positioned.fill(
            child: Image.asset('assets/images/w3.png', fit: BoxFit.cover),
          ),

          /// Title (Animated only when active)
          if (isActive)
            Positioned(
              top: 100.h,
              left: 35.w,
              child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 60.sp,
                        height: 1.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            offset: const Offset(2, 2),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      children: [
                        // TextSpan(
                        //   text: 'Physiotherapy',
                        //   style: TextStyle(
                        //     fontSize: 35.sp,
                        //     fontWeight: FontWeight.bold,
                        //     color: Colors.white,

                        //     // letterSpacing: 1.5,
                        //   ),
                        // ),
                        // TextSpan(
                        //   text: '\n  beyond service',
                        //   style: TextStyle(
                        //     fontSize: 40.sp,
                        //     fontWeight: FontWeight.w500,
                        //     color: Colors.white.withValues(alpha: 0.7),
                        //   ),
                        // ),
                        // TextSpan(
                        //   text: 'Service',
                        //   style: TextStyle(
                        //     fontSize:50.sp,
                        //     fontWeight: FontWeight.w600,
                        //     color: Colors.white.withValues(alpha: 0.75),
                        //   ),
                        // ),
                      ],
                    ),
                    textAlign: TextAlign.left,
                  )
                  .animate(onPlay: (controller) => controller.forward(from: 0))
                  .fade(duration: Duration(seconds: 1)),
            ),

          /// Glassmorphic Description Box
          Positioned(
            left: 35,
            right: 35,
            bottom: 120,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  height: 110.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.05),
                        blurRadius: 20,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "From physiotherapy to nursing and more — schedule services with just a few taps.",
                        style: TextStyle(
                          fontSize: 17.sp,
                          color: Colors.white,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
