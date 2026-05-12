import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/widgets/aviation_cards.dart';
import '../../../../shared/widgets/aviation_elements.dart';
import '../widgets/course_card.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OUR COURSES')),
      body: ListView.separated(
        padding: EdgeInsets.all(AppSpacing.lg),
        itemCount: 6,
        separatorBuilder: (_, __) => AppSpacing.verticalMd,
        itemBuilder: (context, index) {
          return CourseCard(
            onTap: () => context.push('/courses/$index'),
          );
        },
      ),
    );
  }
}

class CourseDetailPage extends StatelessWidget {
  final String id;
  const CourseDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CourseChip(label: 'PPL', duration: '6 Months'),
                  AppSpacing.verticalMd,
                  Text('Private Pilot License', style: Theme.of(context).textTheme.displaySmall),
                  AppSpacing.verticalLg,
                  _buildTabs(context),
                  AppSpacing.verticalXxl,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'course_$id',
          child: Container(
            color: AppColors.primary,
            child: const Icon(Icons.school, size: 100, color: Colors.white10),
          ),
        ),
      ),
    );
  }

  Widget _buildTabs(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: AppColors.accent,
            labelColor: AppColors.accent,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Syllabus'),
              Tab(text: 'Requirements'),
              Tab(text: 'Aircraft'),
            ],
          ),
          SizedBox(
            height: 400,
            child: TabBarView(
              children: [
                _buildOverview(),
                _buildSyllabus(),
                _buildRequirements(),
                _buildAircraft(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverview() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: const Text(
        'The Private Pilot License (PPL) is the first step for any aspiring pilot. This course provides the foundational knowledge and flying skills required to operate a single-engine aircraft safely and proficiently.',
        style: TextStyle(height: 1.6),
      ),
    );
  }

  Widget _buildSyllabus() {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
      children: [
        _buildModule('Module 1: Air Law'),
        _buildModule('Module 2: Aircraft General Knowledge'),
        _buildModule('Module 3: Flight Performance and Planning'),
        _buildModule('Module 4: Human Performance'),
      ],
    );
  }

  Widget _buildModule(String title) {
    return ListTile(
      leading: const Icon(Icons.check_circle, color: AppColors.success, size: 20),
      title: Text(title),
    );
  }

  Widget _buildRequirements() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Column(
        children: [
          const FlightDataRow(icon: Icons.cake, label: 'Minimum Age', value: '17 Years'),
          const FlightDataRow(icon: Icons.medical_services, label: 'Medical Certificate', value: 'Class 2'),
          const FlightDataRow(icon: Icons.language, label: 'Language', value: 'ICAO Level 4'),
        ],
      ),
    );
  }

  Widget _buildAircraft() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: AviationCard(
        child: Column(
          children: [
            const Icon(Icons.airplanemode_active, size: 64, color: AppColors.accent),
            AppSpacing.verticalMd,
            const Text('Cessna 172 Skyhawk', style: TextStyle(fontWeight: FontWeight.bold)),
            const Text('The world\'s most popular training aircraft.', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
