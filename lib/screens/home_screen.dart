import 'dart:io'; // Для перевірки платформи
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab2_rmd/logic/device_cubit.dart';
import 'package:lab2_rmd/logic/device_state.dart';
import 'package:lab2_rmd/widgets/device_card.dart';
import 'package:lab2_rmd/utils/app_routes.dart';

import 'package:flashlight_plugin/flashlight_plugin.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _handleSecret(BuildContext context) async {
    if (Platform.isAndroid) {
      try {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Секретне меню 🔦'),
            actions: [
              TextButton(
                onPressed: () {
                  FlashlightPlugin.turnOn();
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Світло увімкнено!')));
                },
                child: const Text('Увімкнути'),
              ),
              TextButton(
                onPressed: () {
                  FlashlightPlugin.turnOff();
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Світло вимкнено!')));
                },
                child: const Text('Вимкнути'),
              ),
            ],
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Помилка: $e')));
      }
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Увага'),
          content: const Text('Функція доступна лише на Android'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Секретна функція на довгому натисканні
        title: GestureDetector(
          onLongPress: () => _handleSecret(context),
          child: const Text('Мій Дім (Затисни мене)'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<DeviceCubit>().loadDevices(),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<DeviceCubit, DeviceState>(
          builder: (context, state) {
            if (state.status == DeviceStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == DeviceStatus.failure) {
              return Center(child: Text('Помилка: ${state.errorMessage}'));
            }
            if (state.devices.isEmpty) {
              return const Center(child: Text('Немає даних'));
            }

            return RefreshIndicator(
              onRefresh: () => context.read<DeviceCubit>().loadDevices(),
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: state.devices.length,
                itemBuilder: (context, i) {
                  final d = state.devices[i];
                  return GestureDetector(
                    onTap: () => context.read<DeviceCubit>().toggleDevice(d.id),
                    child: DeviceCard(
                      deviceName: d.name,
                      status: d.value != null ? d.formattedValue : (d.online ? 'On' : 'Off'),
                      icon: d.online ? Icons.lightbulb : Icons.lightbulb_outline,
                      isActive: d.online,
                    ),
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
