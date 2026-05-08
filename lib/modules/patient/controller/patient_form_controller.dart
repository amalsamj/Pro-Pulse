import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pro_pulse_medical_app/data/models/patient_model.dart';
import 'package:pro_pulse_medical_app/modules/patient/controller/patient_controller.dart';

class PatientFormController extends GetxController {
  PatientFormController({this.patient, this.patientIndex});

  final PatientModel? patient;
  final int? patientIndex;

  final formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController ageController;
  late final TextEditingController aadhaarController;
  late final TextEditingController cityController;

  final selectedGender = 'Male'.obs;
  final selectedBloodGroup = 'A+'.obs;
  final selectedHistory = ''.obs;
  final selectedMedicines = ''.obs;
  final profileImage = ''.obs;

  final List<String> historyOptions = [
    'Lower back pain and posture issues',
    'Post shoulder strain recovery',
    'Knee pain after sports injury',
    'Diabetes and BP monitoring',
    'General weakness and fatigue',
  ];

  final List<String> medicinesOptions = [
    'Ibuprofen',
    'Paracetamol',
    'Vitamin D',
    'Calcium',
    'Diclofenac gel',
    'No current medicines',
  ];

  final ImagePicker picker = ImagePicker();
  final PatientController patientController = Get.find<PatientController>();

  bool get isEditMode => patient != null && patientIndex != null;

  @override
  void onInit() {
    super.onInit();

    nameController = TextEditingController(text: patient?.name ?? '');
    ageController = TextEditingController(
      text: patient != null ? patient!.age.toString() : '',
    );
    aadhaarController = TextEditingController(text: patient?.aadhaar ?? '');
    cityController = TextEditingController(text: patient?.city ?? '');

    selectedGender.value = patient?.gender ?? 'Male';
    selectedBloodGroup.value = patient?.bloodGroup ?? 'A+';
    selectedHistory.value = patient?.history ?? historyOptions.first;
    selectedMedicines.value = patient?.medicines ?? medicinesOptions.first;

    if (!historyOptions.contains(selectedHistory.value)) {
      historyOptions.insert(0, selectedHistory.value);
    }
    if (!medicinesOptions.contains(selectedMedicines.value)) {
      medicinesOptions.insert(0, selectedMedicines.value);
    }

    /// existing image from model
    profileImage.value = patient?.imagePath ?? '';
  }

  @override
  void onClose() {
    nameController.dispose();
    ageController.dispose();
    aadhaarController.dispose();
    cityController.dispose();
    super.onClose();
  }

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      profileImage.value = image.path;
    }
  }

  void savePatient() {
    if (!(formKey.currentState?.validate() ?? false)) return;

    final patientId =
        isEditMode ? patient!.patientId : _generateUniquePatientId();

    final patientData = PatientModel(
      patientId: patientId,
      name: nameController.text.trim(),
      age: int.tryParse(ageController.text.trim()) ?? 0,
      aadhaar: aadhaarController.text.trim(),
      gender: selectedGender.value,
      bloodGroup: selectedBloodGroup.value,
      city: cityController.text.trim(),
      history: selectedHistory.value,
      medicines: selectedMedicines.value,
      imagePath: profileImage.value, // saved in model
    );

    if (isEditMode) {
      patientController.updatePatient(patientIndex!, patientData);
    } else {
      patientController.addPatient(patientData);
    }

    Get.back();
  }

  String _generateUniquePatientId() {
    final existingIds =
        patientController.patients.map((p) => p.patientId).toSet();
    int next = 10001;
    while (existingIds.contains('P$next')) {
      next++;
    }
    return 'P$next';
  }
}
