import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../core/validators.dart';
import '../core/user.dart';
import '../data/local_auth_repository.dart';
import '../utils/app_routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final repo = LocalAuthRepository();

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (_pass.text.trim() != _confirm.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Паролі не співпадають')),
      );
      return;
    }

    final user = AppUser(
      name: _name.text.trim(),
      email: _email.text.trim(),
      password: _pass.text.trim(),
    );

    await repo.register(user);

    Navigator.pushNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text('Створити акаунт')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: w > 600 ? w * 0.2 : 24,
            vertical: 24,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  hintText: 'Імʼя',
                  icon: Icons.person_outline,
                  controller: _name,
                  validator: Validators.name,
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  hintText: 'Email',
                  icon: Icons.email_outlined,
                  controller: _email,
                  validator: Validators.email,
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  hintText: 'Пароль',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  controller: _pass,
                  validator: Validators.password,
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  hintText: 'Підтвердіть пароль',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  controller: _confirm,
                ),

                const SizedBox(height: 32),

                CustomButton(
                  text: 'Зареєструватись',
                  onPressed: _register,
                  color: const Color(0xFF062AF2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
