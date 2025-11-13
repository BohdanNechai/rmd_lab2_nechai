import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/user.dart';
import '../core/auth_repository.dart';

class LocalAuthRepository implements AuthRepository {
  static const _key = 'app_user';

  @override
  Future<void> register(AppUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(user.toJson()));
  }

  @override
  Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return false;

    final user = AppUser.fromJson(jsonDecode(raw));
    return user.email == email && user.password == password;
  }

  @override
  Future<AppUser?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;
    return AppUser.fromJson(jsonDecode(raw));
  }

  @override
  Future<void> updateUser(AppUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(user.toJson()));
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
