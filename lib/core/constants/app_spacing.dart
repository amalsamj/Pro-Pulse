import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSpacing {
  AppSpacing._();

  static double get xxs => 2.r;
  static double get xs => 4.r;
  static double get sm => 6.r;
  static double get md => 8.r;
  static double get lg => 10.r;
  static double get xl => 12.r;
  static double get xxl => 14.r;
  static double get section => 15.r;
  static double get card => 16.r;
  static double get large => 18.r;
  static double get extraLarge => 20.r;
  static double get gutter => 24.r;

  static SizedBox height(double value) => SizedBox(height: value.h);
  static SizedBox width(double value) => SizedBox(width: value.w);

  static SizedBox get h2 => SizedBox(height: 2.h);
  static SizedBox get h4 => SizedBox(height: 4.h);
  static SizedBox get h6 => SizedBox(height: 6.h);
  static SizedBox get h8 => SizedBox(height: 8.h);
  static SizedBox get h10 => SizedBox(height: 10.h);
  static SizedBox get h12 => SizedBox(height: 12.h);
  static SizedBox get h14 => SizedBox(height: 14.h);
  static SizedBox get h15 => SizedBox(height: 15.h);
  static SizedBox get h16 => SizedBox(height: 16.h);
  static SizedBox get h18 => SizedBox(height: 18.h);
  static SizedBox get h20 => SizedBox(height: 20.h);
  static SizedBox get h24 => SizedBox(height: 24.h);

  static SizedBox get w4 => SizedBox(width: 4.w);
  static SizedBox get w6 => SizedBox(width: 6.w);
  static SizedBox get w8 => SizedBox(width: 8.w);
  static SizedBox get w10 => SizedBox(width: 10.w);
  static SizedBox get w12 => SizedBox(width: 12.w);
  static SizedBox get w15 => SizedBox(width: 15.w);
  static SizedBox get w20 => SizedBox(width: 20.w);
  static SizedBox get w24 => SizedBox(width: 24.w);
}
