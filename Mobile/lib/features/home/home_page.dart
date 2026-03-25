import 'package:agrilo/features/dashboard/page/dashboard_page.dart';
import 'package:agrilo/features/settings/page/settings_page.dart';
import 'package:agrilo/features/soil/page/soil_analysis_page.dart';
import 'package:agrilo/features/soil/page/soil_history_page.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const DashboardPage(),
      SoilAnalysisPage(onSuccess: () => setState(() => _currentIndex = 0)),
      const SoilHistoryPage(),
      const SettingsPage(),
    ];
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SalomonBottomBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              selectedItemColor:
                  Theme.of(context).brightness == Brightness.light
                  ? const Color(0xFF6B8E23)
                  : Theme.of(context).colorScheme.primary,
              unselectedItemColor: Theme.of(
                context,
              ).colorScheme.onSurface.withOpacity(0.4),
              items: [
                SalomonBottomBarItem(
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedDashboardBrowsing,
                    color: _currentIndex == 0
                        ? (Theme.of(context).brightness == Brightness.light
                              ? const Color(0xFF6B8E23)
                              : Theme.of(context).colorScheme.primary)
                        : Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.4),
                  ),
                  title: const Text('Dashboard'),
                ),
                SalomonBottomBarItem(
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedCctvCamera,
                    color: _currentIndex == 1
                        ? (Theme.of(context).brightness == Brightness.light
                              ? const Color(0xFF6B8E23)
                              : Theme.of(context).colorScheme.primary)
                        : Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.4),
                  ),
                  title: const Text('Scan'),
                ),
                SalomonBottomBarItem(
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedClock01,
                    color: _currentIndex == 2
                        ? (Theme.of(context).brightness == Brightness.light
                              ? const Color(0xFF6B8E23)
                              : Theme.of(context).colorScheme.primary)
                        : Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.4),
                  ),
                  title: const Text('History'),
                ),
                SalomonBottomBarItem(
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedSettings02,
                    color: _currentIndex == 3
                        ? (Theme.of(context).brightness == Brightness.light
                              ? const Color(0xFF6B8E23)
                              : Theme.of(context).colorScheme.primary)
                        : Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.4),
                  ),
                  title: const Text('Settings'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
