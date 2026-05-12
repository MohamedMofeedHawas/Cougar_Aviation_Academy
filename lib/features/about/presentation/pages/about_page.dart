import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/widgets/aviation_cards.dart';
import '../../../../shared/widgets/aviation_elements.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const _AboutHeader(),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Our Story',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  AppSpacing.verticalMd,
                  const Text(
                    'Cougar Aviation Academy was founded with a single mission: to provide the highest quality flight training in a professional and safe environment. Over the years, we have grown into one of the most respected aviation schools in the region, training hundreds of pilots who now fly for major airlines worldwide.',
                    style: TextStyle(height: 1.6),
                  ),
                  AppSpacing.verticalXl,
                  const _MissionVisionValues(),
                  const RunwayDivider(label: 'Milestones'),
                  const _Timeline(),
                  const RunwayDivider(label: 'Leadership'),
                  const _Leadership(),
                  const RunwayDivider(label: 'Instructors'),
                  const _InstructorGrid(),
                  AppSpacing.verticalXxl,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutHeader extends StatelessWidget {
  const _AboutHeader();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text('ABOUT US'),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(color: AppColors.primary),
            const Center(child: Icon(Icons.history_edu, size: 100, color: Colors.white10)),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, AppColors.background],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MissionVisionValues extends StatelessWidget {
  const _MissionVisionValues();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCard(context, 'Our Mission', 'To empower the next generation of aviators with superior training and safety excellence.', Icons.rocket_launch),
        AppSpacing.verticalMd,
        _buildCard(context, 'Our Vision', 'To be the global benchmark for professional pilot education and aviation innovation.', Icons.visibility),
        AppSpacing.verticalMd,
        _buildCard(context, 'Our Values', 'Safety, Integrity, Excellence, and Professionalism in every flight.', Icons.star),
      ],
    );
  }

  Widget _buildCard(BuildContext context, String title, String desc, IconData icon) {
    return GlassPanel(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accent, size: 32),
          AppSpacing.horizontalMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.accent)),
                Text(desc),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildStep(context, '2015', 'Academy Founded', 'Started with 2 aircraft and a small team of instructors.'),
        _buildStep(context, '2018', 'EASA Certification', 'Achieved European Union Aviation Safety Agency certification.'),
        _buildStep(context, '2021', 'Fleet Expansion', 'Added modern Diamond DA42 aircraft to our fleet.'),
        _buildStep(context, '2023', 'Global Partnership', 'Signed training agreements with 3 major international airlines.'),
      ],
    );
  }

  Widget _buildStep(BuildContext context, String year, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
            ),
            Container(width: 2, height: 60, color: AppColors.border),
          ],
        ),
        AppSpacing.horizontalMd,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(year, style: Theme.of(context).textTheme.labelLarge),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              Text(desc, style: Theme.of(context).textTheme.bodyMedium),
              AppSpacing.verticalMd,
            ],
          ),
        ),
      ],
    );
  }
}

class _Leadership extends StatelessWidget {
  const _Leadership();

  @override
  Widget build(BuildContext context) {
    return AviationCard(
      child: Row(
        children: [
          const PilotAvatar(name: 'Capt. Alex Smith', size: 80),
          AppSpacing.horizontalLg,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Capt. Alex Smith', style: Theme.of(context).textTheme.titleLarge),
                const Text('Chief Executive Officer', style: TextStyle(color: AppColors.accent)),
                AppSpacing.verticalSm,
                const Text('Former airline captain with over 15,000 flight hours and 20 years of aviation management experience.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InstructorGrid extends StatelessWidget {
  const _InstructorGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return AviationCard(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const PilotAvatar(name: 'Instructor Name', size: 60),
              AppSpacing.verticalMd,
              Text('Instructor ${index + 1}', style: Theme.of(context).textTheme.titleMedium),
              const Text('Senior Flight Instructor', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
        );
      },
    );
  }
}
