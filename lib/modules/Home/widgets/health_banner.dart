import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HealthBanner extends StatelessWidget {
  const HealthBanner({super.key});

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
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Take care for your health",
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Fill out your medical card right now.",
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade800),
                    ),
                    SizedBox(height: 4.h),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.withValues(alpha: 0.7),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      ),
                      child: Text("Book Now", style: TextStyle(fontSize: 12.sp,color: Colors.white)),
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
          right: 0.w,
          top: -25.h, // Move image out of the container
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Image.asset(
              'assets/banner6.png', // Replace with doctor image
              height: 130.h,
              width: 120.w,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}


