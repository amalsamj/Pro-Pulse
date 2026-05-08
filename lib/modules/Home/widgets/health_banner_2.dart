import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_text_styles.dart';

class HealthBanner2 extends StatelessWidget {
  const HealthBanner2({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // Allow image to overflow outside the container
      children: [
        // Main banner card
        Container(
          height: 120.h,
          width: double.infinity,
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            children: [
              // Text Section
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Be a PULSE PARTNER!",
                      style: AppTextStyles.heading(
                        size: 18.sp,
                        weight: FontWeight.w600,
                        color: Colors.blue.shade900,
                      ),
                    ),

                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Text(
                          "Download Now !",
                          style: AppTextStyles.label(
                            size: 13.sp,
                            color: Colors.grey.shade800,
                            weight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 20.w),
                        // Play Store icon
                        Image.asset(
                          'assets/images/play.png', // Your play store icon
                          height: 26.h,
                        ),
                        SizedBox(width: 6.w),

                        // App Store icon
                        Image.asset(
                          'assets/images/appstore.png', // Your app store icon
                          height: 32.h,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),

        // Doctor Image - positioned to pop out
        Positioned(
          top: -20.h, // Lifts image above the container
          right: -10.w, // Pushes image beyond the right edge
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Image.asset(
              'assets/images/avatar.png',
              height: 140.h,
              width: 140.w,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
