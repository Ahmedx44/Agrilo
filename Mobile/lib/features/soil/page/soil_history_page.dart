import 'package:agrilo/core/theme/app_colors.dart';
import 'package:agrilo/features/soil/cubit/soil_history_cubit.dart';
import 'package:agrilo/features/soil/cubit/soil_history_state.dart';
import 'package:agrilo/features/soil/repository/soil_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SoilHistoryPage extends StatelessWidget {
  const SoilHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SoilHistoryCubit(
        repository: context.read<SoilRepository>(),
      )..loadHistory(),
      child: const SoilHistoryView(),
    );
  }
}

class SoilHistoryView extends StatelessWidget {
  const SoilHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Past Scans'),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<SoilHistoryCubit, SoilHistoryState>(
        builder: (context, state) {
          if (state.status == SoilHistoryStatus.loading || state.status == SoilHistoryStatus.initial) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          } else if (state.status == SoilHistoryStatus.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: AppColors.error, size: 64),
                  const SizedBox(height: 16),
                  Text(state.errorMessage ?? 'Failed to load history'),
                ],
              ),
            );
          }

          if (state.history.isEmpty) {
            return const Center(
              child: Text(
                'No past soil scans found.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              ),
            );
          }

          return RefreshIndicator(
            color: AppColors.primary,
            backgroundColor: Theme.of(context).colorScheme.surface,
            onRefresh: () => context.read<SoilHistoryCubit>().loadHistory(),
            child: ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: state.history.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = state.history[index] as Map<String, dynamic>;
                final dateStr = item['createdAt'] as String?;
                final date = dateStr != null ? DateTime.tryParse(dateStr) : null;
                final formattedDate = date != null ? DateFormat('MMM d, yyyy • h:mm a').format(date.toLocal()) : 'Unknown Date';

                final indicators = item['indicators'] as Map<String, dynamic>? ?? {};
                final moisture = indicators['moisture'] ?? 0;
                final ph = indicators['pH'] ?? 0.0;

                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primary.withAlpha(20), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formattedDate,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const Icon(Icons.history_rounded, size: 20, color: AppColors.primary),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildMetric(context, 'pH Level', ph.toString(), Icons.science_outlined),
                          _buildMetric(context, 'Moisture', '$moisture%', Icons.water_drop_outlined),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetric(BuildContext context, String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.onSurface),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
