import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';

/// [RadarWidget] is an animated radar sweep widget.
/// It uses a [CustomPainter] to draw the radar lines and the sweep effect.
class RadarWidget extends StatefulWidget {
  final double size;
  const RadarWidget({super.key, this.size = 200});

  @override
  State<RadarWidget> createState() => _RadarWidgetState();
}

class _RadarWidgetState extends State<RadarWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _RadarPainter(_controller.value),
        );
      },
    );
  }
}

class _RadarPainter extends CustomPainter {
  final double angle;
  _RadarPainter(this.angle);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..color = AppColors.accent.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw circles
    canvas.drawCircle(center, radius, paint);
    canvas.drawCircle(center, radius * 0.66, paint);
    canvas.drawCircle(center, radius * 0.33, paint);

    // Draw crosshair lines
    canvas.drawLine(Offset(center.dx - radius, center.dy), Offset(center.dx + radius, center.dy), paint);
    canvas.drawLine(Offset(center.dx, center.dy - radius), Offset(center.dx, center.dy + radius), paint);

    // Draw sweep
    final sweepShader = SweepGradient(
      center: Alignment.center,
      startAngle: 0.0,
      endAngle: math.pi * 2,
      colors: [
        AppColors.accent.withOpacity(0.0),
        AppColors.accent.withOpacity(0.5),
      ],
      stops: const [0.75, 1.0],
      transform: GradientRotation(angle * math.pi * 2),
    ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, Paint()..shader = sweepShader);
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) => true;
}

/// [AltitudeBadge] is an aviation-themed chip that displays altitude or status.
class AltitudeBadge extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? color;

  const AltitudeBadge({
    super.key,
    required this.label,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
      decoration: BoxDecoration(
        color: (color ?? AppColors.accent).withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
        border: Border.all(color: (color ?? AppColors.accent).withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color ?? AppColors.accent),
            AppSpacing.horizontalXs,
          ],
          Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: color ?? AppColors.accent,
                  fontSize: 10,
                  letterSpacing: 1.2,
                ),
          ),
        ],
      ),
    );
  }
}
