import 'package:equatable/equatable.dart';
import 'package:lab2_rmd/core/device_model.dart';

enum DeviceStatus { initial, loading, success, failure }

class DeviceState extends Equatable {
  final DeviceStatus status;
  final List<DeviceModel> devices;
  final String? errorMessage;

  const DeviceState({
    this.status = DeviceStatus.initial,
    this.devices = const [],
    this.errorMessage,
  });

  // Метод для створення копії стану зі змінами
  DeviceState copyWith({DeviceStatus? status, List<DeviceModel>? devices, String? errorMessage}) {
    return DeviceState(
      status: status ?? this.status,
      devices: devices ?? this.devices,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, devices, errorMessage];
}
