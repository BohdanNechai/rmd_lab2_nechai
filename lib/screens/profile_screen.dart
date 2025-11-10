import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../utils/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профіль'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blueGrey,
                child: Icon(Icons.person_outline, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                'Імʼя Користувача',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                'user@example.com',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              const Divider(),
              // Можна додати більше налаштувань сюди
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Налаштування'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.notifications_outlined),
                title: const Text('Сповіщення'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.security_outlined),
                title: const Text('Безпека'),
                onTap: () {},
              ),
              const Divider(),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Вийти з акаунту',
                color: Colors.red[400], // Кастомний колір для кнопки
                onPressed: () {
                  // Повертаємось на екран логіну і видаляємо всі інші екрани
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.login,
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
