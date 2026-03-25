import 'dart:io';

import 'package:agrilo/core/services/api_client.dart';
import 'package:agrilo/core/services/app_global_context.dart';
import 'package:agrilo/core/services/toast_service.dart';
import 'package:agrilo/core/theme/app_theme.dart';
import 'package:agrilo/core/theme/theme_cubit.dart';
import 'package:agrilo/features/auth/cubit/auth_cubit.dart';
import 'package:agrilo/features/auth/cubit/auth_state.dart';
import 'package:agrilo/features/auth/repository/auth_repository.dart';
import 'package:agrilo/features/home/home_page.dart';
import 'package:agrilo/features/signin/page/signin_page.dart';
import 'package:agrilo/features/splash/splash_page.dart';
import 'package:agrilo/features/dashboard/repository/dashboard_repository.dart';
import 'package:agrilo/features/soil/repository/soil_repository.dart';
import 'package:agrilo/l10n/l10n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    AppGlobalContext.setContext(context);
    
    final apiClient = ApiClient.create(baseUrl: 'http://192.168.0.101:4000');
    
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(apiClient: apiClient),
        ),
        RepositoryProvider(
          create: (context) => DashboardRepository(apiClient: apiClient),
        ),
        RepositoryProvider(
          create: (context) => SoilRepository(apiClient: apiClient),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthCubit(
              authRepository: context.read<AuthRepository>(),
            )..checkAuth(),
          ),
          BlocProvider(
            create: (context) => ThemeCubit(),
          ),
        ],
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp(
              scaffoldMessengerKey: ToastService.scaffoldMessengerKey,
              themeMode: themeMode,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  if (state.status == AuthStatus.initial) {
                    return const SplashPage();
                  } else if (state.status == AuthStatus.authenticated) {
                    return const HomePage();
                  }
                  return const SigninPage();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
