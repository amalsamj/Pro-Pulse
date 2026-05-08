import 'dart:async';
import 'dart:ui';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../../core/constants/app_colors.dart';
import '../../Home/service/controller/service_controller.dart';
import '../controller/booking_controller.dart';
import '../view/booking_form.dart';

class PatientWidget extends StatelessWidget {
  const PatientWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingController>();

    return Obx(() {
      final isCollapsed = controller.isCollapsedByScroll.value;
      final isExpanded = controller.isPatientExpanded.value;
      final showExpanded = isExpanded && !isCollapsed;

      return AnimatedCrossFade(
        firstChild: _CollapsedView(),
        secondChild: _ExpandedView(),
        crossFadeState:
            showExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 600),
        firstCurve: Curves.easeInOut,
        secondCurve: Curves.easeInOut,
        sizeCurve: Curves.easeInOut,
      );
    });
  }
}

// ✅ Collapsed version (just header with icon)
class _CollapsedView extends StatelessWidget {
  const _CollapsedView();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingController>();

    return Container(
      height: 50.h,
      padding: EdgeInsets.only(left: 15.w, right: 10.w),
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Text(
            controller.patients[controller.selectedPatient.value]['name'] ??
                'Patients',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),

          const Spacer(),
          IconButton(
            icon: Icon(Icons.expand_more, size: 30.sp, color: Colors.black54),
            onPressed: () {
              controller.isCollapsedByScroll.value =
                  false; // 🧠 force override scroll collapse
              controller.isPatientExpanded.value = true; // 🧠 ensure expansion
              controller.update();
            },
          ),
        ],
      ),
    );
  }
}

class _ExpandedView extends StatelessWidget {
  const _ExpandedView();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingController>();

