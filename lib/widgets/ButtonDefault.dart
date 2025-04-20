import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kertasinapp/utilities/colors.dart';
import 'package:kertasinapp/utilities/typhography.dart';

import '../controllers/buttonController.dart';

class Buttondefault extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isPrimary;

  Buttondefault({
    super.key,
    required this.text,
    this.onTap,
    this.isPrimary = true,
  });

  final ButtonController controller = Get.put(ButtonController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        onTap: onTap,
        onTapDown: (_) => controller.pressDown(),
        onTapUp: (_) => controller.pressUp(),
        onTapCancel: () => controller.pressUp(),
        child: AnimatedScale(
          scale: controller.scale.value,
          duration: const Duration(milliseconds: 100),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
            decoration: BoxDecoration(
              color: isPrimary ? kColorFirst : kColorPureWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: kColorFirst,
                width: isPrimary ? 0 : 2, // kasih border kalau putih
              ),
            ),
            child: Text(
              text,
              style: TStyle.button1.copyWith(
                color: isPrimary ? kColorPureWhite : kColorFirst,
              ),
            ),
          ),
        ),
      );
    });
  }
}
