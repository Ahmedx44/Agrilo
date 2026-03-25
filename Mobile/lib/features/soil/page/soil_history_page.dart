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
            return Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary));
          } else if (state.status == SoilHistoryStatus.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error, size: 64),
                  const SizedBox(height: 16),
                  Text(state.errorMessage ?? 'Failed to load history'),
                ],
              ),
            );
          }

          if (state.history.isEmpty) {
            return Center(
              child: Text(
                'No past soil scans found.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  fontSize: 16,
                ),
              ),
            );
          }

          return RefreshIndicator(
            color: Theme.of(context).colorScheme.primary,
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
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formattedDate,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Icon(
                            Icons.history_rounded,
                            size: 20,
                            color: Theme.of(context).brightness == Brightness.light
                                ? const Color(0xFF6B8E23)
                                : Theme.of(context).colorScheme.primary,
                          ),
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
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
