import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // 🌟 Primary Medical Branding Colors
  // static const Color primary = Color(0xFF1E6F9F);        // Primary Blue
  // static const Color secondary = Color(0xFF1E6F9F);      // Secondary Blue
  // static const Color accent = Color(0xFFE53935);         // Medical Red Accent
  // static const Color light = Color(0xFFF5F7FA);   

    static const Color primary = Color(0xFF3555ce);        // Primary Blue
  static const Color secondary = Color(0xFF1E6F9F);      // Secondary Blue
  static const Color accent = Color(0xFFcc3c17);         // Medical Red Accent
  static const Color light = Color(0xFFF5F7FA);   
  
      // Background Light

  // 🧊 Glass Layer Colors
  static const Color glassWhite = Color.fromRGBO(92, 35, 35, 0.149);
  static const Color glassBorder = Color.fromRGBO(255, 255, 255, 0.3);
  static const Color glassFill = Color.fromRGBO(255, 255, 255, 0.05);

  // 🩺 Text Colors
  static const Color textPrimary = Color(0xFF1F2D3D);    // Dark Text
  static const Color darkText = textPrimary;              // alias for clarity
  static const Color textSecondary = Color(0xFF5A6B7D); // Muted Dark Text
  static const Color white = Color(0xFFFFFFFF);          // White

  // 🔲 Background Colors
  static const Color backgroundDark = Color(0xFF0F3D56); // Primary Blue Dark
  static const Color backgroundLight = Color(0xFFF5F7FA); // Light Background

  // ✅ Success & Error
  static const Color success = Color(0xFF43A047);
  static const Color error = Color(0xFFE53935);          // Medical Red

  // ⚫️ Dots / Indicators
  static const Color dotActive = Color(0xFF0F3D56);
  static const Color dotInactive = Color(0xFFBFC9D4);
}

