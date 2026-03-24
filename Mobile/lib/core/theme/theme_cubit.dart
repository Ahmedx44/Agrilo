import 'package:agrilo/core/services/storage_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(_getInitialTheme());

  static ThemeMode _getInitialTheme() {
    final isDark = StorageService.getBool('isDarkMode') ?? true;
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme() {
    final nextTheme = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    StorageService.saveBool('isDarkMode', nextTheme == ThemeMode.dark);
    emit(nextTheme);
  }
}
