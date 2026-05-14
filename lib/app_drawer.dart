// lib/shared/widgets/app_drawer.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DATA
// ─────────────────────────────────────────────────────────────────────────────

class _NavItem {
  final IconData icon;
  final String label;
  final String route;
  final String? badge;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.route,
    this.badge,
  });
}

const _mainItems = [
  _NavItem(icon: Icons.home_rounded, label: 'Home', route: '/'),
  _NavItem(icon: Icons.info_outline_rounded, label: 'About Us', route: '/about'),
  _NavItem(
      icon: Icons.school_rounded,
      label: 'Courses',
      route: '/courses',
      badge: '4'),
  _NavItem(
      icon: Icons.airplanemode_active_rounded,
      label: 'Fleet',
      route: '/fleet'),

  _NavItem(
      icon: Icons.hotel,
      label: 'Accommodations',
      route: '/accommodations'),

  _NavItem(
      icon: Icons.photo_library_rounded,
      label: 'Gallery',
      route: '/gallery'),
  _NavItem(
      icon: Icons.contact_mail_rounded,
      label: 'Contact Us',
      route: '/contact'),
];

const _secondaryItems = [
  _NavItem(icon: Icons.person_rounded, label: 'Profile', route: '/profile'),
  _NavItem(
      icon: Icons.settings_rounded, label: 'Settings', route: '/settings'),
];

