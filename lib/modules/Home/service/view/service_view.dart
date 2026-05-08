import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/routes/app_routes.dart';
import '../controller/service_controller.dart';
import '../widgets/service_widgets.dart';
import '../../widgets/glass_back_button.dart';
import 'package:get/get.dart';

String _serviceImageHeroTag(String title) => 'service-image-$title';
Tween<Rect?> _heroRectTween(Rect? begin, Rect? end) {
  return MaterialRectCenterArcTween(begin: begin, end: end);
}

Widget _heroChild(BuildContext heroContext) {
  final heroWidget = heroContext.widget;
  return heroWidget is Hero ? heroWidget.child : heroWidget;
}

Widget _serviceImageFlightShuttle(
  BuildContext flightContext,
  Animation<double> animation,
  HeroFlightDirection flightDirection,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
) {
  final shuttleAnimation = CurvedAnimation(
    parent: animation,
    curve: Curves.easeInOutCubic,
    reverseCurve: Curves.easeOutCubic,
  );

  final child =
      flightDirection == HeroFlightDirection.push
          ? _heroChild(toHeroContext)
          : _heroChild(fromHeroContext);

  return AnimatedBuilder(
    animation: shuttleAnimation,
    child: child,
    builder: (context, shuttleChild) {
      final borderRadius = BorderRadius.lerp(
        flightDirection == HeroFlightDirection.push
            ? BorderRadius.circular(26.r)
            : BorderRadius.zero,
        flightDirection == HeroFlightDirection.push
            ? BorderRadius.zero
            : BorderRadius.circular(26.r),
        shuttleAnimation.value,
      );

      final opacity =
          flightDirection == HeroFlightDirection.pop
              ? Tween<double>(begin: 1, end: 0).transform(
                Curves.easeOut.transform(
                  shuttleAnimation.value.clamp(0.0, 0.7) / 0.7,
                ),
              )
              : 1.0;

      return Opacity(
        opacity: opacity,
        child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: shuttleChild,
        ),
      );
    },
  );
}

class ServiceDetailView extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;

  const ServiceDetailView({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final serviceController = Get.put(ServiceController(), permanent: true);
    // In your ServiceDetailView
    serviceController.selectService(title);

    return Scaffold(
      body: Stack(
        children: [
          /// Background Hero Image
          Hero(
            tag: _serviceImageHeroTag(title),
            createRectTween: _heroRectTween,
            flightShuttleBuilder: _serviceImageFlightShuttle,
            placeholderBuilder: (context, heroSize, child) => child,
            transitionOnUserGestures: true,
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: context.height,
              fit: BoxFit.cover,
            ),
          ),

          /// Overlay Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.center,
                colors: [
                  Colors.black.withValues(alpha: 0.6),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          /// Glass Back Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: const GlassBackButton(),
            ),
          ),

          /// Glass Bottom Sheet with DraggableScrollableSheet
          DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.2,
            maxChildSize: 0.85,
            builder: (context, scrollController) {
              return SlideInUp(
                duration: const Duration(milliseconds: 1000),
                from: 300, // controls how far below it starts (default is 100)
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                width: 40,
                                height: 4,
                                margin: const EdgeInsets.only(bottom: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.4),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),

                            /// Animated title
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.5, end: 1.0),
                              duration: const Duration(seconds: 3),
                              curve: Curves.easeOutExpo,
                              builder: (context, scale, child) {
                                return Transform.scale(
                                  scale: scale,
                                  child: Hero(
                                    tag: 'title-$title',
                                    flightShuttleBuilder:
                                        _defaultTextFlightShuttle,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Text(
                                        ' $title',
                                        style: const TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),

                            SizedBox(height: 8.h),

                            Obx(() {
                              final categories = serviceController
                                  .getCategories(
                                    serviceController.selectedService.value,
                                  );

                              return TweenAnimationBuilder<Offset>(
                                tween: Tween(
                                  begin: const Offset(-1.5, 0),
                                  end: Offset.zero,
                                ),
                                duration: const Duration(milliseconds: 1000),
                                curve: Curves.easeOut,
                                builder: (context, offset, child) {
                                  return Transform.translate(
                                    offset: Offset(offset.dx * 100, 0),
                                    child:
                                        child!, // ✅ move the Wrap outside the builder
                                  );
                                },
                                child: Wrap(
                                  spacing: 8.w,
                                  runSpacing: 8.h,
                                  children:
                                      categories.map((category) {
                                        return Obx(() {
                                          final isSelected =
                                              serviceController
                                                  .selectedCategory
                                                  .value ==
                                              category;

                                          return GlassChip(
                                            label: category,
                                            isSelected: isSelected,
                                            onTap: () {
                                              serviceController.selectCategory(
                                                category,
                                              );
                                              serviceController
                                                  .updateSubcategories();
                                            },
                                          );
                                        });
                                      }).toList(),
                                ),
                              );
                            }),

                            SizedBox(height: 10.h),

                            TweenAnimationBuilder<Offset>(
                              tween: Tween(
                                begin: const Offset(-1.5, 0),
                                end: Offset.zero,
                              ),
                              duration: const Duration(milliseconds: 1200),
                              curve: Curves.easeOut,
                              builder: (context, offset, child) {
                                return Transform.translate(
                                  offset: Offset(offset.dx * 100, 0),
                                  child: Text(
                                    "This service provides expert care at your doorstep. You can schedule a visit or consultation as per your convenience. Our trained professionals ensure quality and compassion in every interaction.",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.white70,
                                    ),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 24),

                            TweenAnimationBuilder<Offset>(
                              tween: Tween(
                                begin: const Offset(0, 1.5),
                                end: Offset.zero,
                              ),
                              duration: const Duration(milliseconds: 1000),
                              curve: Curves.easeOutBack,
                              builder: (context, offset, child) {
                                return Transform.translate(
                                  offset: Offset(0, offset.dy * 100),
                                  child: child!,
                                );
                              },
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white.withValues(
                                      alpha: 0.2,
                                    ),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  onPressed: () {
                                    Get.toNamed(
                                      Routes.booking,
                                      arguments: {
                                        'title': title,
                                        'category':
                                            serviceController
                                                .selectedCategory
                                                .value,
                                      },
                                    );
                                  },
                                  child: const Text(
                                    "Book Now",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

Widget _defaultTextFlightShuttle(
  BuildContext flightContext,
  Animation<double> animation,
  HeroFlightDirection flightDirection,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
) {
  return DefaultTextStyle(
    style: DefaultTextStyle.of(toHeroContext).style,
    child: toHeroContext.widget,
  );
}
