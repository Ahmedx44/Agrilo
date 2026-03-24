import 'package:equatable/equatable.dart';

enum SigninStatus { initial, loading, success, failure }

class SigninState extends Equatable {
  const SigninState({
    this.status = SigninStatus.initial,
    this.errorMessage,
    this.email = '',
    this.password = '',
  });

  final SigninStatus status;
  final String? errorMessage;
  final String email;
  final String password;

  @override
  List<Object?> get props => [status, errorMessage, email, password];

  SigninState copyWith({
    SigninStatus? status,
    String? errorMessage,
    String? email,
    String? password,
  }) {
    return SigninState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
