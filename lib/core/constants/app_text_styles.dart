import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle outfit({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
    Color? decorationColor,
    List<Shadow>? shadows,
  }) {
    return GoogleFonts.outfit(
      textStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
        decoration: decoration,
        decorationColor: decorationColor,
        shadows: shadows,
      ),
    );
  }

  @Deprecated('Use outfit(). The app uses Outfit as the only font.')
  static TextStyle inter({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
  }) {
    return outfit(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  @Deprecated('Use outfit(). The app uses Outfit as the only font.')
  static TextStyle lato({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
  }) {
    return outfit(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  static TextStyle heading({
    required double size,
    FontWeight weight = FontWeight.w700,
    Color color = const Color(0xFF1F2D3D),
    double? height = 1.12,
  }) {
    return outfit(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
    );
  }

  static TextStyle title({
    required double size,
    FontWeight weight = FontWeight.w600,
    Color color = const Color(0xFF1F2D3D),
    double? height = 1.2,
  }) {
    return outfit(
      fontSize: size.sp,
      fontWeight: weight,
      color: color,
      height: height,
    );
  }

  static TextStyle body({
    required double size,
    FontWeight weight = FontWeight.w400,
    Color color = const Color(0xFF5A6B7D),
    double? height,
  }) {
    return outfit(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
    );
  }

  static TextStyle label({
    required double size,
    FontWeight weight = FontWeight.w500,
    Color color = const Color(0xFF5A6B7D),
    double? height,
  }) {
    return outfit(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
    );
  }

  static TextStyle caption({
    required double size,
    FontWeight weight = FontWeight.w500,
    Color color = const Color(0xFF5A6B7D),
    double? height,
  }) {
    return outfit(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
    );
  }

  static TextStyle authHero({double size = 35, Color color = Colors.white}) {
    return outfit(
      fontSize: size.sp,
      fontWeight: FontWeight.w600,
      color: color.withValues(alpha: 0.95),
      shadows: [
        Shadow(
          color: Colors.black.withValues(alpha: 0.3),
          offset: const Offset(1, 1),
          blurRadius: 4,
        ),
      ],
    );
  }

  static TextStyle authTitle({double size = 20}) {
    return outfit(
      fontSize: size.sp,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      letterSpacing: 1.0,
    );
  }

  static TextStyle authHeader({double size = 32}) {
    return outfit(
      fontSize: size.sp,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
  }

  static TextStyle authInput({
    double size = 16,
    double letterSpacing = 1.0,
    Color color = Colors.black,
  }) {
    return outfit(
      color: color,
      fontSize: size.sp,
      fontWeight: FontWeight.w500,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle authHint({double size = 16}) {
    return outfit(
      color: Colors.blueGrey.withValues(alpha: 0.3),
      fontSize: size.sp,
    );
  }

  static TextStyle authButton({double size = 16}) {
    return outfit(
      color: Colors.white,
      fontSize: size.sp,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle authBody({double size = 14, Color color = Colors.white70}) {
    return outfit(color: color, fontSize: size.sp, fontWeight: FontWeight.w500);
  }

  static TextStyle authLink({double size = 14}) {
    return outfit(
      color: Colors.white,
      fontSize: size.sp,
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.underline,
      decorationColor: Colors.white,
    );
  }

  static TextStyle otpMessage({double size = 18}) {
    return outfit(
      fontSize: size.sp,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle pinText({
    double size = 22,
    FontWeight weight = FontWeight.w600,
  }) {
    return outfit(fontSize: size.sp, color: Colors.white, fontWeight: weight);
  }

  static TextStyle primaryTitle({double size = 22}) {
    return outfit(
      color: AppColors.primary,
      fontSize: size.sp,
      fontWeight: FontWeight.bold,
    );
  }
}
