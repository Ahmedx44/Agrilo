import 'dart:ffi';

import 'package:agrilo/core/theme/app_colors.dart';
import 'package:agrilo/core/services/storage_service.dart';
import 'package:agrilo/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:agrilo/features/dashboard/cubit/dashboard_state.dart';
import 'package:agrilo/features/dashboard/repository/dashboard_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardCubit(
        repository: context.read<DashboardRepository>(),
      )..fetchDashboard(),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _selectedTab = 0;

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning!';
    if (hour < 17) return 'Good Afternoon!';
    return 'Good Evening!';
  }

  String _getFirstName() {
    final name = StorageService.getUserName() ?? 'Farmer';
    return name.split(' ').first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            return RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: Theme.of(context).colorScheme.surface,
              onRefresh: () => context.read<DashboardCubit>().fetchDashboard(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello ${_getFirstName()},',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _greeting(),
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.notifications_outlined, color: AppColors.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Tab switcher
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          _buildTab('Soil Overview', 0),
                          _buildTab('Scan Overview', 1),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    if (state.status == DashboardStatus.loading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: CircularProgressIndicator(color: AppColors.primary),
                        ),
                      )
                    else if (state.status == DashboardStatus.failure)
                      _buildError(context, state.errorMessage)
                    else ...[
                      // Main lime card
                      if (_selectedTab == 0)
                        _buildSoilOverviewCard(context, state)
                      else
                        _buildScanOverviewCard(context, state),

                      const SizedBox(height: 24),

                      // Bottom stat cards
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              context,
                              icon: Icons.science_rounded,
                              value: '${state.totalTests}',
                              label: 'Total tests',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildStatCard(
                              context,
                              icon: Icons.sentiment_satisfied_alt_rounded,
                              value: '${state.avgMoisture}%',
                              label: 'Avg moisture',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              context,
                              icon: Icons.water_drop_outlined,
                              value: '${state.avgPH}',
                              label: 'Avg pH level',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildStatCard(
                              context,
                              icon: Icons.eco_outlined,
                              value: '${state.avgNutrients['N'] ?? 0}',
                              label: 'Avg Nitrogen',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final selected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: selected
                ? [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 8)]
                : [],
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: selected ? FontWeight.bold : FontWeight.w500,
              color: selected
                  ? Colors.black87
                  : Theme.of(context).textTheme.bodyMedium?.color,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSoilOverviewCard(BuildContext context, DashboardState state) {
    final latestScan = state.latestScan;
    String timeAgo = 'No scans yet';
    if (latestScan != null) {
      final dateStr = latestScan['createdAt'] as String?;
      if (dateStr != null) {
        final date = DateTime.tryParse(dateStr);
        if (date != null) {
          final diff = DateTime.now().difference(date.toLocal());
          if (diff.inDays > 0) {
            timeAgo = '${diff.inDays} Day${diff.inDays > 1 ? 's' : ''} ago';
          } else if (diff.inHours > 0) {
            timeAgo = '${diff.inHours} Hour${diff.inHours > 1 ? 's' : ''} ago';
          } else {
            timeAgo = 'Just now';
          }
        }
      }
    }

    final moisture = latestScan?['moisture'] ?? 0;
    final ph = latestScan?['pH'] ?? 0.0;
    final nutrients = latestScan?['nutrients'] as Map<String, dynamic>? ?? {};
    final n = nutrients['N'] ?? 0;
    final p = nutrients['P'] ?? 0;
    final k = nutrients['K'] ?? 0;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Soil Overview',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.thermostat_outlined, color: Colors.black87, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildTag(Icons.calendar_today_outlined, timeAgo),
              const SizedBox(width: 8),
              _buildTag(Icons.grass_rounded, 'Latest Scan'),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // pH
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$ph',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Text('PH', style: TextStyle(fontSize: 12, color: Colors.black54)),
                ],
              ),
              const SizedBox(width: 20),
              // Moisture bar
              _buildNutrientBar('Moisture',  moisture, 100),
              const SizedBox(width: 10),
              _buildNutrientBar('Nitrogen', n.toDouble(), 100),
              const SizedBox(width: 10),
              _buildNutrientBar('Potassium', k.toDouble(), 100),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMiniStat('Moisture', '$moisture%'),
              _buildMiniStat('Nitrogen', '$n'),
              _buildMiniStat('Phosphorus', '$p'),
              _buildMiniStat('Potassium', '$k'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScanOverviewCard(BuildContext context, DashboardState state) {
    final history = state.history;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Scan Overview',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 16),
          if (history.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('No scan history yet.', style: TextStyle(color: Colors.black54)),
              ),
            )
          else
            ...history.take(5).map((scan) {
              final dateStr = scan['date'] as String?;
              final date = dateStr != null ? DateTime.tryParse(dateStr) : null;
              final label = date != null ? DateFormat('MMM d').format(date.toLocal()) : '—';
              final moisture = scan['moisture'] as int? ?? 0;
              final ph = scan['pH'];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Text(label,
                            style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87))),
                    Expanded(
                      flex: 5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: moisture / 100,
                          minHeight: 10,
                          backgroundColor: Colors.black.withAlpha(20),
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.black87),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text('pH $ph', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildTag(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.black87),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildNutrientBar(String label, dynamic value, double max) {
    final ratio = (value / max).clamp(0.0, 1.0);
    final height = 60.0 + double.parse(ratio.toString()) * 40.0;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('${value.toInt()}%', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black)),
        const SizedBox(height: 4),
        Container(
          width: 36,
          height: height,
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(20 + (double.parse(ratio.toString()) * 60).toInt()),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.black54)),
      ],
    );
  }

  Widget _buildMiniStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14)),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.black54)),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, {required IconData icon, required String value, required String label}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String? msg) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          const Icon(Icons.error_outline, color: AppColors.error, size: 64),
          const SizedBox(height: 16),
          Text(msg ?? 'Failed to load dashboard', textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<DashboardCubit>().fetchDashboard(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
