import 'package:flutter/material.dart';
import 'package:kertasinapp/model/home/item_navbar_model.dart';
import 'package:kertasinapp/utilities/colors.dart';
import 'package:kertasinapp/utilities/typhography.dart';

class ItemNavbar extends StatelessWidget {
  const ItemNavbar({
    Key? key,
    required this.onTap,
    required this.isActive,
    required this.model,
  }) : super(key: key);

  final VoidCallback onTap;
  final bool isActive;
  final ItemNavbarModel model;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              model.icon.icon != null
                  ? Icon(
                      model.icon.icon,
                      size: 28,
                      color: isActive ? kColorMediumGrey : kColorPureWhite,
                    )
                  : const SizedBox(height: 28),
              const SizedBox(height: 4),
              Text(
                model.title,
                style: TStyle.appbar.copyWith(
                    color: isActive ? kColorMediumGrey : kColorPureWhite,
                    fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
