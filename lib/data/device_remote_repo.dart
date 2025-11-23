import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lab2_rmd/core/device_model.dart';
import 'package:lab2_rmd/core/devices_repo.dart';
import 'package:shared_preferences/src/shared_preferences_legacy.dart';

class DeviceRemoteRepository implements DeviceRepository {
  final http.Client client;

  DeviceRemoteRepository(this.client, SharedPreferences prefs);

  @override
  Future<List<DeviceModel>> fetchDevices() async {
    final uri = Uri.parse('https://691c7fd93aaeed735c911ab  f.mockapi.io/devices');

    final res = await client.get(uri);

    if (res.statusCode != 200) {
      throw Exception('Failed to load devices: ${res.statusCode}');
    }

    final List decoded = jsonDecode(res.body) as List;

    // Використовуємо фабрику fromJson, щоб правильно розпарсити іконки та значення
    return decoded.map((e) => DeviceModel.fromJson(e)).toList();
  }

  // Методи кешування залишаємо пустими
  @override
  Future<void> cacheDevices(List<DeviceModel> list) async {}

  @override
  Future<List<DeviceModel>> readCached() async {
    return [];
  }
}
