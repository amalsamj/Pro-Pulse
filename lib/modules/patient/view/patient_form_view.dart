import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pro_pulse_medical_app/core/constants/app_colors.dart';
import 'package:pro_pulse_medical_app/data/models/patient_model.dart';
import 'package:pro_pulse_medical_app/modules/patient/controller/patient_form_controller.dart';
import 'package:pro_pulse_medical_app/modules/patient/utils/patient_image_helper.dart';

class PatientFormView extends StatelessWidget {
  PatientFormView({super.key, this.patient, this.patientIndex}) {
    Get.put(
      PatientFormController(patient: patient, patientIndex: patientIndex),
    );
  }

  final PatientModel? patient;
  final int? patientIndex;

  PatientFormController get controller => Get.find<PatientFormController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        backgroundColor: const Color(0xFFF6F8FB),
        centerTitle: true,
        title: Text(
          controller.isEditMode
              ? 'patient_edit_title'.tr
              : 'patient_add_title'.tr,
          style: TextStyle(
            color: const Color(0xFF163A56),
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(14.w),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                Obx(
                  () => GestureDetector(
                    onTap: controller.pickImage,
                    child: CircleAvatar(
                      radius: 45.r,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: getPatientImageProvider(
                        controller.profileImage.value,
                      ),
                      child:
                          controller.profileImage.value.isEmpty
                              ? Icon(
                                Icons.camera_alt,
                                size: 30.sp,
                                color: Colors.grey,
                              )
                              : null,
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                _buildField(
                  heading: 'Name',
                  controller: controller.nameController,
                  validator:
                      (v) =>
                          v == null || v.trim().isEmpty
                              ? 'err_enter_name'.tr
                              : null,
                ),
                SizedBox(height: 6.h),
                _buildField(
                  heading: 'Age',
                  controller: controller.ageController,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'err_enter_age'.tr;
                    }
                    if (int.tryParse(v.trim()) == null) {
                      return 'err_enter_valid_age'.tr;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 6.h),
                _buildField(
                  heading: 'Aadhaar Number',
                  controller: controller.aadhaarController,
                  validator:
                      (v) =>
                          v == null || v.trim().isEmpty
                              ? 'err_enter_aadhaar'.tr
                              : null,
                ),
                SizedBox(height: 6.h),
                _buildField(
                  heading: 'City',
                  controller: controller.cityController,
                  validator:
                      (v) =>
                          v == null || v.trim().isEmpty
                              ? 'Please enter city'
                              : null,
                ),
                SizedBox(height: 6.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Gender',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF163A56),
                    ),
                  ),
                ),
                SizedBox(height: 3.h),
                Obx(
                  () => Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: const Color(0xFFE6EDF3)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: controller.selectedGender.value,
                        isExpanded: true,
                        items: [
                          DropdownMenuItem(
                            value: 'Male',
                            child: Text('gender_male'.tr),
                          ),
                          DropdownMenuItem(
                            value: 'Female',
                            child: Text('gender_female'.tr),
                          ),
                          DropdownMenuItem(
                            value: 'Other',
                            child: Text('gender_other'.tr),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedGender.value = value;
                          }
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Blood Group',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF163A56),
                    ),
                  ),
                ),
                SizedBox(height: 3.h),
                Obx(
                  () => Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: const Color(0xFFE6EDF3)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: controller.selectedBloodGroup.value,
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(value: 'A+', child: Text('A+')),
                          DropdownMenuItem(value: 'A-', child: Text('A-')),
                          DropdownMenuItem(value: 'B+', child: Text('B+')),
                          DropdownMenuItem(value: 'B-', child: Text('B-')),
                          DropdownMenuItem(value: 'AB+', child: Text('AB+')),
                          DropdownMenuItem(value: 'AB-', child: Text('AB-')),
                          DropdownMenuItem(value: 'O+', child: Text('O+')),
                          DropdownMenuItem(value: 'O-', child: Text('O-')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedBloodGroup.value = value;
                          }
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Medical History',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF163A56),
                    ),
                  ),
                ),
                SizedBox(height: 3.h),
                Obx(
                  () => Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: const Color(0xFFE6EDF3)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: controller.selectedHistory.value,
                        isExpanded: true,
                        items:
                            controller.historyOptions
                                .map(
                                  (history) => DropdownMenuItem(
                                    value: history,
                                    child: Text(
                                      history,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedHistory.value = value;
                          }
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Current Medicines',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF163A56),
                    ),
                  ),
                ),
                SizedBox(height: 3.h),
                Obx(
                  () => Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: const Color(0xFFE6EDF3)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: controller.selectedMedicines.value,
                        isExpanded: true,
                        items:
                            controller.medicinesOptions
                                .map(
                                  (medicine) => DropdownMenuItem(
                                    value: medicine,
                                    child: Text(
                                      medicine,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedMedicines.value = value;
                          }
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: controller.savePatient,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                    ),
                    child: Text(
                      controller.isEditMode
                          ? 'patient_update_button'.tr
                          : 'patient_add_button'.tr,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String heading,
    required TextEditingController controller,
    String? Function(String?)? validator,
    int minLines = 1,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF163A56),
          ),
        ),
        SizedBox(height: 3.h),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          minLines: minLines,
          maxLines: maxLines,
          style: TextStyle(fontSize: 14.sp, color: const Color(0xFF163A56)),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(color: Color(0xFFE6EDF3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(color: Color(0xFFE6EDF3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(color: Color(0xFF163A56)),
            ),
          ),
        ),
      ],
    );
  }
}
