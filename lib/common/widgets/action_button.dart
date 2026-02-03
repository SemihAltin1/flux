import 'package:flutter/material.dart';
import 'package:flux/config/theme/app_colors.dart';

final class ActionButton extends StatelessWidget {
  final String title;
  final Function onTap;
  const ActionButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: .circular(10),
        ),
        alignment: .center,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: .w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}