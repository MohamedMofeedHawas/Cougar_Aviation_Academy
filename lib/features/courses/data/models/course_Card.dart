// lib/features/courses/presentation/widgets/course_card.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

import 'course_detail_data.dart';

class CourseCard extends StatefulWidget {
  final CourseDetailData course;
  final VoidCallback? onTap;

  const CourseCard({super.key, required this.course, this.onTap});

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverCtrl;
  late Animation<double> _elevationAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _hoverCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _elevationAnim = Tween<double>(begin: 2, end: 12).animate(
      CurvedAnimation(parent: _hoverCtrl, curve: Curves.easeOut),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _hoverCtrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _hoverCtrl.dispose();
    super.dispose();
  }

  Color get _levelColor {
    switch (widget.course.level.toLowerCase()) {
      case 'beginner':
        return  Colors.yellow;
      case 'intermediate':
        return const Color(0xFF3B82F6);
      case 'advanced':
        return const Color(0xFFF59E0B);
      case 'professional':
        return const Color(0xFFE11D48);
      default:
        return AppColors.accent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _hoverCtrl.forward(),
      onExit: (_) => _hoverCtrl.reverse(),
      child: GestureDetector(
        onTapDown: (_) => _hoverCtrl.forward(),
        onTapUp: (_) {
          _hoverCtrl.reverse();
          widget.onTap?.call();
        },
        onTapCancel: () => _hoverCtrl.reverse(),
        child: AnimatedBuilder(
          animation: _hoverCtrl,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnim.value,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: _elevationAnim.value * 2,
                      offset: Offset(0, _elevationAnim.value * 0.5),
                    ),
                    BoxShadow(
                      color: AppColors.accent
                          .withOpacity(_hoverCtrl.value * 0.12),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: child,
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CourseImageSection(
                imageUrl: widget.course.imageUrl,
                heroTag: 'course_${widget.course.id}',
                label: widget.course.shortLabel,
                level: widget.course.level,
                levelColor: _levelColor,
              ),
              Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.course.name,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    AppSpacing.verticalSm,
                    Text(
                      widget.course.tagline,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    AppSpacing.verticalMd,
                    _CardMetaRow(course: widget.course),
                    AppSpacing.verticalMd,
                    _CardFooter(course: widget.course),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CourseImageSection extends StatelessWidget {
  final String imageUrl;
  final String heroTag;
  final String label;
  final String level;
  final Color levelColor;

  const _CourseImageSection({
    required this.imageUrl,
    required this.heroTag,
    required this.label,
    required this.level,
    required this.levelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: Stack(
        children: [
          // Image
          SizedBox(
            height: 190,
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppColors.surface,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.accent.withOpacity(0.5),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: AppColors.surface,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.flight, size: 48, color: AppColors.accent.withOpacity(0.4)),
                    const SizedBox(height: 8),
                    Text(
                      label,
                      style: TextStyle(
                        color: AppColors.accent.withOpacity(0.6),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Gradient overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.55),
                  ],
                  stops: const [0.5, 1.0],
                ),
              ),
            ),
          ),
          // Label chip (top left)
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
          // Level badge (top right)
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: levelColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: levelColor.withOpacity(0.5)),
              ),
              child: Text(
                level,
                style: TextStyle(
                  color: levelColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardMetaRow extends StatelessWidget {
  final CourseDetailData course;
  const _CardMetaRow({required this.course});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MetaChip(
          icon: Icons.schedule_rounded,
          label: course.duration,
        ),
        AppSpacing.horizontalSm,
        _MetaChip(
          icon: Icons.airplanemode_active_rounded,
          label: 'Florida, USA',
        ),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.accent),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.accent,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CardFooter extends StatelessWidget {
  final CourseDetailData course;
  const _CardFooter({required this.course});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Fleet info
        Expanded(
          child: Row(
            children: [
              Icon(Icons.local_airport_rounded,
                  size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                course.trainingFleet.isNotEmpty
                    ? course.trainingFleet.first
                    : 'Modern Fleet',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        // View detail
        Row(
          children: const [
            Text(
              'View Details',
              style: TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            SizedBox(width: 2),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 12, color: AppColors.accent),
          ],
        ),
      ],
    );
  }
}