import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/widgets/aviation_cards.dart';
import '../../../../shared/widgets/aviation_elements.dart';
import '../../../../shared/widgets/aviation_indicators.dart';

class CourseCard extends StatelessWidget {
  final VoidCallback? onTap;

  const CourseCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return AviationCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 160,
            width: double.infinity,
            color: AppColors.surface,
            child: const Center(child: Icon(Icons.school, size: 64, color: AppColors.accent)),
          ),
          Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CourseChip(label: 'PPL', duration: '6 Months'),
                    AltitudeBadge(label: 'Level 1'),
                  ],
                ),
                AppSpacing.verticalMd,
                Text(
                  'Private Pilot License',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                AppSpacing.verticalSm,
                Text(
                  'Start your aviation journey with the foundation of flight.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                AppSpacing.verticalMd,
                Row(
                  children: [
                    const Icon(Icons.airplanemode_active, size: 16, color: AppColors.accent),
                    AppSpacing.horizontalXs,
                    const Text('Cessna 172', style: TextStyle(fontSize: 12)),
                    const Spacer(),
                    Text('Learn More', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
                    const Icon(Icons.chevron_right, size: 16, color: AppColors.accent),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
