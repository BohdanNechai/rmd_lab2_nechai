class DeviceModel {
  final String id;
  final String name;
  final bool online;
  final String type;
  final String value;

  const DeviceModel({
    required this.id,
    required this.name,
    required this.online,
    required this.type,
    required this.value,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'].toString(),
      name: json['name']?.toString() ?? 'Unknown',
      // ВИПРАВЛЕННЯ: Явне приведення до (bool?) перед перевіркою на null
      online: (json['online'] as bool?) ?? false,
      type: json['type']?.toString() ?? 'generic',
      value: json['value']?.toString() ?? '',
    );
  }

  // Метод для створення копії об'єкта зі змінами (потрібен для Cubit)
  DeviceModel copyWith({String? id, String? name, bool? online, String? type, String? value}) {
    return DeviceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      online: online ?? this.online,
      type: type ?? this.type,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'online': online,
    'type': type,
    'value': value,
  };
}
