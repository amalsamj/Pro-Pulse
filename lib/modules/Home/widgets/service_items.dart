// widgets/glass_tile_item.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';












class ParallaxCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final double offset;

  const ParallaxCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.offset,
  });

  @override
  Widget build(BuildContext context) {
    final double scale = (1 - (offset.abs() * 0.1)).clamp(0.9, 1.0);

    return Transform.scale(
      scale: scale,
      child: Container(
        width: 0.8.sw,
        margin: EdgeInsets.symmetric(horizontal: 8.w),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Parallax background image
            Positioned.fill(
              child: FractionalTranslation(
                translation: Offset(offset * 0.3, 0),
                child: // Hero animation
                Hero(
                  tag: imagePath, // Use a unique tag like image path
                  child: FractionalTranslation(
                    translation: Offset(offset * 0.3, 0),
              child: AspectRatio(
                    aspectRatio: 9 / 1,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          imagePath,
                          fit: BoxFit.fitWidth,
                          errorBuilder: (_, __, ___) => Center(
                            child: Lottie.asset('assets/placeholder.json'),
                          ),
                        ),

                        // 🔹 Top blur overlay

                      ],
                    ),
                  ),


                ),
                ),


              ),
            ),

            // Gradient overlay for readability
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withValues(alpha: 0.5), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),

            // Text
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 60.h, // fixed height
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.r),
                    bottomRight: Radius.circular(20.r),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        border: Border(
                          top: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Hero(
                                  tag: 'title-$title',
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Text(
                                      title,
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                // SizedBox(height: 2.h),
                                Hero(
                                  tag: 'subtitle-$title',
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Text(
                                      subtitle,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
}








