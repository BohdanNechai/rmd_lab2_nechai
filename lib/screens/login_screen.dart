import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../utils/app_routes.dart';
import '../data/local_auth_repository.dart';
import '../core/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _repo = LocalAuthRepository();

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await _repo.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Невірний логін або пароль')),
      );
      return;
    }

    Navigator.pushNamed(context, AppRoutes.home);
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Icon(Icons.home_work_outlined, size: 100, color: Colors.blueGrey[700]),
                const SizedBox(height: 32),

                CustomTextField(
                  hintText: 'Email',
                  icon: Icons.email_outlined,
                  controller: _emailController,
                  validator: Validators.email,
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  hintText: 'Пароль',
                  icon: Icons.lock_outline,
                  controller: _passwordController,
                  isPassword: true,
                  validator: Validators.password,
                ),

                const SizedBox(height: 32),

                CustomButton(
                  text: 'Увійти',
                  onPressed: _login,
                ),

                const SizedBox(height: 16),

                TextButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
                  child: const Text('Немає акаунту? Зареєструватись'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