// ─────────────────────────────────────────────────────────────────────────────
// MAIN DRAWER
// ─────────────────────────────────────────────────────────────────────────────

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _masterCtrl;

  // Header animations
  late Animation<double> _headerFade;
  late Animation<Offset> _logoSlide;
  late Animation<double> _logoScale;
  late Animation<Offset> _titleSlide;
  late Animation<double> _titleFade;
  late Animation<double> _dividerExpand;

  String? _activeRoute;

  @override
  void initState() {
    super.initState();

    _masterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    // Header
    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _masterCtrl,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );
    _logoSlide = Tween<Offset>(
      begin: const Offset(-0.4, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _masterCtrl,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOutCubic),
    ));
    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterCtrl,
        curve: const Interval(0.0, 0.45, curve: Curves.elasticOut),
      ),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(-0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _masterCtrl,
      curve: const Interval(0.1, 0.5, curve: Curves.easeOutCubic),
    ));
    _titleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _masterCtrl,
        curve: const Interval(0.1, 0.5, curve: Curves.easeOut),
      ),
    );
    _dividerExpand = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _masterCtrl,
        curve: const Interval(0.3, 0.55, curve: Curves.easeOut),
      ),
    );

    _masterCtrl.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _activeRoute = GoRouterState.of(context).uri.toString();
  }

  @override
  void dispose() {
    _masterCtrl.dispose();
    super.dispose();
  }

  void _navigate(String route) {
    Navigator.of(context).pop();
    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) context.push(route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 290,
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A1628),
              Color(0xFF0D1F35),
              Color(0xFF091422),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // ── Background decorative elements ──────────────────────
            _DrawerBackground(),

            // ── Content ─────────────────────────────────────────────
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _DrawerHeader(
                    fadeAnim: _headerFade,
                    logoSlide: _logoSlide,
                    logoScale: _logoScale,
                    titleSlide: _titleSlide,
                    titleFade: _titleFade,
                    dividerExpand: _dividerExpand,
                  ),

                  // Main nav items
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),

                          // Section label
                          _SectionLabel(
                            label: 'NAVIGATION',
                            masterCtrl: _masterCtrl,
                            intervalStart: 0.35,
                          ),
                          const SizedBox(height: 6),

                          // Main items
                          ..._mainItems.asMap().entries.map((e) {
                            return _AnimatedDrawerItem(
                              item: e.value,
                              index: e.key,
                              masterCtrl: _masterCtrl,
                              baseInterval: 0.50,
                              isActive: _activeRoute == e.value.route,
                              onTap: () => _navigate(e.value.route),
                            );
                          }),

                          const SizedBox(height: 14),

                          // Divider
                          _AnimatedDivider(
                            masterCtrl: _masterCtrl,
                            intervalStart: 0.75,
                          ),

                          const SizedBox(height: 14),

                          // Section label
                          _SectionLabel(
                            label: 'ACCOUNT',
                            masterCtrl: _masterCtrl,
                            intervalStart: 0.76,
                          ),
                          const SizedBox(height: 6),

                          // Secondary items
                          ..._secondaryItems.asMap().entries.map((e) {
                            return _AnimatedDrawerItem(
                              item: e.value,
                              index: _mainItems.length + e.key,
                              masterCtrl: _masterCtrl,
                              baseInterval: 0.78,
                              isActive: _activeRoute == e.value.route,
                              onTap: () => _navigate(e.value.route),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  // Footer
                  _DrawerFooter(
                    masterCtrl: _masterCtrl,
                    onTap: () => _navigate('/courses'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BACKGROUND DECORATIVE LAYER
// ─────────────────────────────────────────────────────────────────────────────

class _DrawerBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            // Top-right glow
            Positioned(
              right: -60,
              top: -60,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.accent.withOpacity(0.12),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Bottom-left glow
            Positioned(
              left: -40,
              bottom: 60,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.accent.withOpacity(0.07),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Diagonal accent line
            Positioned.fill(
              child: CustomPaint(painter: _DiagonalLinePainter()),
            ),
          ],
        ),
      ),
    );
  }
}

class _DiagonalLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accent.withOpacity(0.04)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Subtle diagonal lines
    for (int i = -4; i < 6; i++) {
      final startX = size.width * 0.5 + i * 80.0;
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX - size.height * 0.3, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// HEADER
// ─────────────────────────────────────────────────────────────────────────────

class _DrawerHeader extends StatelessWidget {
  final Animation<double> fadeAnim;
  final Animation<Offset> logoSlide;
  final Animation<double> logoScale;
  final Animation<Offset> titleSlide;
  final Animation<double> titleFade;
  final Animation<double> dividerExpand;

  const _DrawerHeader({
    required this.fadeAnim,
    required this.logoSlide,
    required this.logoScale,
    required this.titleSlide,
    required this.titleFade,
    required this.dividerExpand,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnim,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo + icon row
            SlideTransition(
              position: logoSlide,
              child: ScaleTransition(
                scale: logoScale,
                child: Row(
                  children: [
                    // Logo image
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent.withOpacity(0.25),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          'assets/images/cougar_img.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            decoration: BoxDecoration(
                              color: AppColors.accent.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.airplanemode_active_rounded,
                              color: AppColors.accent,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Title
                    SlideTransition(
                      position: titleSlide,
                      child: FadeTransition(
                        opacity: titleFade,
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'COUGAR',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 3.0,
                                height: 1.0,
                              ),
                            ),
                            Text(
                              'AVIATION ACADEMY',
                              style: TextStyle(
                                color: AppColors.accent,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // FAA Badge
            SlideTransition(
              position: titleSlide,
              child: FadeTransition(
                opacity: titleFade,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: AppColors.accent.withOpacity(0.3), width: 1),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified_rounded,
                          color: AppColors.accent, size: 12),
                      SizedBox(width: 5),
                      Text(
                        'FAA APPROVED · FLORIDA, USA',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Animated divider
            AnimatedBuilder(
              animation: dividerExpand,
              builder: (context, _) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Container(
                        width: 290 * dividerExpand.value,
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.accent.withOpacity(0.8),
                              AppColors.accent.withOpacity(0.1),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION LABEL
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final AnimationController masterCtrl;
  final double intervalStart;

  const _SectionLabel({
    required this.label,
    required this.masterCtrl,
    required this.intervalStart,
  });

  @override
  Widget build(BuildContext context) {
    final anim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: masterCtrl,
        curve: Interval(intervalStart,
            (intervalStart + 0.15).clamp(0.0, 1.0).toDouble(),
            curve: Curves.easeOut),
      ),
    );

    return FadeTransition(
      opacity: anim,
      child: Padding(
        padding: const EdgeInsets.only(left: 22, bottom: 2),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.25),
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.0,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ANIMATED DRAWER ITEM
// ─────────────────────────────────────────────────────────────────────────────

class _AnimatedDrawerItem extends StatefulWidget {
  final _NavItem item;
  final int index;
  final AnimationController masterCtrl;
  final double baseInterval;
  final bool isActive;
  final VoidCallback onTap;

  const _AnimatedDrawerItem({
    required this.item,
    required this.index,
    required this.masterCtrl,
    required this.baseInterval,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_AnimatedDrawerItem> createState() => _AnimatedDrawerItemState();
}

class _AnimatedDrawerItemState extends State<_AnimatedDrawerItem>
    with SingleTickerProviderStateMixin {
  late Animation<double> _entranceFade;
  late Animation<Offset> _entranceSlide;
  late AnimationController _pressCtrl;
  late Animation<double> _pressScale;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    // Staggered entrance from master controller
    final start =
    (widget.baseInterval + widget.index * 0.055).clamp(0.0, 0.95);
    final end = (start + 0.22).clamp(0.0, 1.0);

    _entranceFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: widget.masterCtrl,
        curve: Interval(start, end, curve: Curves.easeOut),
      ),
    );
    _entranceSlide = Tween<Offset>(
      begin: const Offset(-0.25, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: widget.masterCtrl,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    ));

    // Press animation
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _pressScale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _entranceFade,
      child: SlideTransition(
        position: _entranceSlide,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: GestureDetector(
              onTapDown: (_) => _pressCtrl.forward(),
              onTapUp: (_) {
                _pressCtrl.reverse();
                widget.onTap();
              },
              onTapCancel: () => _pressCtrl.reverse(),
              child: ScaleTransition(
                scale: _pressScale,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 13),
                  decoration: BoxDecoration(
                    color: widget.isActive
                        ? AppColors.accent.withOpacity(0.15)
                        : _isHovered
                        ? Colors.white.withOpacity(0.05)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    border: widget.isActive
                        ? Border.all(
                      color: AppColors.accent.withOpacity(0.35),
                      width: 1,
                    )
                        : Border.all(color: Colors.transparent),
                  ),
                  child: Row(
                    children: [
                      // Icon container
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: widget.isActive
                              ? AppColors.accent.withOpacity(0.2)
                              : Colors.white.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          widget.item.icon,
                          size: 18,
                          color: widget.isActive
                              ? AppColors.accent
                              : Colors.white.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(width: 13),

                      // Label
                      Expanded(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            color: widget.isActive
                                ? Colors.white
                                : Colors.white.withOpacity(0.7),
                            fontSize: 14,
                            fontWeight: widget.isActive
                                ? FontWeight.w700
                                : FontWeight.w500,
                            letterSpacing: 0.2,
                          ),
                          child: Text(widget.item.label),
                        ),
                      ),

                      // Badge
                      if (widget.item.badge != null)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            widget.item.badge!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),

                      // Active indicator
                      if (widget.isActive) ...[
                        const SizedBox(width: 6),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],

                      // Arrow on hover
                      if (!widget.isActive && _isHovered)
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 10,
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ANIMATED DIVIDER
// ─────────────────────────────────────────────────────────────────────────────

class _AnimatedDivider extends StatelessWidget {
  final AnimationController masterCtrl;
  final double intervalStart;

  const _AnimatedDivider({
    required this.masterCtrl,
    required this.intervalStart,
  });

  @override
  Widget build(BuildContext context) {
    final anim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: masterCtrl,
        curve: Interval(intervalStart,
            (intervalStart + 0.12).clamp(0.0, 1.0).toDouble(),
            curve: Curves.easeOut),
      ),
    );

    return AnimatedBuilder(
      animation: anim,
      builder: (context, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.white.withOpacity(0.08 * anim.value),
                      Colors.white.withOpacity(0.08 * anim.value),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FOOTER
// ─────────────────────────────────────────────────────────────────────────────

class _DrawerFooter extends StatefulWidget {
  final AnimationController masterCtrl;
  final VoidCallback onTap;
  const _DrawerFooter({required this.masterCtrl, required this.onTap});

  @override
  State<_DrawerFooter> createState() => _DrawerFooterState();
}

class _DrawerFooterState extends State<_DrawerFooter>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: widget.masterCtrl,
        curve: const Interval(0.85, 1.0, curve: Curves.easeOut),
      ),
    );

    return FadeTransition(
      opacity: fadeAnim,
      child: GestureDetector(
        onTapDown: (_) => _pressCtrl.forward(),
        onTapUp: (_) {
          _pressCtrl.reverse();
          widget.onTap();
        },
        onTapCancel: () => _pressCtrl.reverse(),
        child: ScaleTransition(
          scale: _scaleAnim,
          child: Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.accent.withOpacity(0.14),
                  AppColors.accent.withOpacity(0.06),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.accent.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.flight_takeoff_rounded,
                    color: AppColors.accent,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ready to fly?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Enroll in a course now',
                        style: TextStyle(
                          color: AppColors.accent.withOpacity(0.8),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}