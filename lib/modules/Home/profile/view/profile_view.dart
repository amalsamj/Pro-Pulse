import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pro_pulse_medical_app/app/localization/language_controller.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../app/routes/app_routes.dart';
import 'package:get/get.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: const Color(0xFFF6F8FB),
      //   centerTitle: true,

      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 20.h),
          child: Column(
            children: [
              CircleAvatar(
                radius: 48.r,
                backgroundImage: const AssetImage('assets/images/avatar.jpg'),
              ),
              SizedBox(height: 6.h),
              Text(
                'Amal Sam',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '9986043275 | Bengaluru'.tr,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 16.h),
              _buildProfileOption(
                'opt_bookings'.tr,
                Icons.calendar_today_outlined,
              ),
              _buildProfileOption(
                'opt_addresses'.tr,
                Icons.location_on_outlined,
              ),
              _buildProfileOption(
                'opt_notifications'.tr,
                Icons.notifications_none_outlined,
              ),
              _buildProfileOption('opt_settings'.tr, Icons.settings_outlined),
              _buildProfileOption(
                'opt_language'.tr,
                Icons.language_rounded,
                onTap: () => _openLanguageSheet(context),
              ),
              _buildProfileOption('opt_help'.tr, Icons.help_outline_rounded),
              _buildProfileOption(
                'opt_logout'.tr,
                Icons.logout_rounded,
                isLogout: true,
                onTap: () => Get.offAllNamed(Routes.login),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(
    String title,
    IconData icon, {
    bool isLogout = false,
    VoidCallback? onTap,
  }) {
    final iconColor = isLogout ? Colors.redAccent : AppColors.backgroundDark;

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: ListTile(
          leading: Icon(icon, color: iconColor),
          title: Text(
            title,
            style: TextStyle(
              color: iconColor,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16.r,
            color: AppColors.textSecondary,
          ),
          onTap: onTap ?? () {},
        ),
      ),
    );
  }

  void _openLanguageSheet(BuildContext context) {
    final languageController = Get.find<LanguageController>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
      ),
      builder: (_) {
        return Obx(
          () => Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'lang_select'.tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 10.h),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text('lang_en'.tr),
                  trailing:
                      languageController.currentLocale.value.languageCode ==
                              'en'
                          ? Icon(
                            Icons.check_circle,
                            color: AppColors.primary,
                            size: 20.r,
                          )
                          : null,
                  onTap: () {
                    languageController.changeLanguage('en');
                    Get.back();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text('lang_kn'.tr),
                  trailing:
                      languageController.currentLocale.value.languageCode ==
                              'kn'
                          ? Icon(
                            Icons.check_circle,
                            color: AppColors.primary,
                            size: 20.r,
                          )
                          : null,
                  onTap: () {
                    languageController.changeLanguage('kn');
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
