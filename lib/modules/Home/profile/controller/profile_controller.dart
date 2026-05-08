import 'dart:io';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  var name = 'Amal Sam'.obs;
  var email = 'amal@example.com'.obs;
  var phone = '+91 9876543210'.obs;
  var profileImage = Rxn<File>();

  void updateProfile({required String newName, required String newEmail, required String newPhone, File? newImage}) {
    name.value = newName;
    email.value = newEmail;
    phone.value = newPhone;
    if (newImage != null) profileImage.value = newImage;
  }
}

