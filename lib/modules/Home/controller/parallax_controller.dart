import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ParallaxController extends GetxController {
  late PageController pageController;
  RxDouble currentPage = 0.0.obs;

  final cards = [
    {
      "title": "Vitals",
      "subtitle": "Track health trends",
      "image": "assets/images/wall-3.png",
    },
    {
      "title": "Physiotherapy",
      "subtitle": "Expert care at home",
      "image": "assets/images/wall-5.png",
    },
    {
      "title": "Nursing",
      "subtitle": "24/7 assistance",
      "image": "assets/images/wall-8.png",
    },
    {
      "title": "Home Nurse",
      "subtitle": "Care at home",
      "image": "assets/images/wall-10.png",
    },
    // {"title": "Injections", "subtitle": "Get vaccinated", "image": "assets/images/inj2.png"},
    // {"title": "Lab Test", "subtitle": "Get tested easily", "image": "assets/images/lab1.png"},
  ];

  final int virtualItemCount = 10000;
  final int initialPage = 5000;
  Timer? autoScrollTimer;
  bool _isAutoScrollPaused = false;

  @override
  void onInit() {
    pageController = PageController(
      initialPage: initialPage,
      viewportFraction: 0.75,
    );

    currentPage.value = initialPage.toDouble();

    pageController.addListener(() {
      if (pageController.hasClients && pageController.positions.length == 1) {
        currentPage.value = pageController.page ?? initialPage.toDouble();
      }
    });

    _startAutoScroll();
    super.onInit();
  }

  void _startAutoScroll() {
    autoScrollTimer?.cancel();
    autoScrollTimer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (_isAutoScrollPaused) return;
      if (pageController.hasClients && pageController.positions.length == 1) {
        final nextPage =
            (pageController.page ?? initialPage.toDouble()).toInt() + 1;
        pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void pauseAutoScroll() {
    _isAutoScrollPaused = true;
  }

  void resumeAutoScroll() {
    _isAutoScrollPaused = false;
  }

  @override
  void onClose() {
    pageController.dispose();
    autoScrollTimer?.cancel();
    super.onClose();
  }
}
