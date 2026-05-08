import 'package:flutter/material.dart';
import '../../../app/routes/app_routes.dart';
import '../../../data/models/patient_model.dart';
import 'package:get/get.dart';

class PatientController extends GetxController {
  final currentIndex = 0.obs;
  final currentPage = 0.0.obs;

  late final PageController pageController;

  final patients =
      <PatientModel>[
        PatientModel(
          patientId: 'P10001',
          name: 'Rahul Sharma',
          age: 32,
          aadhaar: 'XXXX XXXX 1234',
          gender: 'Male',
          bloodGroup: 'B+',
          city: 'Kochi',
          history: 'Lower back pain and posture issues',
          medicines: 'Ibuprofen',
          imagePath: 'https://i.pravatar.cc/300?img=3',
        ),
        PatientModel(
          patientId: 'P10002',
          name: 'Anjali Nair',
          age: 28,
          aadhaar: 'XXXX XXXX 5678',
          gender: 'Female',
          bloodGroup: 'A+',
          city: 'Trivandrum',
          history: 'Post shoulder strain recovery',
          medicines: 'Paracetamol',
          imagePath: 'https://i.pravatar.cc/300?img=5',
        ),
        PatientModel(
          patientId: 'P10003',
          name: 'Vikram Das',
          age: 45,
          aadhaar: 'XXXX XXXX 9101',
          gender: 'Male',
          bloodGroup: 'O+',
          city: 'Calicut',
          history: 'Knee pain after sports injury',
          medicines: 'Diclofenac gel',
          imagePath: 'https://i.pravatar.cc/300?img=8',
        ),
      ].obs;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(viewportFraction: 0.88);

    pageController.addListener(() {
      currentPage.value = pageController.page ?? 0.0;
    });
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void setIndex(int index) {
    currentIndex.value = index;
  }

  double getScale(int index) {
    final diff = (index - currentPage.value).abs();
    return (1 - (diff * 0.08)).clamp(0.88, 1.0);
  }

  double getTranslateY(int index) {
    final diff = (index - currentPage.value).abs();
    return (diff * 16).clamp(0, 24);
  }

  double getRotateZ(int index) {
    final diff = index - currentPage.value;
    return (diff * -0.04).clamp(-0.08, 0.08);
  }

  Matrix4 getTransform(int index) {
    return Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..translate(0.0, getTranslateY(index))
      ..scale(getScale(index))
      ..rotateZ(getRotateZ(index));
  }

  void addPatient(PatientModel patient) {
    patients.insert(0, patient);
    currentIndex.value = 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (pageController.hasClients) {
        pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void updatePatient(int index, PatientModel patient) {
    if (index < 0 || index >= patients.length) return;
    patients[index] = patient;
    patients.refresh();
  }

  void deletePatient(int index) {
    if (index < 0 || index >= patients.length) return;

    patients.removeAt(index);

    if (patients.isEmpty) {
      currentIndex.value = 0;
      return;
    }

    if (currentIndex.value >= patients.length) {
      currentIndex.value = patients.length - 1;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (pageController.hasClients) {
        pageController.animateToPage(
          currentIndex.value,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> confirmDelete(int index) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: Text('patient_delete_title'.tr),
        content: Text('patient_delete_confirm'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('common_cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE7484A),
            ),
            child: Text('common_delete'.tr),
          ),
        ],
      ),
    );

    if (result == true) {
      deletePatient(index);
    }
  }

  void openAddPatientPage() {
    Get.toNamed(Routes.patientForm);
  }

  void openEditPatientPage(int index) {
    if (index < 0 || index >= patients.length) return;

    Get.toNamed(
      Routes.patientForm,
      arguments: {'patient': patients[index], 'patientIndex': index},
    );
  }
}
