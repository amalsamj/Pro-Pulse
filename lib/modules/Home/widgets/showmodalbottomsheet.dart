import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ServiceDetailBottomSheet extends StatelessWidget {
  final String title;
  final String subtitle;

  const ServiceDetailBottomSheet({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.5,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1.2,
                ),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Drag handle
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    /// Hero Animated Title
                    Hero(
                      tag: 'title-$title',
                      child: Material(
                        color: Colors.transparent,
                        child: Text(title,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )
                            .animate(delay: 100.ms)
                            .fadeIn(duration: 600.ms)
                            .slideY(begin: 0.3),
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// Hero Animated Subtitle
                    Hero(
                      tag: 'subtitle-$title',
                      child: Material(
                        color: Colors.transparent,
                        child: Text(subtitle,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                        )
                            .animate(delay: 300.ms)
                            .fadeIn(duration: 700.ms)
                            .slideX(begin: 0.2),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// Service Details Title
                    const Text(
                      "Service Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    )
                        .animate(delay: 500.ms)
                        .fadeIn()
                        .slideY(begin: 0.2),

                    const SizedBox(height: 8),

                    /// Description
                    const Text(
                      "This service provides expert care at your doorstep. You can schedule a visit or consultation as per your convenience. Our trained professionals ensure quality and compassion in every interaction.",
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    )
                        .animate(delay: 600.ms)
                        .fadeIn()
                        .slideY(begin: 0.1),

                    const SizedBox(height: 24),

                    /// Book Now Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          // Booking logic
                        },
                        child: const Text(
                          "Book Now",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ).animate(delay: 800.ms).fadeIn().scale(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

