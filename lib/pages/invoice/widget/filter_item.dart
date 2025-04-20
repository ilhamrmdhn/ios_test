import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utilities/typhography.dart';

class FilterItem extends StatelessWidget {
  FilterItem({
    Key? key,
    required this.text,
    required this.onTap,
    required this.isActive,
    required this.isFirstIndex,
    this.colorText = Colors.green,
    this.bgColor = const Color(0xFFDFF0D8),
  }) : super(key: key);

  final String text;
  final VoidCallback onTap;
  final bool isActive;
  final bool isFirstIndex;
  final Color colorText;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: isFirstIndex ? 16 : 0, right: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: isActive ? colorText : Colors.grey.shade300,
        ),
        color: isActive ? bgColor : Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: SizedBox(
            width: Get.width * 0.25,
            child: Center(
              child: Text(
                text,
                style: TStyle.caption.copyWith(
                  color: isActive ? colorText : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
