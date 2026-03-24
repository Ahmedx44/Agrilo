import 'package:equatable/equatable.dart';

enum SignupStatus { initial, loading, success, failure }

class SignupState extends Equatable {
  const SignupState({
    this.status = SignupStatus.initial,
    this.errorMessage,
    this.email = '',
    this.password = '',
    this.fullName = '',
  });

  final SignupStatus status;
  final String? errorMessage;
  final String email;
  final String password;
  final String fullName;

  @override
  List<Object?> get props => [status, errorMessage, email, password, fullName];

  SignupState copyWith({
    SignupStatus? status,
    String? errorMessage,
    String? email,
    String? password,
    String? fullName,
  }) {
    return SignupState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      email: email ?? this.email,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
    );
  }
}
