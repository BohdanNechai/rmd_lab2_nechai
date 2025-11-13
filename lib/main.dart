import 'package:flutter/material.dart';
import 'package:lab2_rmd/screens/login_screen.dart';
import 'package:lab2_rmd/screens/register_screen.dart';
import 'package:lab2_rmd/screens/home_screen.dart';
import 'package:lab2_rmd/screens/profile_screen.dart';
import 'package:lab2_rmd/utils/app_routes.dart';
import 'package:lab2_rmd/screens/splash_screen.dart';

void main() {
  runApp(const SmartHomeApp());
}

class SmartHomeApp extends StatelessWidget {
  const SmartHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Home IoT',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: const Color(0xFFF0F2F5),
        // "Урбаністичний" стиль для кнопок
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        // "Квадратний" стиль для полів вводу
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          prefixIconColor: Colors.blueGrey[600],
        ),
        // "Квадратний" стиль для карток
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      // Використовуємо іменовані роути для навігації
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.register: (_) => const RegisterScreen(),
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.profile: (_) => const ProfileScreen(),
      },

      debugShowCheckedModeBanner: false,
    );
  }
}
