import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lab2_rmd/core/device_model.dart';
import 'package:lab2_rmd/core/devices_repo.dart';

class DeviceRemoteRepository implements DeviceRepository {
  final http.Client client;

  DeviceRemoteRepository(this.client);

  @override
  Future<List<DeviceModel>> fetchDevices() async {
    final uri = Uri.parse('https://691c7fd93aaeed735c911abf.mockapi.io/devices');

    try {
      final response = await client.get(uri);

      if (response.statusCode == 200) {
        // 2. Декодуємо JSON. Важливо: API повертає List, а не Map
        final data = jsonDecode(response.body) as List<dynamic>;

        return data.map((json) {
          return DeviceModel.fromJson(json as Map<String, dynamic>);
        }).toList();
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Connection failed: $e');
    }
  }

  @override
  Future<void> cacheDevices(List<DeviceModel> list) async {
    // Remote репозиторій не кешує, це робить Local
  }

  @override
  Future<List<DeviceModel>> readCached() async {
    return [];
  }
}
