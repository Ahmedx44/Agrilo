import 'package:agrilo/core/services/storage_service.dart';
import 'package:agrilo/features/auth/cubit/auth_state.dart';
import 'package:agrilo/features/auth/repository/auth_repository.dart';
import 'package:bloc/bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthState());

  final AuthRepository _authRepository;

  Future<void> checkAuth() async {
    // Show splash screen for at least 2 seconds
    await Future<void>.delayed(const Duration(seconds: 2));

    if (StorageService.hasToken()) {
      final token = StorageService.getToken()!;
      _authRepository.setAuthToken(token);
      emit(state.copyWith(status: AuthStatus.authenticated));
    } else {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  void login(String token) async {
    await StorageService.saveToken(token);
    _authRepository.setAuthToken(token);
    emit(state.copyWith(status: AuthStatus.authenticated));
  }

  void logout() async {
    await StorageService.removeToken();
    _authRepository.clearAuthToken();
    emit(state.copyWith(status: AuthStatus.unauthenticated));
  }
}
