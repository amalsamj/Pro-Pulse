import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pro_pulse_medical_app/core/widgets/keyboard_dismiss.dart';
import '../../../core/constants/app_colors.dart';
import '../../Home/service/controller/service_controller.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

import '../controller/booking_controller.dart';
import '../widgets/booking_appbar.dart';
import '../widgets/booking_widgets.dart';

class Patient {
  final String name, age, aadhaar, gender, history, medicines;

  Patient({
    required this.name,
    required this.age,
    required this.aadhaar,
    required this.gender,
    required this.history,
    required this.medicines,
  });
}

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingController>(
      initState: (_) {
        final String title = Get.arguments?['title'] ?? '';
        final String selectedCategory = Get.arguments?['category'] ?? '';
        final serviceController = ServiceController.to;

        serviceController.selectService(title);
        if (selectedCategory.isNotEmpty) {
          serviceController.selectCategory(selectedCategory);
          serviceController.updateSubcategories();
        }
      },
      builder: (controller) {
        final String title = Get.arguments?['title'] ?? '';
        final String selectedCategory = Get.arguments?['category'] ?? '';

        return KeyboardDismisser(
          child: Scaffold(
            backgroundColor: const Color(0xFFF6F8FB),
            extendBodyBehindAppBar: true,
            appBar: CustomBackAppBar(
              backgroundColor: const Color(0xFFF6F8FB),
              iconColor: Colors.black54,
              onBack: () => Get.back(),
              title: title,
              elevation: 0,
            ),
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final minTabHeight = 360.h;
                  final maxTabHeight =
                      0.78.sh < minTabHeight ? minTabHeight : 0.78.sh;
                  final tabViewHeight =
                      (constraints.maxHeight - 132.h)
                          .clamp(minTabHeight, maxTabHeight)
                          .toDouble();

                  return NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (scrollNotification is UserScrollNotification &&
                          scrollNotification.metrics.axis == Axis.vertical &&
                          scrollNotification.direction ==
                              ScrollDirection.reverse &&
                          !controller.isCollapsedByScroll.value) {
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          controller.isCollapsedByScroll.value = true;
                          controller.update();
                        });
                      }
                      return false;
                    },
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 15.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const PatientWidget(),
                            SizedBox(height: 6.h),
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(14.r),
                                bottomRight: Radius.circular(14.r),
                              ),
                              child: Material(
                                color: Colors.white,
                                elevation: 1,
                                child: TabBar(
                                  controller: controller.tabController,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  labelStyle: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                    letterSpacing: 1.2,
                                  ),
                                  tabs: const [
                                    Tab(text: "Single Booking"),
                                    Tab(text: "Bulk Booking"),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: tabViewHeight,
                              child: TabBarView(
                                controller: controller.tabController,
                                physics: const BouncingScrollPhysics(),
                                children: [
                                  SingleBookingWidget(
                                    title: title,
                                    category: selectedCategory,
                                  ),
                                  const BulkBookingWidget(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class PlainInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final bool readOnly;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final String? suffixText;
  final Widget? prefix;
  final Widget? suffixIcon;
  final int? maxLength;
  final int? maxLine;
  final List<TextInputFormatter>? inputFormatters;

  const PlainInputField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.onChanged,
    this.readOnly = false,
    this.focusNode,
    this.onTap,
    this.suffixText,
    this.prefix,
    this.suffixIcon,
    this.maxLength,
    this.inputFormatters,
    this.maxLine,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLength: maxLength,
      maxLines: maxLine,
      focusNode: focusNode,
      onTap: onTap,
      readOnly: readOnly,
      onChanged: onChanged,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.done,
      enableInteractiveSelection: false,
      inputFormatters: inputFormatters,
      style: TextStyle(fontSize: 16.sp),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 16.sp, color: Colors.grey.shade500),
        prefixIcon: prefix,
        suffixIcon: suffixIcon,
        suffixText: suffixText,
        suffixStyle: TextStyle(
          fontSize: 12.sp,
          color: Colors.black.withValues(alpha: 0.3),
        ),
        counterText: '',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: Colors.white),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
      ),
    );
  }
}

class BookingFormFields extends StatelessWidget {
  final BookingController controller;
  final String title;

  const BookingFormFields({
    super.key,
    required this.controller,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final locationFocus = FocusNode();
    final altPhoneFocus = FocusNode();

    controller.collapsePatientOnFieldFocus(locationFocus);
    controller.collapsePatientOnFieldFocus(altPhoneFocus);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const GlassCategoryDropdown(),
        SizedBox(height: 10.h),
        const MultiDropdownWidget(),
        SizedBox(height: 10.h),
        PlainInputField(
          controller: controller.locationController,
          focusNode: locationFocus,
          hintText: "Location",
        ),
        SizedBox(height: 10.h),
        PlainInputField(
          controller: controller.altPhoneController,
          focusNode: altPhoneFocus,
          hintText: "Alternative Phone Number",
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 10.h),
        Obx(() {
          return GestureDetector(
            onTap: controller.pickAndUploadPrescription,
            child: AbsorbPointer(
              child: PlainInputField(
                controller: TextEditingController(
                  text:
                      controller.isPrescriptionUploaded.value
                          ? 'Prescription Uploaded'
                          : '',
                ),
                hintText:
                    controller.isPrescriptionUploaded.value
                        ? 'Prescription Uploaded'
                        : 'Upload Prescription',
                readOnly: true,
                suffixIcon:
                    controller.isUploadingPrescription.value
                        ? SizedBox(
                          width: 44.w,
                          height: 44.w,
                          child: Padding(
                            padding: EdgeInsets.all(12.r),
                            child: CircularProgressIndicator(strokeWidth: 2.r),
                          ),
                        )
                        : controller.isPrescriptionUploaded.value
                        ? Icon(
                          Iconsax.tick_circle_bold,
                          color: AppColors.primary,
                          size: 22.sp,
                        )
                        : Icon(
                          Iconsax.document_upload_bold,
                          color: Colors.black54,
                          size: 22.sp,
                        ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class GlassCategoryDropdown extends StatelessWidget {
  const GlassCategoryDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final categories = ServiceController.to.getCategories(
        ServiceController.to.selectedService.value,
      );
      final selectedCategory = ServiceController.to.selectedCategory.value;

      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 13.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              barrierColor: Colors.black45,
              builder:
                  (_) => Dialog(
                    backgroundColor: Colors.transparent,
                    insetPadding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 80.h,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          padding: EdgeInsets.all(16.r),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: categories.length,
                            separatorBuilder:
                                (_, __) => const Divider(color: Colors.white24),
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              final isSelected = category == selectedCategory;

                              return GestureDetector(
                                onTap: () {
                                  ServiceController.to.selectedCategory.value =
                                      category;
                                  ServiceController.to.updateSubcategories();
                                  ServiceController.to.selectedSubcategories
                                      .clear();
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 12.h,
                                    horizontal: 8.w,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Text(
                                    category,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.white,
                                      fontWeight:
                                          isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
            );
          },
          child: Text(
            selectedCategory.isEmpty ? "Select Category" : selectedCategory,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16.sp,
              color:
                  selectedCategory.isEmpty
                      ? Colors.grey.shade500
                      : Colors.black,
            ),
          ),
        ),
      );
    });
  }
}
