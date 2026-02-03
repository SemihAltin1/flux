import 'package:flutter/material.dart';

final class DefaultInput extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final String? hint;
  final bool? isPassword;
  final bool? isEnable;

  const DefaultInput({
    super.key,
    required this.title,
    required this.controller,
    this.hint,
    this.isPassword,
    this.isEnable,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: .w500,
          ),
        ),
        TextField(
          controller: controller,
          style: const TextStyle(fontSize: 14),
          obscureText: isPassword ?? false,
          decoration: InputDecoration(hintText: hint),
          enabled: isEnable ?? true,
        ),
      ],
    );
  }
}