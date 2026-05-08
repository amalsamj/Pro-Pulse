import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import '../../../core/constants/app_colors.dart';

class BookingController extends GetxController
    with GetTickerProviderStateMixin {
  static BookingController get to =>
      (Get.isRegistered<BookingController>() == false)
          ? Get.put<BookingController>(BookingController())
          : Get.find();
  late TabController tabController;
  late PlatformFile prescriptionFile;

  var selectedPatient = 0.obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  RxList<DateTime> multiBookingDateTimeRange = <DateTime>[].obs;
  Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;
  RxBool isPatientExpanded = true.obs;
  RxBool isTimePickerExpanded = false.obs;
  RxBool isDatePickerExpanded = false.obs;

  RxBool isUploadingPrescription = false.obs;
  RxBool isPrescriptionUploaded = false.obs;
  RxString uploadedFileName = ''.obs;
  bool hasCollapsed = false;
  Timer? timeUpdateTimer;
  late FocusNode timePickerFocusNode;
  RxString formattedSelectedTime = "Select Time".obs;
  RxBool hasSelectedTime = false.obs;

  final categoryController = TextEditingController();
  final locationController = TextEditingController();
  final noteController = TextEditingController();
  final altPhoneController = TextEditingController();

  final MultiSelectController<String> categoryDropdownController =
      MultiSelectController<String>();

  late ScrollController scrollController;
  RxDouble scrollOffset = 0.0.obs;

  RxBool isCollapsedByScroll = false.obs;

  DateTime getInitialDateTimeForPicker() {
    final date = selectedDate.value;
    final now = DateTime.now();

    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    if (!hasSelectedTime.value || !isToday) {
      // Show current time on selected date if:
      // - No selected time yet OR
      // - It's a future date
      return DateTime(date.year, date.month, date.day, now.hour, now.minute);
    }

    // Otherwise, return the selected time on the selected date
    return DateTime(
      date.year,
      date.month,
      date.day,
      selectedTime.value.hour,
      selectedTime.value.minute,
    );
  }

  bool isTimeInPast(TimeOfDay time) {
    final now = DateTime.now();
    final isToday =
        selectedDate.value.year == now.year &&
        selectedDate.value.month == now.month &&
        selectedDate.value.day == now.day;

    if (!isToday) return false;

    final selected = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    return selected.isBefore(now);
  }

  void onDateSelected(DateTime date) {
    selectedDate.value = date;

    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    // If not today OR selectedTime is in the past, reset time
    final selectedDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      selectedTime.value.hour,
      selectedTime.value.minute,
    );

    final isSelectedTimePast = selectedDateTime.isBefore(now);

    if (!isToday || isSelectedTimePast) {
      hasSelectedTime.value = false;
      selectedTime.value = TimeOfDay.fromDateTime(now);
    }

    // Optional: collapse time picker if needed
    isTimePickerExpanded.value = false;
  }

  @override
  void onInit() {
    super.onInit();

    tabController = TabController(length: 2, vsync: this);
    timePickerFocusNode = FocusNode();
    scrollController = ScrollController();

    scrollController.addListener(() {
      scrollOffset.value = scrollController.offset;

      if (scrollOffset.value > Get.height * 0.4) {
        if (isPatientExpanded.value) isPatientExpanded.value = false;
      } else {
        if (!isPatientExpanded.value) isPatientExpanded.value = true;
      }
    });

    timePickerFocusNode.addListener(() {
      if (!timePickerFocusNode.hasFocus) {
        isTimePickerExpanded.value = false;
      }
    });

    updateFormattedTime(selectedTime.value);
  }

  void updateFormattedTime(TimeOfDay time) {
    final date = selectedDate.value;

    final dt = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    formattedSelectedTime.value = formatDateTimeText(dt);
  }

  void onTimeSelected(DateTime time) {
    final selected = TimeOfDay.fromDateTime(time);
    selectedTime.value = selected;
    updateFormattedTime(selected);
  }

  String formatTimeOfDay(TimeOfDay? time) {
    if (time == null) return "Select Time";
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:$minute $period";
  }

  String formatDateTimeText(DateTime dt) {
    return DateFormat('dd MMM yyyy - hh:mm a').format(dt).toUpperCase();
  }

  final List<Map<String, String>> patients = [
    {
      'name': 'Aarav Mehta',
      'age': '34',
      'aadhaar': 'XXXX-XXXX-1234',
      'gender': 'Male',
      'history': 'Asthma, Allergy',
      'medicines': 'Montelukast, Cetirizine',
    },
    {
      'name': 'Diya Sharma',
      'age': '29',
      'aadhaar': 'XXXX-XXXX-5678',
      'gender': 'Female',
      'history': 'PCOS, Anxiety',
      'medicines': 'Metformin, Sertraline',
    },
    {
      'name': 'Rohan Kapoor',
      'age': '42',
      'aadhaar': 'XXXX-XXXX-9101',
      'gender': 'Male',
      'history': 'Diabetes, Hypertension',
      'medicines': 'Metformin, Telmisartan',
    },
    {
      'name': 'Sneha Reddy',
      'age': '37',
      'aadhaar': 'XXXX-XXXX-1121',
      'gender': 'Female',
      'history': 'Thyroid, Migraine',
      'medicines': 'Levothyroxine, Sumatriptan',
    },
    {
      'name': 'Kabir Das',
      'age': '50',
      'aadhaar': 'XXXX-XXXX-3141',
      'gender': 'Male',
      'history': 'Arthritis, Cholesterol',
      'medicines': 'Atorvastatin, Ibuprofen',
    },
  ];

  Future<void> showDefaultDateTimeRangePicker(
    BuildContext context,
    void Function(DateTime start, DateTime end) onPicked,
  ) async {
    final now = DateTime.now();

    final pickedDateRange = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 3652)),
      builder: (context, child) {
        return MediaQuery.removeViewInsets(
          removeBottom: true,
          context: context,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 350,
                    maxHeight: 500, // 👈 Set height here
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.dark(
                        primary: AppColors.primary,
                        onPrimary: Colors.white,
                        onSurface: Colors.white,
                        surface: Colors.white.withValues(alpha: 0.05),
                      ),
                      textTheme: const TextTheme(
                        bodyLarge: TextStyle(
                          color: Colors.white,
                        ), // used in some devices
                        bodyMedium: TextStyle(color: Colors.white), // fallback
                      ),
                      datePickerTheme: DatePickerThemeData(
                        dayStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        dayForegroundColor: WidgetStateProperty.all(
                          Colors.white,
                        ),

                        rangePickerHeaderHeadlineStyle: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.red,
                        ),
                        // hides the "Select range"
                        rangePickerHeaderHelpStyle: TextStyle(fontSize: 20.sp),
                        // hides the date string
                        todayForegroundColor: WidgetStateProperty.all(
                          Colors.white,
                        ),
                        todayBackgroundColor: WidgetStateProperty.all(
                          Colors.white,
                        ),
                        // Highlight today
                        todayBorder: BorderSide.none,
                        rangeSelectionBackgroundColor: AppColors.primary
                            .withAlpha(60),
                        rangeSelectionOverlayColor: WidgetStateProperty.all(
                          AppColors.primary.withAlpha(90), // 64 ≈ 25% opacity
                        ),
                      ),
                      iconTheme: const IconThemeData(
                        size: 28,
                        color: Colors.white,
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          textStyle: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    child: child!,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    if (pickedDateRange != null) {
      final startTime = await showStyledTimePicker(
        // ignore: use_build_context_synchronously
        context,
        initialTime: TimeOfDay.fromDateTime(now),
      );

      if (startTime == null) return;

      final endTime = await showStyledTimePicker(
        // ignore: use_build_context_synchronously
        context,
        initialTime: TimeOfDay.fromDateTime(now.add(const Duration(hours: 1))),
      );

      if (endTime == null) return;

      final startDateTime = DateTime(
        pickedDateRange.start.year,
        pickedDateRange.start.month,
        pickedDateRange.start.day,
        startTime.hour,
        startTime.minute,
      );

      final endDateTime = DateTime(
        pickedDateRange.end.year,
        pickedDateRange.end.month,
        pickedDateRange.end.day,
        endTime.hour,
        endTime.minute,
      );

      if (endDateTime.isBefore(startDateTime)) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('End time must be after start time')),
        );
        return;
      }

      onPicked(startDateTime, endDateTime);
    }
  }

  Future<TimeOfDay?> showStyledTimePicker(
    BuildContext context, {
    TimeOfDay? initialTime,
    String helpText = 'Select Time',
  }) async {
    return await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                constraints: const BoxConstraints(
                  maxWidth: 350,
                  maxHeight: 550,
                ),

                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    timePickerTheme: TimePickerThemeData(
                      dayPeriodColor: AppColors.primary, // background
                      dayPeriodTextColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: Colors.transparent,
                      dialTextColor: Colors.white,
                      dialHandColor: AppColors.primary,
                      // 64 ≈ 25% opacity
                      dialBackgroundColor: Colors.white.withValues(alpha: 0.1),
                      hourMinuteTextStyle: TextStyle(
                        fontSize: 34.sp, // Bigger numbers
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      hourMinuteColor: AppColors.primary,

                      helpTextStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    colorScheme: ColorScheme.dark(
                      primary: AppColors.primary,
                      onPrimary: Colors.white,
                      surface: Colors.transparent,
                      onSurface: Colors.white,
                    ),
                    iconTheme: IconThemeData(size: 0),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        textStyle: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          // letterSpacing: 1,
                        ),
                        alignment:
                            Alignment.bottomRight, // aligns text in the button
                        // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                  ),
                  child: child!,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> pickAndUploadPrescription() async {
    try {
      isUploadingPrescription.value = true;

      // final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png']);

      final result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        uploadedFileName.value = result.files.single.name;

        // Simulate upload delay (replace with your actual upload logic)
        await Future.delayed(const Duration(seconds: 2));

        // Once uploaded:
        isPrescriptionUploaded.value = true;
      }
    } catch (e) {
      debugPrint("Upload error: $e");
    } finally {
      isUploadingPrescription.value = false;
    }
  }

  void collapsePatientIfExpanded() {
    if (isPatientExpanded.value) {
      isPatientExpanded.value = false;
    }
  }

  void collapsePatientOnFieldFocus(FocusNode node) {
    node.addListener(() {
      if (node.hasFocus) {
        collapsePatientIfExpanded();
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    tabController.dispose();
    categoryController.dispose();
    locationController.dispose();
    noteController.dispose();
    altPhoneController.dispose();
    timePickerFocusNode.dispose();
    super.onClose();
  }
}
