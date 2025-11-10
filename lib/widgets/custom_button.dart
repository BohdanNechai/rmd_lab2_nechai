import 'package:flutter/material.dart';

// Цей віджет перевикористовується на екранах логіну, реєстрації та профілю

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color, // Дозволяє кастомізувати колір
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
