import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_pulse_medical_app/core/widgets/app_button.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../controller/landing_controller.dart';

class LandingView extends GetView<LandingController> {
  const LandingView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final safeHeight = screenHeight - MediaQuery.paddingOf(context).vertical;
    final isShortScreen = screenHeight < 720;

    final topGap = isShortScreen ? 20.0 : 34.0;
    final logoSize = isShortScreen ? 100.0 : 120.0;
    final logoToHeroGap = isShortScreen ? 12.0 : 18.0;
    final heroToActionsGap = isShortScreen ? 44.0 : 130.0;
    final actionToButtonGap = isShortScreen ? 22.0 : 28.0;
    final buttonGap = isShortScreen ? 14.0 : 18.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: safeHeight),
            child: Padding(
              padding: EdgeInsets.fromLTRB(30.w, 0, 30.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSpacing.height(topGap),

                  Image.asset(
                    'assets/images/logo.jpeg',
                    width: logoSize.w,
                    height: logoSize.w,
                    fit: BoxFit.contain,
                  ),

                  AppSpacing.height(logoToHeroGap),

                  const HeroChangingText(),

                  AppSpacing.height(heroToActionsGap),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => SizedBox(
                          width: 30.w,
                          height: 30.w,
                          child: Checkbox(
                            value: controller.hasAcceptedTerms.value,
                            onChanged: controller.toggleTerms,
                            activeColor: AppColors.primary,
                            checkColor: Colors.white,
                            side: BorderSide(
                              color: const Color(0xFFD8D8DC),
                              width: 1.5.w,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: const VisualDensity(
                              horizontal: -4,
                              vertical: -4,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 8.w),

                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 2.h),
                          child: Text.rich(
                            TextSpan(
                              style: AppTextStyles.outfit(
                                fontSize: isShortScreen ? 13.5.sp : 14.5.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF1F2020),
                                height: 1.35,
                              ),
                              children: [
                                const TextSpan(text: 'I agree to the '),
                                _linkSpan('Terms & Conditions', isShortScreen),
                                const TextSpan(text: ' and '),
                                _linkSpan('Privacy Policy', isShortScreen),
                              ],
                            ),
                            textAlign: TextAlign.left,
                            softWrap: true,
                          ),
                        ),
                      ),
                    ],
                  ),

                  AppSpacing.height(actionToButtonGap),

                  Obx(
                    () => AppButton(
                      label: 'SIGN UP',
                      onPressed: () => Get.toNamed(Routes.signup),
                      isEnabled: controller.hasAcceptedTerms.value,
                      height: 58,
                    ),
                  ),

                  AppSpacing.height(buttonGap),

                  Obx(
                    () => AppButton(
                      label: 'LOG IN',
                      onPressed: () => Get.toNamed(Routes.login),
                      isEnabled: controller.hasAcceptedTerms.value,
                      height: 58,
                      isOutlined: true,
                    ),
                  ),

                  AppSpacing.height(8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextSpan _linkSpan(String text, bool isShortScreen) {
    return TextSpan(
      text: text,
      style: AppTextStyles.outfit(
        fontSize: isShortScreen ? 13.5.sp : 14.5.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
        height: 1.35,
      ),
    );
  }
}

class HeroChangingText extends StatefulWidget {
  const HeroChangingText({super.key});

  @override
  State<HeroChangingText> createState() => _HeroChangingTextState();
}

class _HeroChangingTextState extends State<HeroChangingText> {
  final List<String> services = [
    'Pulmo Rehab.',
    'Physiotherapy.',
    'Pain Relief.',
    'Neuro Rehab.',
    'Ortho Rehab.',
    'Home Care.',
  ];

  int index = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 3), (_) {
      setState(() {
        index = (index + 1) % services.length;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isShortScreen = MediaQuery.sizeOf(context).height < 720;

    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        style: GoogleFonts.outfit(
          fontSize: isShortScreen ? 28.sp : 32.sp,
          height: 1.42,
          fontWeight: FontWeight.w500,
          color: Colors.black,
          letterSpacing: -0.4,
        ),
        children: [
          const TextSpan(text: 'Get specialised care for '),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 450),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.4),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: Text(
                services[index],
                key: ValueKey(services[index]),
                style: GoogleFonts.outfit(
                  fontSize: isShortScreen ? 30.sp : 35.sp,
                  height: 1.15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
