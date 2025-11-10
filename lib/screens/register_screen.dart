import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../utils/app_routes.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Створити акаунт'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth > 600 ? screenWidth * 0.2 : 24,
            vertical: 24,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CustomTextField(hintText: 'Імʼя', icon: Icons.person_outline),
              const SizedBox(height: 16),
              const CustomTextField(hintText: 'Email', icon: Icons.email_outlined),
              const SizedBox(height: 16),
              const CustomTextField(
                hintText: 'Пароль',
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 16),
              const CustomTextField(
                hintText: 'Підтвердьте пароль',
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Зареєструватись',
                // Навігація назад на екран логіну
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Вже є акаунт? Увійти'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
