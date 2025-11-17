import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lab2_rmd/data/device_local_repo.dart';
import 'package:lab2_rmd/data/device_remote_repo.dart';
import 'package:lab2_rmd/data/device_repo_facade.dart';

import 'package:lab2_rmd/widgets/device_card.dart';
import 'package:lab2_rmd/utils/app_routes.dart';
import 'package:lab2_rmd/core/device_model.dart';

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
    _future = _facade.getDevices();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _facade.getDevices();
    });
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мій Дім'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<List<DeviceModel>>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snap.hasError) {
              return Center(child: Text('Помилка: ${snap.error}'));
            }

            final items = snap.data ?? [];
            if (items.isEmpty) {
              return const Center(child: Text('Немає даних (кеш порожній)'));
            }

            return RefreshIndicator(
              onRefresh: _refresh,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final d = items[i];
                      return DeviceCard(
                        deviceName: d.name,
                        status: d.online ? 'online' : 'offline',
                        icon: d.online ? Icons.lightbulb_outline : Icons.power_settings_new,
                        isActive: d.online,
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
