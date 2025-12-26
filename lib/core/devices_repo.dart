import 'package:lab2_rmd/core/device_model.dart';

abstract class DeviceRepository {
  /// Завантажити список пристроїв (з API або з кешу).
  Future<List<DeviceModel>> fetchDevices();

  /// Зберегти список пристроїв в локальне сховище.
  Future<void> cacheDevices(List<DeviceModel> list);

  /// Прочитати список пристроїв з локального сховища.
  Future<List<DeviceModel>> readCached();
}
