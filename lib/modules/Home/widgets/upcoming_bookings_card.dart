import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:get/get.dart';

class UpcomingBookingsCard extends StatelessWidget {
  const UpcomingBookingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final booking = {
      'serviceName': 'book_service_general',
      'date': 'Mar 16, 2026',
      'time': '2:30 PM',
      'status': 'book_status_confirmed',
      'price': '\$120',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'upcoming_bookings_title'.tr,
          style: AppTextStyles.title(
            size: 16.sp,
            weight: FontWeight.w700,
            color: AppColors.darkText,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.secondary.withValues(alpha: 0.12),
                AppColors.white,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: Icon(
                        Iconsax.calendar_1_outline,
                        color: AppColors.secondary,
                        size: 24.r,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (booking['serviceName'] as String).tr,
                          style: AppTextStyles.title(
                            size: 14.sp,
                            weight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          booking['price'] as String,
                          style: AppTextStyles.title(
                            size: 12.sp,
                            weight: FontWeight.w700,
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: Text(
                      (booking['status'] as String).tr,
                      style: AppTextStyles.outfit(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  _InfoChip(
                    icon: Iconsax.calendar_outline,
                    label: 'book_label_date'.tr,
                    value: booking['date'] as String,
                  ),
                  _InfoChip(
                    icon: Iconsax.clock_outline,
                    label: 'book_label_time'.tr,
                    value: booking['time'] as String,
                  ),
                  _InfoChip(
                    icon: Iconsax.document_text_outline,
                    label: 'book_label_service'.tr,
                    value: (booking['serviceName'] as String).tr,
                  ),
                  _InfoChip(
                    icon: Iconsax.verify_outline,
                    label: 'book_label_status'.tr,
                    value: (booking['status'] as String).tr,
                  ),
                  _InfoChip(
                    icon: Iconsax.wallet_2_outline,
                    label: 'book_label_price'.tr,
                    value: booking['price'] as String,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.r, color: AppColors.textSecondary),
          SizedBox(width: 6.w),
          Text(
            '$label: $value',
            style: AppTextStyles.outfit(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
