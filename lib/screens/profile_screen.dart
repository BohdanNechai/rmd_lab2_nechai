import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../utils/app_routes.dart';
import '../data/local_auth_repository.dart';
import '../core/user.dart';

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
    user = await repo.getUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Профіль')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              child: Icon(Icons.person_outline, size: 50),
            ),
            const SizedBox(height: 16),
            Text(user!.name, style: Theme.of(context).textTheme.headlineSmall),
            Text(user!.email),

            const Spacer(),

            CustomButton(
              text: 'Вийти',
              color: Colors.red,
              onPressed: () async {
                await repo.logout();
                Navigator.pushNamedAndRemoveUntil(
                    context, AppRoutes.login, (_) => false);
              },
            )
          ],
        ),
      ),
    );
  }
}
