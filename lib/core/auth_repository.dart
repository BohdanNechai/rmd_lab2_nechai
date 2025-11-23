import 'package:lab2_rmd/core/user.dart';

abstract class AuthRepository {
  Future<void> register(AppUser user);
  Future<bool> login(String email, String password);
  Future<AppUser?> getUser();
  Future<void> updateUser(AppUser user);
  Future<void> logout();
}
