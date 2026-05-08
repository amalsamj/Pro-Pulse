import '../../../data/models/patient_model.dart';
import '../controller/patient_form_controller.dart';
import 'package:get/get.dart';

class PatientFormBinding extends Bindings {
  PatientFormBinding({this.patient, this.patientIndex});

  final PatientModel? patient;
  final int? patientIndex;

  @override
  void dependencies() {
    Get.put(
      PatientFormController(patient: patient, patientIndex: patientIndex),
    );
  }
}
