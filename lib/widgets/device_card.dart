import 'package:flutter/material.dart';

// "Практіш, квадратіш" віджет для головного екрану.
// Перевикористовується для відображення різних IoT пристроїв.

class DeviceCard extends StatelessWidget {
  final String deviceName;
  final String status;
  final IconData icon;
  final bool isActive;

  const DeviceCard({
    super.key,
    required this.deviceName,
    required this.status,
    required this.icon,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isActive ? Colors.white : Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 40,
              color: isActive ? Colors.blueGrey[800] : Colors.grey[500],
            ),
            const Spacer(),
            Text(
              deviceName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.black87 : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              status,
              style: TextStyle(
                fontSize: 14,
                color: isActive ? Colors.black54 : Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
