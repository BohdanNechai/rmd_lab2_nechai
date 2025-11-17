import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lab2_rmd/core/device_model.dart';
import 'package:lab2_rmd/core/devices_repo.dart';

class DeviceRemoteRepository implements DeviceRepository {
  final http.Client client;

  DeviceRemoteRepository(this.client);

  @override
  Future<List<DeviceModel>> fetchDevices() async {
    final uri = Uri.parse('https://mocki.io/v1/6d3d9379-c7ee-46c3-84e3-b7c005594a21');
    final res = await client.get(uri);

    if (res.statusCode != 200) {
      throw Exception('Failed to load devices: ${res.statusCode}');
    }

    // ❗ ТУТ ТЕПЕР НЕ Map, а List
    final List decoded = jsonDecode(res.body) as List;

    return decoded.map((e) {
      final m = e as Map<String, dynamic>;
      return DeviceModel(
        id: m['id'].toString(),
        name: m['name'] ?? 'Unknown',
        online: m['online'] ?? false,
      );
    }).toList();
  }

  @override
  Future<void> cacheDevices(List<DeviceModel> list) async {}

  @override
  Future<List<DeviceModel>> readCached() async {
    return [];
  }
}
