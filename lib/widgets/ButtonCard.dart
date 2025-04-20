import 'package:flutter/material.dart';
import 'package:kertasinapp/utilities/colors.dart';
import 'package:kertasinapp/utilities/typhography.dart';

class ButtonCard extends StatelessWidget {
  const ButtonCard({super.key, required this.onTap, required this.text});
  final VoidCallback onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: kColorThird,
        boxShadow: [
          BoxShadow(
            color: kColorPureBlack.withOpacity(0.1),
            offset: const Offset(0, 0.5),
            blurRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18),
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 45, vertical: 8),
                child: Text(
                  text,
                  style: TStyle.captionWhite,
                ),
              ),
            )),
      ),
    );
  }
}
