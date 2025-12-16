import 'package:flutter/material.dart';
import 'package:lab2_rmd/widgets/custom_text_field.dart';
import 'package:lab2_rmd/widgets/custom_button.dart';
import 'package:lab2_rmd/utils/app_routes.dart';
import 'package:lab2_rmd/data/local_auth_repository.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final repo = LocalAuthRepository();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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

              CustomTextField(
                hintText: 'Email',
                icon: Icons.email_outlined,
                controller: _emailController,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                hintText: 'Пароль',
                icon: Icons.lock_outline,
                isPassword: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 32),

              CustomButton(
                text: 'Увійти',
                onPressed: () async {
                  final success = await repo.login(
                    _emailController.text.trim(),
                    _passwordController.text.trim(),
                  );

                  if (success) {
                    Navigator.pushReplacementNamed(context, AppRoutes.home);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Невірні дані')),
                    );
                  }
                },
              ),

              const SizedBox(height: 16),

              TextButton(
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
