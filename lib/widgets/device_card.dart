import 'package:flutter/material.dart';

class DeviceCard extends StatelessWidget {
  final String deviceName;
  final String status;
  final IconData icon;
  final bool isActive;
  final bool isAlert; // Повертаємо параметр тривоги

  const DeviceCard({
    super.key,
    required this.deviceName,
    required this.status,
    required this.icon,
    required this.isActive,
    this.isAlert = false, // За замовчуванням false
  });

  @override
  Widget build(BuildContext context) {
    // Логіка кольорів: Тривога -> Червоний, Активний -> Білий, Офлайн -> Сірий
    final bgColor = isAlert ? Colors.red[100] : (isActive ? Colors.white : Colors.grey[200]);

    final iconColor = isAlert ? Colors.red : (isActive ? Colors.blueGrey[800] : Colors.grey[500]);

    final textColor = isAlert ? Colors.red[900] : (isActive ? Colors.black87 : Colors.grey[600]);

    return Card(
      color: bgColor,
      elevation: isAlert ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isAlert ? const BorderSide(color: Colors.red, width: 2) : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: iconColor),
            const SizedBox(height: 12),
            Text(
              deviceName,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 4),
            Text(
              status,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isAlert ? FontWeight.bold : FontWeight.normal,
                color: textColor?.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
