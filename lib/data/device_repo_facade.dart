import 'package:lab2_rmd/core/device_model.dart';
import 'package:lab2_rmd/core/devices_repo.dart';
import 'package:lab2_rmd/data/device_local_repo.dart';
import 'package:lab2_rmd/services/network_service.dart';

class DeviceRepositoryFacade {
  final DeviceRepository remote;
  final DeviceLocalRepository local;

  DeviceRepositoryFacade({required this.remote, required this.local});

  Future<List<DeviceModel>> getDevices() async {
    // 1. Засідуємо локальні дані, якщо пусто

    try {
      final hasNet = await NetworkService.hasInternet();
      if (hasNet) {
        final fresh = await remote.fetchDevices();
        await local.cacheDevices(fresh);
        return fresh;
      }
      // якщо інтернету нема → беремо кеш
      return await local.readCached();
    } catch (_) {
      // якщо API впало → теж кеш
      return await local.readCached();
    }
  }
}
