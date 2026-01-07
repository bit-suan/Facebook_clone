import 'package:facebook_clone/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  const RoundButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.color = AppColors.lightBlueColor,
    this.textColor,
    this.borderSide,
    this.height = 50,
  });

  final VoidCallback? onPressed;
  final String label;
  final Color color;
  final Color? textColor;
  final BorderSide? borderSide;
  final double height;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(25),
          border: Border.fromBorderSide(
            borderSide ?? const BorderSide(color: AppColors.darkBlueColor),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: textColor ?? ((color == AppColors.lightBlueColor && onPressed != null)
                  ? AppColors.realWhiteColor
                  : AppColors.darkBlueColor),
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
