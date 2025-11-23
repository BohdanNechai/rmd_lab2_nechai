import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lab2_rmd/core/user.dart';
import 'package:lab2_rmd/core/auth_repository.dart';

class LocalAuthRepository implements AuthRepository {
  static const _key = 'app_user';
  static const _loginKey = 'is_logged_in';

  @override
  Future<void> register(AppUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(user.toJson()));
    await prefs.setBool(_loginKey, false); // після реєстрації не логінити автоматично
  }

  @override
  Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return false;

    final user = AppUser.fromJson(jsonDecode(raw));
    final success = user.email == email && user.password == password;
    await prefs.setBool(_loginKey, success);
    return success;
  }

  @override
  Future<AppUser?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;
    return AppUser.fromJson(jsonDecode(raw));
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loginKey) ?? false;
  }

  @override
  Future<void> updateUser(AppUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(user.toJson()));
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loginKey, false);
  }
}
