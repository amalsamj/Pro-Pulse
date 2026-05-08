// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:pro_pulse_medical_app/core/constants/app_colors.dart';
import 'package:pro_pulse_medical_app/core/constants/app_spacing.dart';
import 'package:pro_pulse_medical_app/core/constants/app_text_styles.dart';
import 'package:pro_pulse_medical_app/core/widgets/app_button.dart';
import 'package:pro_pulse_medical_app/core/widgets/keyboard_dismiss.dart';
import 'package:pro_pulse_medical_app/modules/auth/signup/controller/signup_controller.dart';
import '../../widgets/glass_input_field.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("Mobile: ${controller.mobileController.text}");
    debugPrint("Form is valid: ${controller.isFormValid.value}");

    return KeyboardDismisser(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15.h),
                child: Center(
                  child: Text(
                    "Create Account",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.authHeader().copyWith(
                      color: AppColors.primary,
                      fontSize: 25.sp,
                    ),
                  ),
                ),
              ),

              AppSpacing.h18,

              Expanded(
                child: SingleChildScrollView(
                  controller: controller.scrollController,
                  padding: EdgeInsets.only(
                    left: 24.w,
                    right: 24.w,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 30.h,
                  ),
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 20.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GlassInputField(
                              controller: controller.fullNameController,
                              hintText: "Full Name",
                              focusNode: controller.fullNameFocus,
                              suffixIcon: Icon(
                                Iconsax.user_bold,
                                color: Colors.black54,
                                size: 20.sp,
                              ),
                              onTap:
                                  () => controller.scrollToFocusedField(
                                    controller.fullNameFocus,
                                  ),
                              onChanged: (_) => controller.validateForm(),
                            ),

                            AppSpacing.h10,

                            GlassDOBField(
                              controller: controller.dobController,
                              hint: "Date of Birth",
                              suffixIcon: Icon(
                                Iconsax.calendar_bold,
                                color: Colors.black54,
                                size: 20.sp,
                              ),
                              onTap: () => controller.pickDateOfBirth(context),
                            ),

                            AppSpacing.h10,

                            GlassInputField(
                              controller: controller.mobileController,
                              onChanged: (_) => controller.validateForm(),
                              hintText: "Mobile Number",
                              readOnly: false,
                              maxLength: 10,
                              keyboardType: TextInputType.phone,
                              suffixIcon: Icon(
                                Iconsax.mobile_bold,
                                color: Colors.black54,
                                size: 20.sp,
                              ),
                              prefix: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "+91",
                                    style: AppTextStyles.authInput(
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  AppSpacing.w12,
                                  Container(
                                    height: 20.h,
                                    width: 1,
                                    color: Colors.black.withValues(alpha: 0.5),
                                  ),
                                  AppSpacing.w6,
                                ],
                              ),
                            ),

                            AppSpacing.h10,

                            GlassInputField(
                              controller: controller.emailController,
                              hintText: "Email",
                              focusNode: controller.emailFocus,
                              suffixIcon: Icon(
                                HeroIcons.envelope,
                                color: Colors.black54,
                                size: 20.sp,
                              ),
                              onTap:
                                  () => controller.scrollToFocusedField(
                                    controller.emailFocus,
                                  ),
                              onChanged: (_) => controller.validateForm(),
                            ),

                            AppSpacing.h10,

                            GlassInputField(
                              controller: controller.addressLine1Controller,
                              hintText: "Address Line",
                              focusNode: controller.addressLine1Focus,
                              suffixIcon: Icon(
                                Iconsax.personalcard_bold,
                                color: Colors.black54,
                                size: 20.sp,
                              ),
                              onTap:
                                  () => controller.scrollToFocusedField(
                                    controller.addressLine1Focus,
                                  ),
                              onChanged: (_) => controller.validateForm(),
                            ),

                            AppSpacing.h10,

                            GlassInputField(
                              controller: controller.addressLine2Controller,
                              hintText: "Landmark",
                              focusNode: controller.addressLine2Focus,
                              suffixIcon: Icon(
                                Iconsax.personalcard_bold,
                                color: Colors.black54,
                                size: 20.sp,
                              ),
                              onTap:
                                  () => controller.scrollToFocusedField(
                                    controller.addressLine2Focus,
                                  ),
                              onChanged: (_) => controller.validateForm(),
                            ),

                            AppSpacing.h10,

                            GlassInputField(
                              controller: controller.pincodeController,
                              hintText: "Pincode",
                              maxLength: 6,
                              keyboardType: TextInputType.number,
                              focusNode: controller.pincodeFocus,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              suffixIcon: Icon(
                                Iconsax.location_bold,
                                color: Colors.black54,
                                size: 20.sp,
                              ),
                              onTap:
                                  () => controller.scrollToFocusedField(
                                    controller.pincodeFocus,
                                  ),
                              onChanged:
                                  (value) => controller.fetchCityState(value),
                            ),

                            AppSpacing.h12,

                            Obx(
                              () => Row(
                                children: [
                                  Expanded(
                                    child: GlassReadonlyField(
                                      label: "Post Office",
                                      value: controller.postOffice.value,
                                    ),
                                  ),
                                  AppSpacing.w10,
                                  Expanded(
                                    child: GlassReadonlyField(
                                      label: "District",
                                      value: controller.city.value,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            AppSpacing.h10,

                            Obx(
                              () => GlassReadonlyField(
                                label: "State",
                                value: controller.state.value,
                                width: double.infinity,
                              ),
                            ),

                            AppSpacing.h10,

                            Obx(
                              () => AppButton(
                                label: "REGISTER",
                                isEnabled: controller.isFormValid.value,
                                onPressed: controller.submitForm,
                              ),
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .fade(
                        duration: const Duration(seconds: 2),
                        begin: 0,
                        end: 1,
                      )
                      .slide(
                        duration: const Duration(seconds: 1),
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                        curve: Curves.easeOut,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
