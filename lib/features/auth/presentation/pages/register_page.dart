import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/auth_cubit.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/widgets/aviation_buttons.dart';
import '../../../../shared/widgets/aviation_cards.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _questionController.dispose();
    _answerController.dispose();
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
                        Text(
                          'JOIN THE SQUADRON',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        AppSpacing.verticalXl,
                        AviationCard(
                          padding: EdgeInsets.all(AppSpacing.lg),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Create Account',
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                              AppSpacing.verticalMd,
                              TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: 'Full Name',
                                  prefixIcon: Icon(Icons.person_outline),
                                ),
                                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
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
                              AppSpacing.verticalMd,
                              TextFormField(
                                controller: _questionController,
                                decoration: const InputDecoration(
                                  labelText: 'Security Question',
                                  hintText: 'e.g., First flight instructor?',
                                  prefixIcon: Icon(Icons.help_outline),
                                ),
                                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                              ),
                              AppSpacing.verticalMd,
                              TextFormField(
                                controller: _answerController,
                                decoration: const InputDecoration(
                                  labelText: 'Answer',
                                  prefixIcon: Icon(Icons.verified_user_outlined),
                                ),
                                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                              ),
                              AppSpacing.verticalLg,
                              PremiumButton(
                                text: 'Register',
                                isLoading: state.maybeWhen(loading: () => true, orElse: () => false),
                                onPressed: () {
                                  if (_formKey.currentState?.validate() ?? false) {
                                    context.read<AuthCubit>().register(
                                          _nameController.text,
                                          _emailController.text,
                                          _passwordController.text,
                                          _questionController.text,
                                          _answerController.text,
                                        );
                                  }
                                },
                              ),
                              AppSpacing.verticalMd,
                              Center(
                                child: TextButton(
                                  onPressed: () => context.pop(),
                                  child: Text(
                                    "Already have an account? Login",
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
