import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_pulse_medical_app/core/constants/app_colors.dart';

abstract class AppTheme {
  static ThemeData light(BuildContext context) {
    final outfitTextTheme = GoogleFonts.outfitTextTheme(
      Theme.of(context).textTheme,
    );

    return ThemeData(
      scaffoldBackgroundColor: const Color(0xFFF6F8FB),
      fontFamily: GoogleFonts.outfit().fontFamily,
      textTheme: outfitTextTheme,
      primaryTextTheme: outfitTextTheme,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      useMaterial3: true,
    );
  }
}
