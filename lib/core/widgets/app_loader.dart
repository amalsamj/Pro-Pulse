import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({
    super.key,
    this.size = 150,
    this.backgroundColor = Colors.white,
    this.loaderColor = const Color(0xFFFF375F),
  });

  final double size;
  final Color backgroundColor;
  final Color loaderColor;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor,
      child: Center(
        child: Lottie.asset(
          'assets/images/loader.json',
          width: size.w,
          height: size.h,
          fit: BoxFit.contain,
          repeat: true,

          delegates: LottieDelegates(
            values: [
              ValueDelegate.color(const [
                '**',
                'Fill 1',
              ], value: const Color(0xFFFF375F)),
              ValueDelegate.color(const [
                '**',
                'Stroke 1',
              ], value: const Color(0xFFFF375F)),
              ValueDelegate.color(const ['**'], value: const Color(0xFFFF375F)),
            ],
          ),
        ),
      ),
    );
  }
}
