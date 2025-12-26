import 'package:flutter/material.dart';
import 'package:lab2_rmd/widgets/custom_button.dart';
import 'package:lab2_rmd/utils/app_routes.dart';
import 'package:lab2_rmd/data/local_auth_repository.dart';
import 'package:lab2_rmd/core/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AppUser? user;
  final repo = LocalAuthRepository();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final u = await repo.getUser();
    if (!mounted) return;
    setState(() => user = u);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профіль')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Імʼя: ${user?.name ?? '-'}'),
            Text('Email: ${user?.email ?? '-'}'),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Вийти',
              onPressed: () async {
                await repo.logout(); // лише скидати прапорець
                if (!mounted) return;
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (r) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
