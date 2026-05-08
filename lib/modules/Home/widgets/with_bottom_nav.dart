import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../controller/home_controller.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background
        Positioned.fill(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/bg5.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.05),
                ),
              ),
            ],
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              // Main page content
              Expanded(child: child),

              // Bottom Navigation
              Obx(() {
                final controller = HomeController.to;
                final bottomPadding = MediaQuery.of(context).viewInsets.bottom == 0 ? 30.h : 0;

                return Padding(
                  padding: EdgeInsets.only(bottom: bottomPadding.toDouble()),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(controller.icons.length, (index) {
                              final isSelected = controller.selectedIndex.value == index;
                              return GestureDetector(
                                onTap: () => controller.changeTab(index),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: isSelected
                                      ? Icon(controller.icons[index], color: Colors.white, size: 26)
                                      .animate()
                                      .scale(duration: 300.ms, curve: Curves.easeOutBack)
                                      : Icon(controller.icons[index], color: Colors.white54, size: 22),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        )
      ],
    );
  }
}


