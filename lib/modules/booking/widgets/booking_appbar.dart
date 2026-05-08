import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../../core/constants/app_colors.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback? onBack;
  final double elevation;
  final String? title; // 👈 new
  final TextStyle? titleTextStyle; // 👈 optional custom style

  const CustomBackAppBar({
    super.key,
    this.backgroundColor = const Color(0xFFF5F5F5),
    this.iconColor = Colors.black54,
    this.onBack,
    this.elevation = 0,
    this.title, // 👈 add
    this.titleTextStyle, // 👈 add
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: elevation,
      toolbarHeight: 50.0,
      scrolledUnderElevation: 0,
      foregroundColor: Colors.transparent,
      centerTitle: false, // 👈 center the title
      title:
          title != null
              ? Text(
                title!,
                style:
                    titleTextStyle ??
                    TextStyle(
                      color: AppColors.accent,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
              )
              : null,
      leadingWidth: 70,

      leading: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onBack ?? () => Get.back(),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Iconsax.arrow_left_outline,
                color: AppColors.accent,
                size: 22.r,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
