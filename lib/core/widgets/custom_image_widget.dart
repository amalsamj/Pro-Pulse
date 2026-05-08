import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LottieSpeedController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final AnimationController lottieController;

  @override
  void onInit() {
    lottieController = AnimationController(vsync: this);
    super.onInit();
  }

  @override
  void onClose() {
    lottieController.dispose();
    super.onClose();
  }
}

class UniversalImage extends StatelessWidget {
  final String path;
  final double? height;
  final double? width;
  final double scale; // 👈 Add this

  UniversalImage({
    super.key,
    required this.path,
    this.height,
    this.width,
    this.scale = 1.0, // Default scale
  });

  final controller = Get.put(LottieSpeedController());

  bool get isLottie => path.endsWith(".json");
  bool get isSvg => path.endsWith(".svg");
  bool get isNetwork => path.startsWith("http");

  @override
  Widget build(BuildContext context) {
    final widget = _buildImageWidget();

    return Transform.scale(
      scale: scale,
      child: widget,
    );
  }

  Widget _buildImageWidget() {
    if (isLottie) {
      return isNetwork
          ? Lottie.network(
        path,
        height: height,
        width: width,
        controller: controller.lottieController,
        onLoaded: (composition) {
          controller.lottieController
            ..duration = composition.duration
            ..repeat(min: 0, max: 1, period: composition.duration * 3);
        },
      )
          : Lottie.asset(
        path,
        height: height,
        width: width,
        controller: controller.lottieController,
        onLoaded: (composition) {
          controller.lottieController
            ..duration = composition.duration
            ..repeat(min: 0, max: 1, period: composition.duration * 2);
        },
      );
    } else if (isSvg) {
      return isNetwork
          ? SvgPicture.network(path, height: height, width: width)
          : SvgPicture.asset(path, height: height, width: width);
    } else {
      return isNetwork
          ? Image.network(path, height: height, width: width)
          : Image.asset(path, height: height, width: width);
    }
  }
}


