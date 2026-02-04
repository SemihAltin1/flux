import 'package:flutter/material.dart';
import 'package:flux/config/assets/app_images.dart';
import 'package:flux/config/theme/app_colors.dart';

final class CustomDialogs {

  static void showSuccessDialog(BuildContext context, String title, String message) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          content: Column(
            mainAxisSize: .min,
            children: [
              Image.asset(
                AppImages.check,
                width: 70,
                height: 70,
              ),
              const SizedBox(height: 5),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: .bold,
                ),
              ),
              Text(message, textAlign: .center),
              const SizedBox(height: 20),

              GestureDetector(
                onTap: () => Navigator.pop(dialogContext),
                child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    color: theme.textTheme.bodyMedium?.color,
                    borderRadius: .circular(10),
                  ),
                  alignment: .center,
                  child: const FittedBox(
                    child: Text(
                      "Back",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static void showErrorDialog(BuildContext context, String title, String message) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          content: Column(
            mainAxisSize: .min,
            children: [
              Image.asset(
                AppImages.error,
                width: 70,
                height: 70,
              ),
              const SizedBox(height: 5),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: .bold,
                ),
              ),
              Text(message, textAlign: .center),
              const SizedBox(height: 20),

              GestureDetector(
                onTap: () => Navigator.pop(dialogContext),
                child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    color: theme.textTheme.bodyMedium?.color,
                    borderRadius: .circular(10),
                  ),
                  alignment: .center,
                  child: const FittedBox(
                    child: Text(
                      "Back",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static void showConfirmationDialog(BuildContext context, String title, String message, String actionTitle, Function() onTap) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          content: Column(
            mainAxisSize: .min,
            children: [
              Image.asset(
                AppImages.question,
                width: 70,
                height: 70,
              ),
              const SizedBox(height: 5),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: .bold,
                ),
              ),
              Text(message, textAlign: .center),
              const SizedBox(height: 20),

              GestureDetector(
                onTap: () => Navigator.pop(dialogContext),
                child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    color: theme.textTheme.bodyMedium?.color,
                    borderRadius: .circular(10),
                  ),
                  alignment: .center,
                  child: const FittedBox(
                    child: Text(
                      "Back",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              GestureDetector(
                onTap: () {
                  Navigator.pop(dialogContext);
                  onTap();
                },
                child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: .circular(10),
                  ),
                  alignment: .center,
                  child: FittedBox(
                    child: Text(
                      actionTitle,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}