import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // 1. Додано для Bloc/Cubit
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Імпорти твоїх класів (перевір шляхи, якщо вони відрізняються)
import 'package:lab2_rmd/data/device_local_repo.dart';
import 'package:lab2_rmd/data/device_remote_repo.dart';
import 'package:lab2_rmd/data/device_repo_facade.dart';
import 'package:lab2_rmd/logic/device_cubit.dart';

import 'package:lab2_rmd/screens/login_screen.dart';
import 'package:lab2_rmd/screens/register_screen.dart';
import 'package:lab2_rmd/screens/home_screen.dart';
import 'package:lab2_rmd/screens/profile_screen.dart';
import 'package:lab2_rmd/utils/app_routes.dart';
import 'package:lab2_rmd/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Ініціалізуємо зовнішні сервіси
  final prefs = await SharedPreferences.getInstance();
  final client = http.Client();

  // 3. Створюємо репозиторій ОДИН РАЗ (Вимога лаби про Singleton)
  final deviceRepository = DeviceRepositoryFacade(
    remote: DeviceRemoteRepository(client, prefs),
    local: DeviceLocalRepository(),
  );

  runApp(SmartHomeApp(deviceRepository: deviceRepository));
}

class SmartHomeApp extends StatelessWidget {
  final DeviceRepositoryFacade deviceRepository;

  const SmartHomeApp({super.key, required this.deviceRepository});

  @override
  Widget build(BuildContext context) {
    // 4. Впроваджуємо залежності (Dependency Injection)
    return RepositoryProvider.value(
      value: deviceRepository, // Робимо репозиторій доступним всюди
      child: BlocProvider(
        // Створюємо Cubit і одразу запускаємо завантаження даних
        create: (context) => DeviceCubit(deviceRepository)..loadDevices(),
        child: MaterialApp(
          title: 'Smart Home IoT',
          debugShowCheckedModeBanner: false,

          // Твій стиль (без змін)
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blueGrey,
            scaffoldBackgroundColor: const Color(0xFFF0F2F5),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              prefixIconColor: Colors.blueGrey[600],
            ),
            cardTheme: CardThemeData(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),

          // Навігація
          initialRoute: AppRoutes.splash,
          routes: {
            AppRoutes.splash: (_) => const SplashScreen(),
            AppRoutes.login: (_) => const LoginScreen(),
            AppRoutes.register: (_) => const RegisterScreen(),
            AppRoutes.home: (_) => const HomeScreen(),
            AppRoutes.profile: (_) => const ProfileScreen(),
          },
        ),
      ),
    );
  }
}
