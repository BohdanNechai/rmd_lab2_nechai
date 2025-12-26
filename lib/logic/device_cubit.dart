import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab2_rmd/core/device_model.dart';
import 'package:lab2_rmd/data/device_repo_facade.dart';
import 'package:lab2_rmd/logic/device_state.dart';

class DeviceCubit extends Cubit<DeviceState> {
  final DeviceRepositoryFacade _repository;

  // Репозиторій приходить сюди через конструктор
  DeviceCubit(this._repository) : super(const DeviceState());

  // Завантаження даних (замінює FutureBuilder)
  Future<void> loadDevices() async {
    emit(state.copyWith(status: DeviceStatus.loading));

    try {
      final devices = await _repository.getDevices();
      emit(state.copyWith(
        status: DeviceStatus.success,
        devices: devices,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DeviceStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  // Приклад логіки зміни стану (наприклад, увімкнути/вимкнути світло)
  void toggleDevice(String id) {
    // Оновлюємо список локально (Optimistic UI)
    final updatedList = state.devices.map((device) {
      if (device.id == id) {
        // Створюємо копію девайсу з протилежним статусом
        return DeviceModel(
          id: device.id,
          name: device.name,
          online: !device.online, // Зміна тут
          icon: device.icon,
          value: device.value,
        );
      }
      return device;
    }).toList();

    // Емітимо новий список
    emit(state.copyWith(devices: updatedList));

    // Тут можна додати виклик API: _repository.updateDevice(...)
  }
}