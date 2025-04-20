import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:kertasinapp/utilities/assets_constants.dart';

import '../utilities/colors.dart';
import '../utilities/typhography.dart';

class CardNews extends StatelessWidget {
  const CardNews({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height * 0.15,
      margin: EdgeInsets.only(top: 18),
      decoration: BoxDecoration(
        color: kColorPureWhite,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: Get.width * 0.3,
            height: Get.height,
            decoration: BoxDecoration(
              color: kColorGrey,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
            clipBehavior: Clip.hardEdge,
            child: Image.asset(
              AssetsConstant.imgNews,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Kertasin.id",
                    style: TStyle.subtitle2,
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    width: Get.width * 0.6,
                    child: Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus porta mollis suscipit. Donec laoreet laoreet ante, et porta urna faucibus in. Nulla facilisi. Nam dictum augue quis convallis suscipit. Nulla dignissim volutpat magna, in vulputate nisi.",
                      style: TStyle.caption,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
