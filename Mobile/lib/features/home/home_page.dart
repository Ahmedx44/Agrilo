import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

// Your existing imports
import 'package:agrilo/core/theme/app_colors.dart';
import 'package:agrilo/features/dashboard/page/dashboard_page.dart';
import 'package:agrilo/features/settings/page/settings_page.dart';
import 'package:agrilo/features/soil/page/soil_analysis_page.dart';
import 'package:agrilo/features/soil/page/soil_history_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DashboardPage(),
    SoilAnalysisPage(),
    SoilHistoryPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: AppColors.primary.withAlpha(20),
              width: 1,
            ),
          ),
        ),
        child: SalomonBottomBar(
          currentIndex: _currentIndex, // Don't forget to pass the current index!
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          // Global styling
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey.withOpacity(0.6),
          items: [
            /// Dashboard
            SalomonBottomBarItem(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedDashboardBrowsing,
                color: _currentIndex == 0 ? AppColors.primary : Colors.grey,
              ),
              title: const Text('Dashboard'),
              selectedColor: AppColors.primary,
            ),

            /// Scan
            SalomonBottomBarItem(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedCctvCamera,
                color: _currentIndex == 1 ? AppColors.primary : Colors.grey,
              ),
              title: const Text('Scan'),
              selectedColor: AppColors.primary,
            ),

            /// History
            SalomonBottomBarItem(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedClock01,
                color: _currentIndex == 2 ? AppColors.primary : Colors.grey,
              ),
              title: const Text('History'),
              selectedColor: AppColors.primary,
            ),

            /// Settings
            SalomonBottomBarItem(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedSettings02,
                color: _currentIndex == 3 ? AppColors.primary : Colors.grey,
              ),
              title: const Text('Settings'),
              selectedColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}