import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pro_pulse_medical_app/data/models/patient_model.dart';
import 'package:pro_pulse_medical_app/modules/patient/controller/patient_controller.dart';
import 'package:pro_pulse_medical_app/modules/patient/utils/patient_image_helper.dart';
import 'package:pro_pulse_medical_app/modules/patient/widgets/add_patient_widget.dart';

class PatientDetailsView extends StatelessWidget {
  PatientDetailsView({super.key});

  final PatientController controller =
      Get.isRegistered<PatientController>()
          ? Get.find<PatientController>()
          : Get.put<PatientController>(PatientController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: const Color(0xFFF6F8FB),
        centerTitle: true,
        title: Text(
          'patients_title'.tr,
          style: TextStyle(
            color: const Color(0xFF163A56),
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  top: 0.h,
                  bottom: 0.h,
                ),
                child: Obx(() {
                  final patients = controller.patients;

                  if (patients.isEmpty) {
                    return SizedBox(
                      height: 420.h,
                      child: Center(
                        child: AddPatientCard(
                          onTap: controller.openAddPatientPage,
                        ),
                      ),
                    );
                  }

                  final totalCards = patients.length + 1;

                  return Obx(() {
                    controller.currentPage.value;

                    return SizedBox(
                      height: 420.h,
                      child: PageView.builder(
                        controller: controller.pageController,
                        itemCount: totalCards,
                        onPageChanged: controller.setIndex,
                        padEnds: false,
                        itemBuilder: (context, index) {
                          final isAddCard = index == patients.length;

                          return Transform(
                            alignment: Alignment.center,
                            transform: controller.getTransform(index),
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: 12.w,
                                bottom: 8.h,
                                top: 8.h,
                              ),
                              child:
                                  isAddCard
                                      ? AddPatientCard(
                                        onTap: controller.openAddPatientPage,
                                      )
                                      : PatientCard(
                                        patient: patients[index],
                                        onEdit:
                                            () => controller
                                                .openEditPatientPage(index),
                                        onDelete:
                                            () =>
                                                controller.confirmDelete(index),
                                      ),
                            ),
                          );
                        },
                      ),
                    );
                  });
                }),
              ),
              SizedBox(height: 12.h),
              Obx(() {
                final total = controller.patients.length + 1;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    total,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      width:
                          controller.currentIndex.value == index ? 22.w : 7.w,
                      height: 7.h,
                      decoration: BoxDecoration(
                        color:
                            controller.currentIndex.value == index
                                ? const Color(0xFFE7484A)
                                : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                    ),
                  ),
                );
              }),
              SizedBox(height: 15.h),
              _buildInsightsCards(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInsightsCards() {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 0.h, bottom: 16.h),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 360;
          final patientCard = Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Healthy Tips',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF163A56),
                  ),
                ),
                SizedBox(height: 6.h),
                SizedBox(
                  height: 125.h,
                  child: _PatientTipsCarousel(
                    tips: [
                      {
                        'title': 'Hydration Reminder',
                        'desc':
                            'Drink water regularly through the day to stay active.',
                        'color': const Color(0xFFEAF3FF),
                        'icon': Icons.water_drop_outlined,
                      },
                      {
                        'title': 'Medication Time',
                        'desc': 'Keep fixed reminders so no dose is missed.',
                        'color': const Color(0xFFEFFFF4),
                        'icon': Icons.medication_outlined,
                      },
                      {
                        'title': 'Daily Movement',
                        'desc': 'Do a short walk or light stretch every day.',
                        'color': const Color(0xFFFFF4EA),
                        'icon': Icons.directions_walk_outlined,
                      },
                    ],
                  ),
                ),
              ],
            ),
          );

          if (isNarrow) {
            return Column(children: [patientCard, SizedBox(height: 12.h)]);
          }
          return Row(
            children: [Expanded(child: patientCard), SizedBox(width: 12.w)],
          );
        },
      ),
    );
  }
}

class _PatientTipsCarousel extends StatefulWidget {
  final List<Map<String, Object>> tips;

  const _PatientTipsCarousel({required this.tips});

  @override
  State<_PatientTipsCarousel> createState() => _PatientTipsCarouselState();
}

class _PatientTipsCarouselState extends State<_PatientTipsCarousel> {
  late final PageController _pageController;
  Timer? _timer;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.94);
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer?.cancel();
    if (widget.tips.length <= 1) return;
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || !_pageController.hasClients) return;
      _current = (_current + 1) % widget.tips.length;
      _pageController.animateToPage(
        _current,
        duration: const Duration(milliseconds: 520),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.tips.length,
      onPageChanged: (index) => _current = index,
      itemBuilder: (context, index) {
        final tip = widget.tips[index];
        return Container(
          margin: EdgeInsets.only(right: 8.w),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: tip['color'] as Color,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Row(
            children: [
              Container(
                width: 34.w,
                height: 34.w,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  tip['icon'] as IconData,
                  size: 18.sp,
                  color: const Color(0xFF163A56),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tip['title'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF163A56),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      tip['desc'] as String,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF4D6377),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PatientCard extends StatelessWidget {
  final PatientModel patient;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PatientCard({
    super.key,
    required this.patient,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 540.h,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(color: const Color(0xFFE6EDF3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32.r,
                backgroundImage: getPatientImageProvider(patient.imagePath),
                child:
                    patient.imagePath.isEmpty
                        ? Icon(Icons.person, size: 28.sp)
                        : null,
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            patient.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF163A56),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "${'patient_age'.tr}: ${patient.age} | ${patient.gender}",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Blood Group: ${patient.bloodGroup}",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "${'patient_aadhaar'.tr}: ${patient.aadhaar}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F8FD),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Patient ID: ${patient.patientId}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF163A56),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'City: ${patient.city}',
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF163A56),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'patient_medical_history'.tr,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF163A56),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FBFD),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Text(
                      patient.history,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey[700],
                        height: 1.45,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'patient_current_medicines'.tr,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF163A56),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FBFD),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Text(
                      patient.medicines,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey[700],
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit),
                  label: Text('common_edit'.tr),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF163A56),
                    side: const BorderSide(color: Color(0xFF163A56)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete),
                  label: Text('common_delete'.tr),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE7484A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
