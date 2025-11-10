import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../utils/app_routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Використовуємо MediaQuery для отримання розмірів екрану
    // Це потрібно для адаптивності
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // Адаптивний паддінг: більший на планшетах, менший на телефонах
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth > 600 ? screenWidth * 0.2 : 24,
            vertical: 24,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Icon(Icons.home_work_outlined, size: 100, color: Colors.blueGrey[700]),
              const SizedBox(height: 16),
              Text(
                'Вітаємо в Smart Home',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 32),
              const CustomTextField(hintText: 'Email', icon: Icons.email_outlined),
              const SizedBox(height: 16),
              const CustomTextField(
                hintText: 'Пароль',
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Увійти',
                // Навігація на головний екран
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.home);
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                // Навігація на екран реєстрації
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.register);
                },
                child: const Text('Немає акаунту? Зареєструватись'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
