import 'package:agrilo/core/services/toast_service.dart';
import 'package:agrilo/features/auth/cubit/auth_cubit.dart';
import 'package:agrilo/features/auth/repository/auth_repository.dart';
import 'package:agrilo/features/signup/cubit/signup_state.dart';
import 'package:bloc/bloc.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit({
    required AuthCubit authCubit,
    required AuthRepository authRepository,
  })  : _authCubit = authCubit,
        _authRepository = authRepository,
        super(const SignupState());

  final AuthCubit _authCubit;
  final AuthRepository _authRepository;

  void fullNameChanged(String value) {
    emit(state.copyWith(fullName: value, status: SignupStatus.initial));
  }

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: SignupStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: SignupStatus.initial));
  }

  void signup() async {
    if (state.email.isEmpty || state.password.isEmpty || state.fullName.isEmpty) {
      final msg = 'All fields are required';
      ToastService.showError(msg);
      emit(state.copyWith(
        status: SignupStatus.failure,
        errorMessage: msg,
      ));
      return;
    }

    emit(state.copyWith(status: SignupStatus.loading));

    try {
      final result = await _authRepository.register(
        state.fullName,
        state.email,
        state.password,
      );
      
      _authCubit.login(result['token']!);
      
      ToastService.showSuccess('Account created successfully');
      emit(state.copyWith(status: SignupStatus.success));
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      ToastService.showError(msg);
      emit(state.copyWith(
        status: SignupStatus.failure,
        errorMessage: msg,
      ));
    }
  }
}
