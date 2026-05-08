import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class ServiceController extends GetxController {
  static ServiceController get to =>
      (Get.isRegistered<ServiceController>() == false)
          ? Get.put<ServiceController>(ServiceController())
          : Get.find();
  final selectedService = ''.obs;
  final selectedCategory = ''.obs;
  final MultiSelectController<String> subCategoryDropdownController =
      MultiSelectController<String>();
  final selectedSubcategories = <String>[].obs;
  final subcategoryList = <String>[].obs;

  /// Full services map
  final services =
      {
        "Injections": {
          "Vitamin": ["Vitamin B12", "Vitamin D3", "Multivitamin Injections"],
          "Antibiotic": [
            "Ceftriaxone",
            "Amoxicillin",
            "Piperacillin-Tazobactam",
          ],
          "Pain Relief": ["Diclofenac", "Tramadol", "Paracetamol"],
          "Allergy & Steroids": ["Hydrocortisone", "Dexamethasone"],
          "Vaccinations": [
            "Influenza",
            "Typhoid",
            "Hepatitis B",
            "Tetanus",
            "Covid-19",
          ],
        },
        "Home Nurse": {
          "Daily Care": [
            "Bathing Assistance",
            "Feeding Support",
            "Medication Admin",
            "Bed Making",
          ],
          "Critical Care": [
            "Ventilator Support",
            "Tracheostomy Care",
            "Oxygen Support",
            "Monitor Vitals",
          ],
          "Palliative Care": [
            "Pain Relief",
            "Comfort Care",
            "End-of-Life Support",
          ],
          "Post-hospitalization": [
            "Surgical Recovery",
            "Infection Management",
            "Mobility Help",
          ],
        },
        "Nursing": {
          "Wound Care": [
            "Dressing Change",
            "Pressure Ulcers",
            "Post-op Wounds",
            "Diabetic Wounds",
          ],
          "IV Therapy": [
            "IV Antibiotics",
            "IV Fluids",
            "Electrolytes",
            "Pain Relief IV",
          ],
          "Catheter Care": [
            "Urinary Catheter Insertion",
            "Foley Catheter Change",
            "Bladder Wash",
          ],
          "Tube Management": [
            "Ryle's Tube",
            "PEG Tube Feeding",
            "Colostomy Bag Change",
          ],
        },
        "Vitals": {
          "Vital Signs Monitoring": [
            "Blood Pressure",
            "Heart Rate",
            "Respiratory Rate",
            "Temperature",
            "Oxygen Saturation (SpO2)",
            "ECG",
          ],
          "Diabetes Check": [
            "Random Blood Sugar",
            "Fasting Sugar",
            "Postprandial Sugar",
            "HbA1c",
          ],
          "General Assessment": [
            "BMI",
            "Pulse Rate",
            "Hydration Check",
            "Pain Score",
          ],
        },
        "Physiotherapy": {
          "Pain Management": [
            "Back Pain",
            "Neck Pain",
            "Joint Pain",
            "Sciatica",
            "Shoulder Pain",
          ],
          "Post-surgery Rehab": [
            "Knee Replacement",
            "Hip Surgery",
            "Spinal Surgery",
            "Cardiac Rehab",
          ],
          "Neurological Rehab": [
            "Stroke Rehab",
            "Parkinson's",
            "Multiple Sclerosis",
            "Paralysis",
          ],
          "Geriatric Care": [
            "Mobility Training",
            "Fall Prevention",
            "Strengthening Exercises",
          ],
        },
        "Lab Test": {
          "Blood Tests": [
            "CBC",
            "Liver Function",
            "Kidney Function",
            "Lipid Profile",
            "Thyroid Panel",
          ],
          "Diabetes": [
            "Fasting Sugar",
            "HbA1c",
            "Insulin",
            "Glucose Tolerance Test",
          ],
          "Hormonal": [
            "TSH",
            "LH",
            "FSH",
            "Cortisol",
            "Estrogen",
            "Testosterone",
          ],
          "Urine & Stool": [
            "Urine Routine",
            "Urine Culture",
            "Stool Routine",
            "Occult Blood",
          ],
          "Infectious": ["Widal", "HIV", "Hepatitis B", "Malaria", "Dengue"],
        },
      }.obs;

  void updateSubcategories() {
    final updated =
        services[selectedService.value]?[selectedCategory.value] ?? [];
    debugPrint("🔁 updateSubcategories → $updated");
    subcategoryList.value = updated; // ✅ this will trigger Obx
  }

  /// Get all category keys under a selected service
  List<String> getCategories(String service) {
    return services[service]?.keys.toList() ?? [];
  }

  /// Get subcategories under a category of a service
  List<String> getSubcategories(String service, String category) {
    return services[service]?[category] ?? [];
  }

  /// Select a service and clear previous category if service changed
  void selectService(String serviceName) {
    if (selectedService.value != serviceName) {
      selectedService.value = serviceName;
      selectedCategory.value = '';
      selectedSubcategories.clear();
      subcategoryList.clear();
      subCategoryDropdownController.clearAll();
      debugPrint('🧹 Cleared subcategories on new service: $serviceName');
    }
  }

  /// Select a category
  void selectCategory(String category) {
    selectedCategory.value = category;
  }
}
