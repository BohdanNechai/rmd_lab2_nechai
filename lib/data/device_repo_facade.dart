import 'package:lab2_rmd/core/device_model.dart';
import 'package:lab2_rmd/core/devices_repo.dart';
import 'package:lab2_rmd/data/device_local_repo.dart';
import 'package:lab2_rmd/services/network_service.dart'; // Твій сервіс перевірки мережі

class DeviceRepositoryFacade {
  final DeviceRepository remote;
  final DeviceLocalRepository local;

  DeviceRepositoryFacade({required this.remote, required this.local});

  Future<List<DeviceModel>> getDevices() async {
    try {
      // 1. Перевіряємо інтернет
      final hasInternet = await NetworkService.hasInternet();

      if (hasInternet) {
        // 2. Є інтернет -> качаємо свіжі дані
        final devices = await remote.fetchDevices();

        // 3. Зберігаємо їх у кеш (оновлюємо локальні дані)
        await local.cacheDevices(devices);

        return devices;
      } else {
        // 4. Немає інтернету -> беремо з кешу
        print('No internet. Fetching from local cache...');
        return await local.readCached();
      }
    } catch (e) {
      // 5. Якщо помилка сервера -> теж пробуємо кеш
      print('Error fetching remote: $e');
      return await local.readCached();
    }
  }
}
