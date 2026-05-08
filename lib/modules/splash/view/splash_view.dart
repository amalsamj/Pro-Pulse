import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pro_pulse_medical_app/modules/splash/controller/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: AnimatedBuilder(
        animation: controller.animationController,
        builder: (context, _) {
          return CustomPaint(
            painter: DiagonalFillPainter(
              progress: controller.animationController.value,
            ),
            child: Center(
              child: Obx(
                () => AnimatedOpacity(
                  opacity: controller.fadeIn.value ? 1.0 : 0.0,
                  duration: const Duration(seconds: 3),
                  child: SafeArea(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/images/logo.jpeg",
                              width: 300.w,
                              height: 300.h,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class DiagonalFillPainter extends CustomPainter {
  final double progress;

  DiagonalFillPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [Colors.white, Colors.white],
            stops: [
              (progress - 0.2).clamp(0.0, 1.0),
              (progress + 0.2).clamp(0.0, 1.0),
            ],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant DiagonalFillPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
