import 'package:flutter/material.dart';
import '../widgets/device_card.dart';
import '../utils/app_routes.dart';

// Цей екран демонструє вашу ідею "Smart Home"
// Він використовує LayoutBuilder та GridView для адаптивності

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мій Дім'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            // Навігація на екран профілю
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.profile);
            },
          ),
        ],
      ),
      body: SafeArea(
        // LayoutBuilder дає нам 'constraints' (обмеження)
        // які ми використовуємо для визначення кількості колонок
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Адаптивність: 2 колонки на телефоні, 4 на планшеті
            int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0, // Робить картки квадратними
              ),
              itemCount: 6, // Кількість пристроїв
              itemBuilder: (context, index) {
                // Mock-дані для пристроїв
                // Тут ми перевикористовуємо наш DeviceCard
                final devices = [
                  const DeviceCard(
                    deviceName: 'Вітальня',
                    status: 'Увімкнено',
                    icon: Icons.lightbulb_outline,
                    isActive: true,
                  ),
                  const DeviceCard(
                    deviceName: 'Спальня',
                    status: '21°C',
                    icon: Icons.thermostat_outlined,
                    isActive: true,
                  ),
                  const DeviceCard(
                    deviceName: 'Вхідні двері',
                    status: 'Замкнено',
                    icon: Icons.lock_outline,
                    isActive: true,
                  ),
                  const DeviceCard(
                    deviceName: 'Гараж',
                    status: 'Вимкнено',
                    icon: Icons.garage_outlined,
                    isActive: false,
                  ),
                  const DeviceCard(
                    deviceName: 'Кухня',
                    status: 'Вимкнено',
                    icon: Icons.coffee_maker_outlined,
                    isActive: false,
                  ),
                  const DeviceCard(
                    deviceName: 'Камера',
                    status: 'Запис...',
                    icon: Icons.videocam_outlined,
                    isActive: true,
                  ),
                ];
                return devices[index];
              },
            );
          },
        ),
      ),
    );
  }
}
