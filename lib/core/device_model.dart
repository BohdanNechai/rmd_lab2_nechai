class DeviceModel {
  final String id;
  final String name;
  final bool online;

  const DeviceModel({required this.id, required this.name, required this.online});

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'].toString(),
      name: json['name'] as String? ?? '',
      online: json['online'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'online': online};
}
