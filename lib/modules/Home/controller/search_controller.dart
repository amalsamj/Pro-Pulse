import 'package:get/get.dart';

class SearchServiceController extends GetxController {
  var query = ''.obs;

  final List<String> allSubcategories = [
    'Physiotherapy',
    'Nursing',
    'Home Care',
    'Injections',
    'Vitals Check',
    'Therapy',
    'Pulse Partner',
    'Doctor Visit',
    'Elderly Care',
    'Lab Tests',
  ];

  void updateQuery(String value) {
    query.value = value;
  }

  List<String> get filteredSubcategories => allSubcategories
      .where((item) => item.toLowerCase().contains(query.value.toLowerCase()))
      .toList();
}

