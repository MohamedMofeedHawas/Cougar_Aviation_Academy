import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/auth_cubit.dart';
import '../../data/models/user_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/widgets/aviation_cards.dart';
import '../../../../shared/widgets/aviation_buttons.dart';
import '../../../../shared/widgets/aviation_elements.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PILOT PROFILE')),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return state.maybeWhen(
            authenticated: (user) => _buildProfile(context, user),
            orElse: () => const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }

  Widget _buildProfile(BuildContext context, UserModel user) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Center(
            child: Column(
              children: [
                PilotAvatar(name: user.name, size: 100),
                AppSpacing.verticalMd,
                Text(user.name, style: Theme.of(context).textTheme.headlineLarge),
                Text(user.email, style: const TextStyle(color: AppColors.textSecondary)),
              ],
            ),
          ),
          AppSpacing.verticalXl,
          AviationCard(
            child: Column(
              children: [
                FlightDataRow(icon: Icons.person, label: 'Name', value: user.name),
                const FlightDataRow(icon: Icons.flight, label: 'License', value: 'PPL Student'),
                const FlightDataRow(icon: Icons.timer, label: 'Hours Flown', value: '45.5 hrs'),
                const FlightDataRow(icon: Icons.calendar_today, label: 'Join Date', value: 'Jan 2026'),
              ],
            ),
          ),
          AppSpacing.verticalXl,
          PremiumButton(
            text: 'Logout',
            gradient: const LinearGradient(colors: [AppColors.danger, Color(0xFF8B0000)]),
            onPressed: () {
              context.read<AuthCubit>().logout();
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }
}
