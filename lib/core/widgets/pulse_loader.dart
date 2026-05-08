import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PulseWaveLoader extends StatefulWidget {
  const PulseWaveLoader({super.key});

  @override
  State<PulseWaveLoader> createState() => _PulseWaveLoaderState();
}

class _PulseWaveLoaderState extends State<PulseWaveLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 110,
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          return Stack(
            alignment: Alignment.center,
            children: [
              _wave(controller.value),
              _wave((controller.value + 0.5) % 1),
            ],
          );
        },
      ),
    );
  }

  Widget _wave(double value) {
    final scale = 0.75 + (value * 0.45);
    final opacity = 1.0 - value;

    return Opacity(
      opacity: opacity,
      child: Transform.scale(
        scale: scale,
        child: SvgPicture.asset(
          'assets/svg/output.svg',
          width: 90,
          height: 90,
          colorFilter: const ColorFilter.mode(
            Color(0xFFFF375F),
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
