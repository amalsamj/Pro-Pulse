import 'package:flutter/material.dart';
import '../profile/view/profile_view.dart';
import '../shopping/view/shopping_view.dart';
import '../view/home_content.dart';
import '../../patient/view/patient_details_view.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

class HomeController extends GetxController {
  static HomeController get to =>
      Get.isRegistered<HomeController>()
          ? Get.find<HomeController>()
          : Get.put<HomeController>(HomeController());

  final selectedIndex = 0.obs;
  final animateIndex = (-1).obs;
  final isLoading = true.obs;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final navigatorKey = GlobalKey<NavigatorState>();

  final List<Widget> pages = [
    HomeTabContent(),
    PatientDetailsView(),
    ShoppingView(),
    const ProfileView(),
  ];

  final List<IconData> icons = [
    Iconsax.home_hashtag_outline,
    Iconsax.profile_2user_outline,
    Iconsax.shopping_bag_outline,
    Iconsax.user_outline,
  ];

  final List<String> labels = [
    'tab_home',
    'tab_patients',
    'tab_shop',
    'tab_profile',
  ];

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 1200), () {
      isLoading.value = false;
    });
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }
}
