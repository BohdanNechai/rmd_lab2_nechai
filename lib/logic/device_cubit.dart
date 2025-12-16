import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab2_rmd/core/device_model.dart';
import 'package:lab2_rmd/data/device_repo_facade.dart';
import 'package:lab2_rmd/logic/device_state.dart';
import 'package:lab2_rmd/services/network_service.dart';

class DeviceCubit extends Cubit<DeviceState> {
  final DeviceRepositoryFacade _repository;

  DeviceCubit(this._repository) : super(const DeviceState());

  Future<void> loadDevices() async {
    emit(state.copyWith(status: DeviceStatus.loading));

    try {
      // Можна тут перевірити інтернет, щоб кинути специфічну помилку або warning
      final hasNet = await NetworkService.hasInternet();
      if (!hasNet) {
        // Можна передати повідомлення, яке UI покаже як SnackBar
        // Але завантаження продовжиться з кешу
      }

      final devices = await _repository.getDevices();
      emit(state.copyWith(status: DeviceStatus.success, devices: devices));
    } catch (e) {
      emit(state.copyWith(status: DeviceStatus.failure, errorMessage: e.toString()));
    }
  }

  void toggleDevice(String id) {
    // Optimistic UI update
    final updatedList = state.devices.map((device) {
      if (device.id == id) {
        return DeviceModel(
          id: device.id,
          name: device.name,
          online: !device.online, // Перемикаємо статус
          type: device.type, // Зберігаємо тип
          value: device.value, // Зберігаємо значення
        );
      }
      return device;
    }).toList();

    emit(state.copyWith(devices: updatedList));

    // Тут можна викликати API для збереження змін:
    // _repository.updateDevice(id, !oldStatus);
  }
}
