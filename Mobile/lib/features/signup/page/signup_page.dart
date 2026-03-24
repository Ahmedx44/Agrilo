import 'package:agrilo/core/theme/app_colors.dart';
import 'package:agrilo/features/auth/cubit/auth_cubit.dart';
import 'package:agrilo/features/auth/repository/auth_repository.dart';
import 'package:agrilo/features/signup/cubit/signup_cubit.dart';
import 'package:agrilo/features/signup/cubit/signup_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(
        authCubit: context.read<AuthCubit>(),
        authRepository: context.read<AuthRepository>(),
      ),
      child: const SignupView(),
    );
  }
}

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Account'),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      body: BlocListener<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state.status == SignupStatus.success) {
            Navigator.of(context).pop();
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Center(
                  child: Icon(
                    Icons.person_add_rounded,
                    color: AppColors.primary,
                    size: 80,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'Join Agrilo',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Track your soil health with AI',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 48),
                TextField(
                  onChanged: (name) =>
                      context.read<SignupCubit>().fullNameChanged(name),
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  onChanged: (email) =>
                      context.read<SignupCubit>().emailChanged(email),
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                TextField(
                  onChanged: (password) =>
                      context.read<SignupCubit>().passwordChanged(password),
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline_rounded),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 48),
                BlocBuilder<SignupCubit, SignupState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state.status == SignupStatus.loading
                          ? null
                          : () => context.read<SignupCubit>().signup(),
                      child: state.status == SignupStatus.loading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Text('Create Account'),
                    );
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
