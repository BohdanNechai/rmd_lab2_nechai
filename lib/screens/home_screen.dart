import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lab2_rmd/core/device_model.dart';
import 'package:lab2_rmd/data/device_local_repo.dart';
import 'package:lab2_rmd/data/device_remote_repo.dart';
import 'package:lab2_rmd/data/device_repo_facade.dart';
import 'package:lab2_rmd/services/network_service.dart';
import 'package:lab2_rmd/utils/app_routes.dart';
import 'package:lab2_rmd/widgets/device_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final DeviceRepositoryFacade _facade;
  late Future<List<DeviceModel>> _future;

  @override
  void initState() {
    super.initState();
    _facade = DeviceRepositoryFacade(
      remote: DeviceRemoteRepository(http.Client()),
      local: DeviceLocalRepository(),
    );
    _loadData();
  }

  Future<void> _loadData() async {
    // 1. Запускаємо завантаження даних
    setState(() {
      _future = _facade.getDevices();
    });

    // 2. Перевіряємо інтернет для повідомлення
    final hasNet = await NetworkService.hasInternet();

    if (!hasNet && mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.wifi_off, color: Colors.white),
              SizedBox(width: 12),
              Expanded(child: Text('Немає інтернету. Показано дані з кешу.')),
            ],
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  IconData _getIcon(DeviceModel d) {
    switch (d.type) {
      case 'temperature':
        return Icons.thermostat;

      case 'humidity':
        return Icons.water_drop;

      case 'smoke':
        // Якщо дим є -> Вогонь, якщо "Норма" -> Щит
        return d.value == 'Detected' ? Icons.local_fire_department : Icons.security;

      case 'light':
        // Якщо увімкнено -> Зафарбована, якщо вимкнено -> Контур
        return d.value == 'On' ? Icons.lightbulb : Icons.lightbulb_outline;

      default:
        return Icons.devices;
    }
  }

  String _formatStatus(DeviceModel d) {
    if (!d.online) return 'Offline';
    // Якщо є значення (24.5), показуємо його, інакше просто статус
    if (d.type == 'temperature') return '${d.value}°C';
    if (d.type == 'humidity') return '${d.value}%';
    if (d.type == 'smoke') return d.value == 'Detected' ? 'НЕБЕЗПЕКА!' : 'Норма';
    return d.value.isNotEmpty ? d.value : 'Online';
  }

  bool _isAlert(DeviceModel d) {
    if (!d.online) return false;
    // Логіка тривоги
    if (d.type == 'smoke' && d.value.toLowerCase().contains('detected')) return true;
    if (d.type == 'temperature') {
      final temp = double.tryParse(d.value) ?? 0;
      if (temp > 30) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мій Розумний Дім'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
          ),
        ],
      ),
      body: FutureBuilder<List<DeviceModel>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Помилка: ${snapshot.error}'));
          }

          final devices = snapshot.data ?? [];

          if (devices.isEmpty) {
            return const Center(child: Text('Немає пристроїв'));
          }

          return RefreshIndicator(
            onRefresh: _loadData,
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final device = devices[index];
                return DeviceCard(
                  deviceName: device.name,
                  status: _formatStatus(device),
                  icon: _getIcon(device),
                  isActive: device.online,
                  isAlert: _isAlert(device),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
