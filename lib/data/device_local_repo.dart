import 'dart:convert';
import 'package:lab2_rmd/core/devices_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lab2_rmd/core/device_model.dart';

class DeviceLocalRepository implements DeviceRepository {
  static const _key = 'cached_devices';

  @override
  Future<void> cacheDevices(List<DeviceModel> list) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(list.map((e) => e.toJson()).toList());
    await prefs.setString(_key, jsonStr);
  }

  @override
  Future<List<DeviceModel>> readCached() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final list = (jsonDecode(raw) as List)
        .map((e) => DeviceModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return list;
  }

  @override
  Future<List<DeviceModel>> fetchDevices() async {
    // Локальний репозиторій читає тільки з кешу
    return readCached();
  }

  /// Для демо — якщо кеш пустий, закидаємо кілька пристроїв.
}
