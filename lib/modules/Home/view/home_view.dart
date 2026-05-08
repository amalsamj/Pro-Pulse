import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pro_pulse_medical_app/core/core_export.dart';
import 'package:pro_pulse_medical_app/core/widgets/pulse_loader.dart';
import '../../../core/constants/app_colors.dart';
import '../controller/home_controller.dart' show HomeController;
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final controller = HomeController.to;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF6F8FB),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: AppLoader());
        }

        final index = controller.selectedIndex.value;
        final isHome = index == 0;

        return SafeArea(
          top: !isHome,
          bottom: false,
          child: controller.pages[index],
        );
      }),
      bottomNavigationBar: Obx(
        () =>
            controller.isLoading.value
                ? const SizedBox.shrink()
                : SafeArea(
                  top: false,
                  left: false,
                  right: false,
                  minimum: EdgeInsets.zero,
                  child: Container(
                    width: double.infinity,
                    height: 68.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: BottomNavigationBar(
                      currentIndex: controller.selectedIndex.value,
                      onTap: controller.changeTab,
                      type: BottomNavigationBarType.fixed,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      selectedItemColor: AppColors.primary,
                      unselectedItemColor: AppColors.textSecondary.withValues(
                        alpha: 0.65,
                      ),
                      showSelectedLabels: false,
                      showUnselectedLabels: false,
                      items: List.generate(
                        controller.icons.length,
                        (index) => BottomNavigationBarItem(
                          icon:
                              controller.selectedIndex.value == index
                                  ? SizedBox(
                                    height: 24.r,
                                    child: Center(
                                      child: Text(
                                        controller.labels[index].tr,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  )
                                  : Icon(controller.icons[index], size: 24.r),
                          label: '',
                        ),
                      ),
                    ),
                  ),
                ),
      ),
    );
  }
}
