import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// [AppSpacing] defines the spacing and padding tokens for the application.
/// Uses [flutter_screenutil] for responsive scaling.
class AppSpacing {
  AppSpacing._();

  // Padding & Margin
  static final double xxs = 2.w;
  static final double xs = 4.w;
  static final double sm = 8.w;
  static final double md = 16.w;
  static final double lg = 24.w;
  static final double xl = 32.w;
  static final double xxl = 48.w;
  static final double xxxl = 64.w;

  // Border Radius
  static final double radiusXs = 4.r;
  static final double radiusSm = 8.r;
  static final double radiusMd = 12.r;
  static final double radiusLg = 16.r;
  static final double radiusXl = 24.r;
  static final double radiusMax = 999.r;

  // Icon Sizes
  static final double iconXs = 16.w;
  static final double iconSm = 20.w;
  static final double iconMd = 24.w;
  static final double iconLg = 32.w;
  static final double iconXl = 48.w;

  // Helper Widgets for spacing
  static Widget get verticalXxs => SizedBox(height: xxs);
  static Widget get verticalXs => SizedBox(height: xs);
  static Widget get verticalSm => SizedBox(height: sm);
  static Widget get verticalMd => SizedBox(height: md);
  static Widget get verticalLg => SizedBox(height: lg);
  static Widget get verticalXl => SizedBox(height: xl);
  static Widget get verticalXxl => SizedBox(height: xxl);

  static Widget get horizontalXxs => SizedBox(width: xxs);
  static Widget get horizontalXs => SizedBox(width: xs);
  static Widget get horizontalSm => SizedBox(width: sm);
  static Widget get horizontalMd => SizedBox(width: md);
  static Widget get horizontalLg => SizedBox(width: lg);
  static Widget get horizontalXl => SizedBox(width: xl);
}
