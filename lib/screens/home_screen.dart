import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab2_rmd/logic/device_cubit.dart';
import 'package:lab2_rmd/logic/device_state.dart';
import 'package:lab2_rmd/widgets/device_card.dart';
import 'package:lab2_rmd/utils/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мій Дім'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            // Виклик логіки через Cubit
            onPressed: () => context.read<DeviceCubit>().loadDevices(),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
          ),
        ],
      ),
      body: SafeArea(
        // Слухаємо зміни стану
        child: BlocBuilder<DeviceCubit, DeviceState>(
          builder: (context, state) {
            // 1. Завантаження
            if (state.status == DeviceStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            // 2. Помилка
            if (state.status == DeviceStatus.failure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Помилка: ${state.errorMessage}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => context.read<DeviceCubit>().loadDevices(),
                      child: const Text('Спробувати ще раз'),
                    ),
                  ],
                ),
              );
            }

            final items = state.devices;

            // 3. Порожній список
            if (items.isEmpty) {
              return const Center(child: Text('Немає даних (кеш порожній)'));
            }

            // 4. Дані є
            return RefreshIndicator(
              onRefresh: () => context.read<DeviceCubit>().loadDevices(),
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

                      return GestureDetector(
                        // Приклад інтерактивності: клік по картці змінює статус
                        onTap: () => context.read<DeviceCubit>().toggleDevice(d.id),
                        child: DeviceCard(
                          deviceName: d.name,
                          // Логіка відображення статусу збережена з твого коду
                          status: d.value != null
                              ? d.formattedValue
                              : (d.online ? 'Active' : 'Offline'),
                          icon: d.online ? Icons.lightbulb_outline : Icons.power_settings_new,
                          isActive: d.online,
                        ),
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
