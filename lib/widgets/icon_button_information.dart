import 'package:flutter/material.dart';
import 'package:rewes/constants/app_colors.dart';

class CustomIconButton extends StatelessWidget {
  final IconData? icon;

  const CustomIconButton({
    Key? key,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: AppColors.secondaryAccent.withAlpha(80)),
      child: Material(
        borderRadius: BorderRadius.circular(24),
        type: MaterialType.transparency,
        clipBehavior: Clip.hardEdge,
        child: IconButton(
          color: AppColors.primaryWhiteColor,
          iconSize: 18,
          icon: Icon(
            icon ?? Icons.menu_open,
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
