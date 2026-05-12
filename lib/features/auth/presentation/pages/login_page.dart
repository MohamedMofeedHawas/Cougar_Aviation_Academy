import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/auth_cubit.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/widgets/aviation_buttons.dart';
import '../../../../shared/widgets/aviation_cards.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  state.maybeWhen(
                    authenticated: (_) => context.go('/'),
                    error: (message) => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message), backgroundColor: AppColors.danger),
                    ),
                    orElse: () {},
                  );
                },
                builder: (context, state) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo Placeholder
                        const Icon(Icons.airplanemode_active, size: 80, color: AppColors.accent),
                        AppSpacing.verticalLg,
                        Text(
                          'COUGAR AVIATION',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        AppSpacing.verticalXl,
                        AviationCard(
                          padding: EdgeInsets.all(AppSpacing.lg),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pilot Login',
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                              AppSpacing.verticalMd,
                              TextFormField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  labelText: 'Email Address',
                                  prefixIcon: Icon(Icons.email_outlined),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                              ),
                              AppSpacing.verticalMd,
                              TextFormField(
                                controller: _passwordController,
                                decoration: const InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: Icon(Icons.lock_outline),
                                ),
                                obscureText: true,
                                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                              ),
                              AppSpacing.verticalLg,
                              PremiumButton(
                                text: 'Login',
                                isLoading: state.maybeWhen(loading: () => true, orElse: () => false),
                                onPressed: () {
                                  if (_formKey.currentState?.validate() ?? false) {
                                    context.read<AuthCubit>().login(
                                          _emailController.text,
                                          _passwordController.text,
                                        );
                                  }
                                },
                              ),
                              AppSpacing.verticalMd,
                              Center(
                                child: TextButton(
                                  onPressed: () => context.push('/register'),
                                  child: Text(
                                    "Don't have an account? Register",
                                    style: TextStyle(color: AppColors.accent),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
