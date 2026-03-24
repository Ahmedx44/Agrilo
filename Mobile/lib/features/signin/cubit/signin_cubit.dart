import 'package:agrilo/core/services/toast_service.dart';
import 'package:agrilo/features/auth/cubit/auth_cubit.dart';
import 'package:agrilo/features/auth/repository/auth_repository.dart';
import 'package:agrilo/features/signin/cubit/signin_state.dart';
import 'package:bloc/bloc.dart';

class SigninCubit extends Cubit<SigninState> {
  SigninCubit({
    required AuthCubit authCubit,
    required AuthRepository authRepository,
  })  : _authCubit = authCubit,
        _authRepository = authRepository,
        super(const SigninState());

  final AuthCubit _authCubit;
  final AuthRepository _authRepository;

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: SigninStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: SigninStatus.initial));
  }

  void signin() async {
    if (state.email.isEmpty || state.password.isEmpty) {
      final msg = 'Email and password are required';
      ToastService.showError(msg);
      emit(state.copyWith(
        status: SigninStatus.failure,
        errorMessage: msg,
      ));
      return;
    }

    emit(state.copyWith(status: SigninStatus.loading));

    try {
      final result = await _authRepository.login(state.email, state.password);
      
      _authCubit.login(result['token']!);
      
      ToastService.showSuccess('Signed in successfully');
      emit(state.copyWith(status: SigninStatus.success));
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      ToastService.showError(msg);
      emit(state.copyWith(
        status: SigninStatus.failure,
        errorMessage: msg,
      ));
    }
  }
}
