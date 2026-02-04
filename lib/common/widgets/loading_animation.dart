import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';

final class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.4),
      alignment: .center,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: .circular(20),
        ),
        alignment: .center,
        child: const CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}