import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/widgets/aviation_buttons.dart';
import '../../../../shared/widgets/aviation_cards.dart';
import '../../../../shared/widgets/aviation_elements.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const _HomeDrawer(),
      body: CustomScrollView(
        slivers: [
          const _HomeHero(),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSpacing.verticalLg,
                  const _StatsBar(),
                  const RunwayDivider(label: 'Featured Courses'),
                  const _FeaturedCourses(),
                  const RunwayDivider(label: 'Why Choose Us'),
                  const _WhyChooseUs(),
                  const RunwayDivider(label: 'Fleet Preview'),
                  const _FleetPreview(),
                  const RunwayDivider(label: 'Testimonials'),
                  const _Testimonials(),
                  AppSpacing.verticalXxl,
                  const _CertificationsStrip(),
                  AppSpacing.verticalXxl,
                  PremiumButton(
                    text: 'Enroll Now',
                    onPressed: () => context.push('/contact'),
                  ),
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

class _HomeHero extends StatelessWidget {
  const _HomeHero();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Hero Image Placeholder
            Container(
              color: AppColors.primary,
              child: const Icon(Icons.flight, size: 200, color: Colors.white10),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    AppColors.background,
                  ],
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'SOAR HIGHER',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            letterSpacing: 4,
                          ),
                    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2),
                    Text(
                      'Professional Pilot Training Excellence',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppColors.accent,
                          ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 400.ms, duration: 800.ms).slideY(begin: 0.2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsBar extends StatelessWidget {
  const _StatsBar();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 1.2,
          children: const [
            AnimatedStatCard(value: '500+', label: 'Students', icon: Icons.people),
            AnimatedStatCard(value: '25k+', label: 'Flight Hours', icon: Icons.timer),
            AnimatedStatCard(value: '15+', label: 'Certifications', icon: Icons.verified),
            AnimatedStatCard(value: '10+', label: 'Years Experience', icon: Icons.calendar_today),
          ],
        );
      },
    );
  }
}

class _FeaturedCourses extends StatelessWidget {
  const _FeaturedCourses();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        separatorBuilder: (_, __) => AppSpacing.horizontalMd,
        itemBuilder: (context, index) {
          return AviationCard(
            width: 280,
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  color: AppColors.surface,
                  child: const Center(child: Icon(Icons.school, size: 48, color: AppColors.accent)),
                ),
                Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CourseChip(label: 'PPL', duration: '6 Months'),
                      AppSpacing.verticalXs,
                      Text(
                        'Private Pilot License',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _WhyChooseUs extends StatelessWidget {
  const _WhyChooseUs();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildReason(context, Icons.security, 'Safety First', 'Rigorous safety standards and modern maintenance protocols.'),
        _buildReason(context, Icons.psychology, 'Expert Mentors', 'Industry veterans guiding your every flight.'),
        _buildReason(context, Icons.devices, 'Modern Fleet', 'Training on the latest Cessna and Diamond aircraft.'),
      ],
    );
  }

  Widget _buildReason(BuildContext context, IconData icon, String title, String desc) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.accent),
          ),
          AppSpacing.horizontalMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                Text(desc, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FleetPreview extends StatelessWidget {
  const _FleetPreview();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (_, __) => AppSpacing.horizontalMd,
        itemBuilder: (context, index) {
          return AviationCard(
            width: 200,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: AppColors.surface,
                    child: const Center(child: Icon(Icons.airplanemode_active, color: AppColors.accent)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(AppSpacing.sm),
                  child: Text('Cessna 172S', style: Theme.of(context).textTheme.titleSmall),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Testimonials extends StatelessWidget {
  const _Testimonials();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: PageView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return GlassPanel(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '"The best training I could have asked for. The instructors are top-notch and the equipment is modern."',
                  style: TextStyle(fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
                AppSpacing.verticalSm,
                const PilotAvatar(name: 'John Doe', size: 32),
                AppSpacing.verticalXs,
                const Text('John Doe, CPL Student', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CertificationsStrip extends StatelessWidget {
  const _CertificationsStrip();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        Icon(Icons.verified, size: 40, color: Colors.white24),
        Icon(Icons.verified_user, size: 40, color: Colors.white24),
        Icon(Icons.security, size: 40, color: Colors.white24),
        Icon(Icons.language, size: 40, color: Colors.white24),
      ],
    );
  }
}

class _HomeDrawer extends StatelessWidget {
  const _HomeDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.airplanemode_active, size: 48, color: AppColors.accent),
                AppSpacing.verticalMd,
                Text(
                  'COUGAR AVIATION',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
          _buildItem(context, Icons.home, 'Home', '/'),
          _buildItem(context, Icons.info, 'About Us', '/about'),
          _buildItem(context, Icons.school, 'Courses', '/courses'),
          _buildItem(context, Icons.airplanemode_active, 'Fleet', '/fleet'),
          _buildItem(context, Icons.photo_library, 'Gallery', '/gallery'),
          _buildItem(context, Icons.contact_mail, 'Contact', '/contact'),
          const Divider(color: AppColors.divider),
          _buildItem(context, Icons.person, 'Profile', '/profile'),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon, color: AppColors.accent),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        context.pop();
        context.push(route);
      },
    );
  }
}
