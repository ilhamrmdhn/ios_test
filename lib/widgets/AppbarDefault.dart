import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kertasinapp/utilities/colors.dart';

import '../utilities/typhography.dart';

class AppBarDefault extends StatelessWidget {
  const AppBarDefault(
      {Key? key,
      this.actions = const [],
      required this.title,
      this.withLeading = true,
      this.useShadow = true,
      this.bgColor = kColorPureWhite,
      this.textColor = kColorPureBlack,
      this.onTapBack = onTapBackDefault})
      : super(key: key);
  final List<Widget> actions;
  final String title;
  final bool withLeading;
  final bool useShadow;
  final VoidCallback onTapBack;
  final Color bgColor;
  final Color textColor;

  static onTapBackDefault() {
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).viewPadding.top + 16,
        left: withLeading ? 8 : 0,
        right: 16,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: useShadow
            ? [
                BoxShadow(
                  color: kColorPureBlack.withOpacity(0.1),
                  offset: const Offset(0, 0.5),
                  blurRadius: 2,
                )
              ]
            : null,
      ),
      child: Row(
        children: [
          withLeading
              ? Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                )
              : const SizedBox(
                  width: 18,
                ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
              child: Text(
            title,
            style: TStyle.headline3.copyWith(color: textColor),
            overflow: TextOverflow.ellipsis,
          )),
          Container(
            margin: const EdgeInsets.only(left: 8),
            child: Row(
              children: actions,
            ),
          )
        ],
      ),
    );
  }
}
