class DeviceModel {
  final String id;
  final String name;
  final bool online;
  final String icon;
  final String? value;

  const DeviceModel({
    required this.id,
    required this.name,
    required this.online,
    required this.icon,
    this.value,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    // 1. Шукаємо значення в різних можливих полях
    final rawValue = json['value'] ?? json['temperature'] ?? json['humidity'] ?? json['status'];

    // 2. Безпечно перетворюємо в String, навіть якщо прийшло число (int/double)
    String? parsedValue;
    if (rawValue != null) {
      parsedValue = rawValue.toString();
    }

    return DeviceModel(
      id: json['id'].toString(),
      name: (json['deviceIotHomeName'] ?? json['name'] ?? 'Unknown Device') as String,
      online: (json['available'] ?? json['online'] ?? false) as bool,
      icon: json['icon'] as String? ?? '',
      value: parsedValue, // Тепер тут точно буде рядок або null
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'deviceIotHomeName': name,
    'available': online,
    'icon': icon,
    'value': value,
  };

  // 💡 Додатковий геттер для красивого відображення з одиницями виміру
  String get formattedValue {
    if (value == null) return '';
    // Елементарна логіка: якщо в назві є "Temp", додаємо градуси
    if (name.toLowerCase().contains('temp') || name.toLowerCase().contains('thermostat')) {
      return '$value°C';
    }
    // Якщо вологість
    if (name.toLowerCase().contains('humidity')) {
      return '$value%';
    }
    return value!;
  }
}
