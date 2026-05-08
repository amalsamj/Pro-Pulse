import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pro_pulse_medical_app/app/routes/app_routes.dart';
import 'package:pro_pulse_medical_app/core/constants/app_colors.dart';
import 'package:pro_pulse_medical_app/core/services/app_service.dart';
import 'package:pro_pulse_medical_app/core/widgets/glass_snack_bar.dart';

class SignupController extends GetxController {
  final fullNameController = TextEditingController();
  final dobController = TextEditingController();
  final emailController = TextEditingController();
  final addressLine1Controller = TextEditingController();
  final addressLine2Controller = TextEditingController();
  final pincodeController = TextEditingController();
  final mobileController = TextEditingController();

  var city = ''.obs;
  var state = ''.obs;
  var postOffice = ''.obs;

  RxBool isFormValid = false.obs;

  ScrollController scrollController = ScrollController();

  late FocusNode fullNameFocus;
  late FocusNode emailFocus;
  late FocusNode addressLine1Focus;
  late FocusNode addressLine2Focus;
  late FocusNode pincodeFocus;
  late FocusNode dobFocus;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args != null && args['mobile'] != null) {
      mobileController.text = args['mobile'];
      debugPrint("mob${mobileController.text}");
    }
    // Setup listener
    fullNameController.addListener(validateForm);
    dobController.addListener(validateForm);
    emailController.addListener(validateForm);
    addressLine1Controller.addListener(validateForm);
    addressLine2Controller.addListener(validateForm);
    pincodeController.addListener(validateForm);
    /////// Focus Node
    fullNameFocus = FocusNode();
    dobFocus = FocusNode();
    emailFocus = FocusNode();
    addressLine1Focus = FocusNode();
    addressLine2Focus = FocusNode();
    pincodeFocus = FocusNode();
    validateForm();
  }

  void validateForm() {
    final isValid =
        fullNameController.text.isNotEmpty &&
        dobController.text.isNotEmpty &&
        emailController.text.isEmail && // Dart extension
        addressLine1Controller.text.isNotEmpty &&
        addressLine2Controller.text.isNotEmpty &&
        pincodeController.text.length == 6 &&
        city.isNotEmpty &&
        state.isNotEmpty &&
        postOffice.isNotEmpty;

    isFormValid.value = isValid;
    debugPrint("Form is valid: ${isFormValid.value}");
  }

  Future<void> submitForm() async {
    // Validate Full Name
    if (fullNameController.text.trim().isEmpty) {
      showGlassSnack(
        title: "Invalid Full Name",
        message: "Please enter your full name",
        isError: true,
      );
      return;
    }

    // Validate Date of Birth
    if (dobController.text.trim().isEmpty) {
      showGlassSnack(
        title: "Invalid Date of Birth",
        message: "Please select your date of birth",
        isError: true,
      );
      return;
    }

    // Validate Mobile Number
    final mobile = mobileController.text.trim();
    if (mobile.isEmpty || !RegExp(r'^[6-9]\d{9}$').hasMatch(mobile)) {
      showGlassSnack(
        title: "Invalid Mobile Number",
        message:
            "Please enter a valid 10-digit mobile number starting with 6-9",
        isError: true,
      );
      return;
    }

    // Validate Email
    final email = emailController.text.trim();
    if (email.isEmpty ||
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      showGlassSnack(
        title: "Invalid Email",
        message: "Please enter a valid email address",
        isError: true,
      );
      return;
    }

    // Validate Address Line 1
    if (addressLine1Controller.text.trim().isEmpty) {
      showGlassSnack(
        title: "Invalid Address",
        message: "Please enter your address line 1",
        isError: true,
      );
      return;
    }

    // Validate Address Line 2
    if (addressLine2Controller.text.trim().isEmpty) {
      showGlassSnack(
        title: "Invalid Landmark",
        message: "Please enter your landmark",
        isError: true,
      );
      return;
    }

    // Validate Pincode
    final pincode = pincodeController.text.trim();
    if (pincode.isEmpty ||
        pincode.length != 6 ||
        !RegExp(r'^\d{6}$').hasMatch(pincode)) {
      showGlassSnack(
        title: "Invalid Pincode",
        message: "Please enter a valid 6-digit pincode",
        isError: true,
      );
      return;
    }

    // Validate City, State, Post Office
    if (city.value.isEmpty || state.value.isEmpty || postOffice.value.isEmpty) {
      showGlassSnack(
        title: "Invalid Location",
        message: "Please verify your pincode to fetch city and state",
        isError: true,
      );
      return;
    }

    // Form is valid
    // showGlassSnack(title: "Success", message: "Registered successfully!");

    await Get.find<AppService>().init();
    await Get.find<AppService>().setLoggedIn(true);
    Get.offAllNamed(Routes.home);

    // You can add API submission or navigation here
  }

  void fetchCityState(String pin) async {
    if (pin.length == 6) {
      final url = Uri.parse("https://api.postalpincode.in/pincode/$pin");
      try {
        final response = await http.get(url);
        final data = jsonDecode(response.body);
        if (data[0]['Status'] == 'Success') {
          final postOffices = data[0]['PostOffice'] as List;

          if (postOffices.length == 1) {
            // ✅ Only one result — assign directly
            city.value = postOffices[0]['District'];
            state.value = postOffices[0]['State'];
            postOffice.value = postOffices[0]['Name'];
          } else {
            // 🔄 Multiple post offices — let user pick one
            final selected = await showModalBottomSheet<String>(
              context: Get.context!,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              barrierColor: Colors.black.withValues(alpha: 0.4),
              builder: (context) {
                return SafeArea(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 24.h,
                      ),
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: 360.w,
                          maxHeight: 480.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 24,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 18.w,
                                vertical: 18.h,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Select Post Office',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.black54,
                                      size: 24.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1, color: Colors.black12),
                            Flexible(
                              child: ListView(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                children:
                                    postOffices.map((office) {
                                      return ListTile(
                                        title: Text(
                                          office['Name'],
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        subtitle: Text(
                                          office['District'],
                                          style: const TextStyle(
                                            color: Colors.black54,
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.pop(
                                            context,
                                            office['Name'],
                                          );
                                          FocusScope.of(context).unfocus();
                                        },
                                      );
                                    }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );

            if (selected != null) {
              final selectedOffice = postOffices.firstWhere(
                (e) => e['Name'] == selected,
              );
              city.value = selectedOffice['District'];
              state.value = selectedOffice['State'];
              postOffice.value = selectedOffice['Name'];
              validateForm(); // ✅ Call here
            }
            if (postOffices.length == 1) {
              city.value = postOffices[0]['District'];
              state.value = postOffices[0]['State'];
              postOffice.value = postOffices[0]['Name'];
              validateForm(); // ✅ Call here
            }
          }
        } else {
          city.value = '';
          state.value = '';
          postOffice.value = '';
        }
      } catch (e) {
        city.value = '';
        state.value = '';
        postOffice.value = '';
      }
    }
  }

  void pickDateOfBirth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1976D2), // Blue primary
              onPrimary: Colors.white,
              onSurface: Colors.black,
              surface: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF1976D2),
                textStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            dialogTheme: DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      dobController.text = DateFormat('dd-MM-yyyy').format(picked);
      validateForm();
    }
  }

  void scrollToFocusedField(FocusNode focusNode) {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (focusNode.hasFocus && scrollController.hasClients) {
        final context = focusNode.context;
        if (context != null) {
          // ignore: use_build_context_synchronously
          final renderBox = context.findRenderObject() as RenderBox?;
          if (renderBox != null) {
            final offset = renderBox.localToGlobal(Offset.zero).dy;
            final scrollOffset = scrollController.offset + offset - 350;
            scrollController.animateTo(
              scrollOffset,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          }
        }
      }
    });
  }

  @override
  void onClose() {
    fullNameController.dispose();
    dobController.dispose();
    emailController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    pincodeController.dispose();

    fullNameFocus.dispose();
    emailFocus.dispose();
    addressLine1Focus.dispose();
    addressLine2Focus.dispose();
    pincodeFocus.dispose();
    dobFocus.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