    return Container(
      padding: EdgeInsets.only(left: 15.w, right: 10.w, bottom: 10.h),
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Patients",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  Icons.expand_less,
                  size: 30.sp,
                  color: Colors.black54,
                ),
                onPressed: () => controller.isPatientExpanded.toggle(),
              ),
            ],
          ),
          const PatientChips(), // ✅ Modular chip widget
          SizedBox(height: 10.h),
          Obx(() {
            final patient =
                controller.patients[controller.selectedPatient.value];
            return Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [BoxShadow(blurRadius: 1.r, color: Colors.black12)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name: ${patient['name']}",
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  Text(
                    "Age: ${patient['age']}",
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  Text(
                    "Aadhaar: ${patient['aadhaar']}",
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  Text(
                    "Gender: ${patient['gender']}",
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  Text(
                    "History: ${patient['history']}",
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  Text(
                    "Medicines: ${patient['medicines']}",
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class PatientChips extends StatelessWidget {
  const PatientChips({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingController>();

    return SizedBox(
      height: 40.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.patients.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 5.w),
            child: Obx(() {
              final isSelected = controller.selectedPatient.value == index;

              return ChoiceChip(
                label: Text(
                  controller.patients[index]['name']!,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
                selected: isSelected,
                selectedColor: AppColors.primary,
                backgroundColor: Colors.white10,
                checkmarkColor: Colors.white,
                onSelected: (_) => controller.selectedPatient.value = index,
              );
            }),
          );
        },
      ),
    );
  }
}

class SingleBookingWidget extends StatelessWidget {
  const SingleBookingWidget({super.key, required this.title, this.category});

  final dynamic title;
  final dynamic category;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingController>();

    // 🧠 Add focus nodes
    // 🧠 Add focus nodes
    final locationFocus = FocusNode();
    final noteFocus = FocusNode();
    final altPhoneFocus = FocusNode();

    // 🔁 Attach listener once
    controller.collapsePatientOnFieldFocus(locationFocus);
    controller.collapsePatientOnFieldFocus(noteFocus);
    controller.collapsePatientOnFieldFocus(altPhoneFocus);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          // padding: EdgeInsets.only(bottom: 30.h),
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // /// EasyDateTimeLine ⏱️
                //      controller.isPatientExpanded.value ?  SizedBox(height: 10,) : SizedBox.shrink(),
                //                   controller.isCollapsedByScroll.value ?  SizedBox(height: 10,) : SizedBox.shrink(),
                if (controller.isPatientExpanded.value) SizedBox(height: 10.h),
                // if (controller.isCollapsedByScroll.value) SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(
                    left: 10.w,
                    bottom: 10.h,
                    right: 10.w,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: EasyDateTimeLine(
                    initialDate: controller.selectedDate.value,
                    onDateChange: (date) {
                      controller.onDateSelected(date);
                      controller.updateFormattedTime(
                        controller.selectedTime.value,
                      );
                    },
                    disabledDates: List.generate(
                      3650,
                      (i) => DateTime.now().subtract(Duration(days: i + 1)),
                    ),
                    headerProps: EasyHeaderProps(
                      padding: EdgeInsets.only(
                        bottom: 6.h,
                        left: 8.w,
                        right: 8.w,
                      ),
                      monthPickerType: MonthPickerType.switcher,
                      selectedDateStyle: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black54,
                      ),
                      monthStyle: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                    dayProps: EasyDayProps(
                      height: 80.h,
                      width: 58.w,
                      inactiveDayStyle: DayStyle(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        dayNumStyle: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        monthStrStyle: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black54,
                        ),
                        dayStrStyle: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black54,
                        ),
                      ),
                      activeDayStyle: DayStyle(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        dayNumStyle: TextStyle(
                          fontSize: 22.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        monthStrStyle: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        dayStrStyle: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10.h),

                /// Time Picker 🕐
                Obx(
                  () => Focus(
                    focusNode: controller.timePickerFocusNode,
                    child: Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 33.h,
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 5.w),
                                  child: Text(
                                    controller.isTimePickerExpanded.value
                                        ? "Select Time"
                                        : (controller.hasSelectedTime.value
                                            ? controller
                                                .formattedSelectedTime
                                                .value
                                            : "Select Time"),
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color:
                                          controller
                                                      .isTimePickerExpanded
                                                      .value ||
                                                  !controller
                                                      .hasSelectedTime
                                                      .value
                                              ? Colors.grey.shade500
                                              : Colors.black,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                SizedBox(
                                  width: 35.w,
                                  height: 33.h,
                                  child: InkWell(
                                    onTap: () {
                                      controller.hasCollapsed = false;
                                      controller.isTimePickerExpanded.toggle();
                                      controller.timePickerFocusNode
                                          .requestFocus();
                                    },
                                    borderRadius: BorderRadius.circular(50.r),
                                    child: Center(
                                      child: Icon(
                                        controller.isTimePickerExpanded.value
                                            ? Iconsax.arrow_circle_up_outline
                                            : Iconsax.arrow_circle_down_outline,
                                        size: 22.sp,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (controller.isTimePickerExpanded.value)
                            Container(
                              padding: EdgeInsets.all(10.r),
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: NotificationListener<ScrollNotification>(
                                onNotification: (notification) {
                                  // Prevent parent scroll when spinner scrolls
                                  return true;
                                },
                                child: SizedBox(
                                  height: 110.h,
                                  child: TimePickerSpinner(
                                    time:
                                        controller
                                            .getInitialDateTimeForPicker(),
                                    is24HourMode: false,
                                    normalTextStyle: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.black45,
                                    ),
                                    highlightedTextStyle: TextStyle(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                    spacing: 50.w,
                                    itemHeight: 40.h,
                                    minutesInterval: 5,
                                    isForce2Digits: true,
                                    alignment: Alignment.center,
                                    onTimeChange: (time) {
                                      final selected = TimeOfDay.fromDateTime(
                                        time,
                                      );

                                      if (controller.isTimeInPast(selected)) {
                                        return;
                                      }

                                      controller.selectedTime.value = selected;
                                      controller.updateFormattedTime(selected);
                                      controller.hasSelectedTime.value = true;

                                      controller.timeUpdateTimer?.cancel();
                                      controller.timeUpdateTimer = Timer(
                                        const Duration(seconds: 30),
                                        () =>
                                            controller
                                                .isTimePickerExpanded
                                                .value = false,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10.h),

                /// 📝 Booking Form
                BookingFormFields(controller: controller, title: "Book Now"),

                SizedBox(height: 20.h),

                /// 🔍 Search Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Booking action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      textStyle: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        wordSpacing: 4,
                      ),
                    ),
                    child: const Text("SEARCH PULSE PARTNER"),
                  ),
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        );
      },
    );
  }
}

class BulkBookingWidget extends StatelessWidget {
  const BulkBookingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingController>();

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          // padding: EdgeInsets.only(bottom: 20.h),
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Obx(() {
                final range = controller.multiBookingDateTimeRange;
                final hasSelected = range.length == 2;

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h),

                      // 📅 Date & Time Picker Button with selected range
                      SizedBox(
                        height: hasSelected ? 90.h : 50.h,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller.showDefaultDateTimeRangePicker(
                              context,
                              (start, end) {
                                controller.multiBookingDateTimeRange.value = [
                                  start,
                                  end,
                                ];
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black87,
                            shadowColor: Colors.transparent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                              side: const BorderSide(color: Colors.white),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 10.h,
                              horizontal: 12.w,
                            ),
                            // textStyle: TextStyle(
                            //   fontSize: 16.sp,
                            //   fontWeight: FontWeight.w400,
                            //   color: Colors.grey.shade400,
                            // ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment:
                                      hasSelected
                                          ? Alignment.center
                                          : Alignment.centerLeft,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        hasSelected
                                            ? CrossAxisAlignment.center
                                            : CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children:
                                        hasSelected
                                            ? [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Text(
                                                    controller
                                                        .formatDateTimeText(
                                                          range[0],
                                                        ),
                                                    style: TextStyle(
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black,
                                                      letterSpacing: 1.0,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Start Date",
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          Colors.grey.shade400,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              Divider(
                                                color: Colors.grey.shade300,
                                              ),

                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Text(
                                                    controller
                                                        .formatDateTimeText(
                                                          range[1],
                                                        ),
                                                    style: TextStyle(
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black,
                                                      letterSpacing: 1.0,
                                                    ),
                                                  ),
                                                  Text(
                                                    "End Date",
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          Colors.grey.shade400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ]
                                            : [
                                              Text(
                                                "Select Date & Time",
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.grey.shade500,
                                                ),
                                              ),
                                            ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 10.h),

                      // 📝 Booking form
                      BookingFormFields(
                        controller: controller,
                        title: "Book Now",
                      ),

                      SizedBox(height: 15.h),

                      // 🔍 CTA Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle bulk booking search
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            textStyle: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600,
                              wordSpacing: 4,
                            ),
                          ),
                          child: const Text("SEARCH PULSE PARTNER"),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}

class MultiDropdownWidget extends StatelessWidget {
  const MultiDropdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedSubcategories = ServiceController.to.selectedSubcategories;

      return Container(
        width: context.width,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 13.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Colors.white),
        ),
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              barrierColor: Colors.black45,
              builder: (_) => GlassSubcategoryDialog(),
            );
          },
          child:
              selectedSubcategories.isEmpty
                  ? Text(
                    "Select Sub-Category",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey.shade500,

                      // height: 2.5,
                    ),
                  )
                  : Wrap(
                    spacing: 8.w,
                    runSpacing: 0,
                    children:
                        ServiceController.to.selectedSubcategories.map((e) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(16.r),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Chip(
                                label: Text(
                                  e,
                                  style: TextStyle(color: Colors.black),
                                ),
                                backgroundColor: AppColors.light,
                                // frosted look
                                deleteIconColor: Colors.black54,
                                onDeleted:
                                    () => ServiceController
                                        .to
                                        .selectedSubcategories
                                        .remove(e),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                  side: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.3),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
        ),
      );
    });
  }
}

class GlassSubcategoryDialog extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();
  final RxString searchText = ''.obs;

  GlassSubcategoryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final subcategories = ServiceController.to.subcategoryList;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 100.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// 🔍 Search Field
                TextField(
                  controller: searchController,
                  onChanged: (val) => searchText.value = val.toLowerCase(),
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search subcategories...',
                    hintStyle: TextStyle(color: Colors.white70),
                    prefixIcon: Icon(Icons.search, color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),

                /// 🧊 Filtered Subcategories
                Obx(() {
                  final filtered =
                      subcategories
                          .where(
                            (item) =>
                                item.toLowerCase().contains(searchText.value),
                          )
                          .toList();

                  return Wrap(
                    spacing: 10.w,
                    runSpacing: 10.h,
                    children:
                        filtered.map((subcategory) {
                          final isSelected = ServiceController
                              .to
                              .selectedSubcategories
                              .contains(subcategory);

                          return GestureDetector(
                            onTap: () {
                              final selectedList =
                                  ServiceController.to.selectedSubcategories;
                              if (isSelected) {
                                selectedList.remove(subcategory);
                              } else {
                                selectedList.add(subcategory);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 10.h,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? AppColors.primary.withValues(
                                          alpha: 0.6,
                                        )
                                        : Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12.r),
                                // border: Border.all(
                                //   color:  Colors.white30,
                                // ),
                              ),
                              child: Text(
                                subcategory,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
