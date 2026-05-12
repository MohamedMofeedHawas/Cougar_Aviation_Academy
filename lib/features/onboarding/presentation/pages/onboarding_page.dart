// ignore_for_file: deprecated_member_use

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/prefs_service.dart';

// ─── Palette ─────────────────────────────────────────────────────────────────
const _kYellow = Color(0xFFFFB300);
const _kYellowD = Color(0xFFE65100);
const _kBg = Color(0xFF020810);
const _kMid = Color(0xFF081A36);
const _kBlue = Color(0xFF0D3260);
const _kCard = Color(0xFF0B1E3A);
const _kBorder = Color(0xFF1A3A5C);

// ─── Responsive helpers ───────────────────────────────────────────────────────
class _R {
  static double fs(BuildContext ctx, double base) {
    final w = MediaQuery.sizeOf(ctx).width;
    if (w < 360) return base * 0.88;
    if (w > 480) return base * 1.08;
    return base;
  }

  static double pad(BuildContext ctx) {
    final w = MediaQuery.sizeOf(ctx).width;
    if (w < 360) return 18;
    if (w > 480) return 32;
    return 24;
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  OnboardingPage
// ═══════════════════════════════════════════════════════════════════════════════
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  final _pageCtrl = PageController();
  int _page = 0;
  double _offset = 0;

  late final AnimationController _entrance;
  late final AnimationController _ambient;
  late final AnimationController _orbit;

  static const int _totalPages = 6;

  @override
  void initState() {
    super.initState();
    _pageCtrl.addListener(() {
      setState(() => _offset = _pageCtrl.page ?? 0);
    });
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    )..forward();
    _ambient = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    )..repeat();
    _orbit = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _entrance.dispose();
    _ambient.dispose();
    _orbit.dispose();
    super.dispose();
  }

  void _changePage(int newPage) {
    _pageCtrl.animateToPage(
      newPage,
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeInOutCubic,
    );
  }

  void _onPageChanged(int i) {
    HapticFeedback.selectionClick();
    setState(() => _page = i);
    _entrance
      ..reset()
      ..forward();
  }

  void _complete() {
    sl<PrefsService>().setFirstLaunch(false);
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final bottom = mq.padding.bottom;
    final top = mq.padding.top;
    final pad = _R.pad(context);

    return Scaffold(
      backgroundColor: _kBg,
      body: AnimatedBuilder(
        animation: Listenable.merge([_entrance, _ambient, _orbit]),
        builder: (_, __) => Stack(
          fit: StackFit.expand,
          children: [
            _BgLayer(
              ambient: _ambient.value,
              orbit: _orbit.value,
              offset: _offset,
            ),

            PageView(
              controller: _pageCtrl,
              onPageChanged: _onPageChanged,
              children: [
                _WelcomePage(entrance: _entrance, offset: _offset),
                _WhyPage(entrance: _entrance, offset: _offset),
                _ServicesPage(entrance: _entrance, offset: _offset),
                _ProgramsPage(entrance: _entrance, offset: _offset),
                _BlogPage(entrance: _entrance, offset: _offset),
                _GetStartedPage(
                  entrance: _entrance,
                  orbit: _orbit,
                  onStart: _complete,
                ),
              ],
            ),

            // Top bar
            Positioned(
              top: top + 6,
              left: pad,
              right: pad,
              child: _TopBar(
                page: _page,
                total: _totalPages,
                onSkip: _complete,
              ),
            ),

            // Bottom controls
            Positioned(
              bottom: bottom + 16,
              left: pad,
              right: pad,
              child: _BottomControls(
                page: _page,
                total: _totalPages,
                offset: _offset,
                onBack: () => _changePage(_page - 1),
                onNext: _page < _totalPages - 1
                    ? () => _changePage(_page + 1)
                    : _complete,
                isLast: _page == _totalPages - 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  Page 1 — Welcome
// ═══════════════════════════════════════════════════════════════════════════════
class _WelcomePage extends StatelessWidget {
  final AnimationController entrance;
  final double offset;
  const _WelcomePage({required this.entrance, required this.offset});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final pad = _R.pad(context);

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: SizedBox(
        height: size.height,
        child: Padding(
          padding: EdgeInsets.fromLTRB(pad, size.height * 0.20, pad, 140),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FadeSlide(
                  controller: entrance,
                  delay: 0.0,
                  end: 0.4,
                  child: const _Eyebrow('COUGAR AVIATION ACADEMY'),
                ),
                SizedBox(height: size.height * 0.022),
            
                _FadeSlide(
                  controller: entrance,
                  delay: 0.1,
                  end: 0.55,
                  child: Text(
                    'Welcome Aboard.',
                    style: TextStyle(
                      fontSize: _R.fs(context, 50),
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                      letterSpacing: -1.5,
                      color: Colors.white,
                      shadows: [
                        Shadow(color: _kYellow.withOpacity(0.2), blurRadius: 30),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.028),
            
                _FadeSlide(
                  controller: entrance,
                  delay: 0.25,
                  end: 0.65,
                  child: Container(
                    width: 44,
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_kYellow, _kYellow.withOpacity(0)],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.022),
            
                _FadeSlide(
                  controller: entrance,
                  delay: 0.3,
                  end: 0.75,
                  child: Text(
                    'At Cougar Aviation Academy, the satisfaction of our CFIs comes first, because when instructors are supported and motivated, our students naturally receive the highest quality of training and care.',
                    style: TextStyle(
                      fontSize: _R.fs(context, 15),
                      fontWeight: FontWeight.w400,
                      height: 1.7,
                      color: Colors.white.withOpacity(0.72),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.032),
            
                _FadeSlide(
                  controller: entrance,
                  delay: 0.45,
                  end: 0.9,
                  child: const Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _Pill('Integrity'),
                      _Pill('Excellence'),
                      _Pill('Passion for Aviation'),
                    ],
                  ),
                ),
            
               // const Spacer(),
               const SizedBox(height: 15),
            
                _FadeSlide(
                  controller: entrance,
                  delay: 0.6,
                  end: 1.0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _kYellow.withOpacity(0.2)),
                      color: _kYellow.withOpacity(0.05),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.format_quote_rounded,
                          color: _kYellow.withOpacity(0.6),
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        const SizedBox(height: 15,),
                        Expanded(
                          child: Text(
                            'With us, you don\’t just earn a license — you build a career, guided by integrity, excellence, and passion for aviation.',
                            style: TextStyle(
                              fontSize: _R.fs(context, 12.5),
                              fontStyle: FontStyle.italic,
                              height: 1.5,
                              color: _kYellow.withOpacity(0.85),
                              fontWeight: FontWeight.w500,
                            ),
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
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  Page 2 — Why Cougar?
// ═══════════════════════════════════════════════════════════════════════════════
class _WhyPage extends StatelessWidget {
  final AnimationController entrance;
  final double offset;
  const _WhyPage({required this.entrance, required this.offset});

  static const _points = [
    (
      Icons.visibility_off_outlined,
      'No Hidden Issues, No Hidden Fees',
      'Everything is clear from the very beginning. What you see is exactly what you get — complete transparency at every step of your journey.',
    ),
    (
      Icons.support_agent_outlined,
      'Full Support at Every Step',
      'From instructors to administration, we stand with you throughout your entire training — always accessible, always ready to help.',
    ),
    (
      Icons.emoji_events_outlined,
      'Your Success Is Our Priority',
      'We are dedicated to seeing you achieve your goals as quickly and effectively as possible. Your wings are our mission.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final pad = _R.pad(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(pad, size.height * 0.19, pad, 140),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FadeSlide(
              controller: entrance,
              delay: 0.0,
              end: 0.4,
              child: const _Eyebrow('OUR COMMITMENT TO YOU'),
            ),
            SizedBox(height: size.height * 0.016),
            _FadeSlide(
              controller: entrance,
              delay: 0.08,
              end: 0.5,
              child: Text(
                'Why Cougar ?',
                style: TextStyle(
                  fontSize: _R.fs(context, 50),
                  fontWeight: FontWeight.w900,
                  height: 1.02,
                  letterSpacing: -1,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.012),
            _FadeSlide(
              controller: entrance,
              delay: 0.18,
              end: 0.6,
              child: Text(
                'At Cougar Aviation Academy, we believe in a journey that starts simple and transparent — and grows into full professionalism.',
                style: TextStyle(
                  fontSize: _R.fs(context, 13),
                  height: 1.65,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.028),
            ..._points.asMap().entries.map((e) {
              final i = e.key;
              final p = e.value;
              return _FadeSlide(
                controller: entrance,
                delay: 0.2 + i * 0.18,
                end: (0.6 + i * 0.12).clamp(0.0, 1.0),
                child: Padding(
                  padding: EdgeInsets.only(bottom: size.height * 0.016),
                  child: _WhyCard(icon: p.$1, title: p.$2, body: p.$3),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _WhyCard extends StatelessWidget {
  final IconData icon;
  final String title, body;
  const _WhyCard({required this.icon, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _kBorder, width: 1),
        color: _kCard,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: _kYellow.withOpacity(0.1),
              border: Border.all(color: _kYellow.withOpacity(0.25)),
            ),
            child: Icon(icon, color: _kYellow, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: _R.fs(context, 13.5),
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  body,
                  style: TextStyle(
                    fontSize: _R.fs(context, 12),
                    height: 1.6,
                    color: Colors.white.withOpacity(0.57),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  Page 3 — Services
// ═══════════════════════════════════════════════════════════════════════════════
class _ServicesPage extends StatelessWidget {
  final AnimationController entrance;
  final double offset;
  const _ServicesPage({required this.entrance, required this.offset});

  static const _services = [
    (
      Icons.airplane_ticket_outlined,
      'Cairo Airport VIP Check-In',
      'Premium fast-track check-in assistance for a smooth and stress-free airport experience.',
    ),
    (
      Icons.directions_car_outlined,
      'Orlando Airport Transportation',
      'Reliable door-to-door airport transfers ensuring safe, timely arrival and departure.',
    ),
    (
      Icons.school_outlined,
      'Expert Instructors',
      'Highly qualified CFIs committed to delivering disciplined, professional flight training.',
    ),
    (
      Icons.flight_outlined,
      'Modern Fleet',
      'A modern, high-standard aircraft fleet maintained for maximum safety and performance.',
    ),
    (
      Icons.computer_outlined,
      'Advanced Simulators',
      'Advanced flight simulators designed to enhance training accuracy and pilot confidence.',
    ),
    (
      Icons.hotel_outlined,
      'Premium Accommodation',
      'Comfortable, premium housing that supports focus, well-being, and productive training.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final pad = _R.pad(context);
    final cols = size.width < 380 ? 1 : 2;

    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(pad, size.height * 0.19, pad, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FadeSlide(
                  controller: entrance,
                  delay: 0.0,
                  end: 0.4,
                  child: const _Eyebrow('FULLY INTEGRATED EXPERIENCE'),
                ),
                SizedBox(height: size.height * 0.014),
                _FadeSlide(
                  controller: entrance,
                  delay: 0.08,
                  end: 0.5,
                  child: Text(
                    'Cougar Services.',
                    style: TextStyle(
                      fontSize: _R.fs(context, 50),
                      fontWeight: FontWeight.w900,
                      height: 1.02,
                      letterSpacing: -1,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.012),
                _FadeSlide(
                  controller: entrance,
                  delay: 0.18,
                  end: 0.6,
                  child: Text(
                    'We offer fully integrated services—including instructors, aircraft, simulators, housing, and transportation—to ensure your training experience is seamless and stress-free.',
                    style: TextStyle(
                      fontSize: _R.fs(context, 13),
                      height: 1.65,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.022),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(pad, 0, pad, 150),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate((context, i) {
              final s = _services[i];
              return _FadeSlide(
                controller: entrance,
                delay: (0.25 + i * 0.08).clamp(0.0, 0.85),
                end: (0.65 + i * 0.06).clamp(0.1, 1.0),
                child: _ServiceCard(icon: s.$1, title: s.$2, body: s.$3),
              );
            }, childCount: _services.length),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: cols == 1 ? 3.8 : 1.25,
            ),
          ),
        ),
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title, body;
  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _kBorder, width: 1),
        color: _kCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              color: _kYellow.withOpacity(0.1),
              border: Border.all(color: _kYellow.withOpacity(0.25)),
            ),
            child: Icon(icon, color: _kYellow, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: _R.fs(context, 12.5),
              fontWeight: FontWeight.w700,
              height: 1.3,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: Text(
              body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: _R.fs(context, 11),
                height: 1.55,
                color: Colors.white.withOpacity(0.52),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  Page 4 — Training Programs
// ═══════════════════════════════════════════════════════════════════════════════
class _ProgramsPage extends StatelessWidget {
  final AnimationController entrance;
  final double offset;
  const _ProgramsPage({required this.entrance, required this.offset});

  static const _programs = [
    (
      'ATP-CTP',
      'ATP Certification Training Program',
      'The mandatory first step toward obtaining the highest level of pilot certification — issued by the FAA.',
      _kYellow,
      Icons.military_tech_outlined,
    ),
    (
      'PPL',
      'Private Pilot License',
      'Your first step into aviation — essential flying skills, safety procedures, and foundational pilot training.',
      Color(0xFF64B5F6),
      Icons.flight_takeoff_outlined,
    ),
    (
      'IR',
      'Instrument Rating',
      'High-fidelity simulator sessions to refine precision, decision-making, and full cockpit management.',
      Color(0xFF81C784),
      Icons.radar_outlined,
    ),
    (
      'CPL',
      'Commercial Pilot License',
      'A comprehensive program developing the skills, discipline, and professionalism for a commercial aviation career.',
      Color(0xFFBA68C8),
      Icons.airplanemode_active_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final pad = _R.pad(context);

    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(pad, size.height * 0.19, pad, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FadeSlide(
                  controller: entrance,
                  delay: 0.0,
                  end: 0.4,
                  child: const _Eyebrow('PRECISION · STRUCTURE · EXCELLENCE'),
                ),
                SizedBox(height: size.height * 0.014),
                _FadeSlide(
                  controller: entrance,
                  delay: 0.08,
                  end: 0.5,
                  child: Text(
                    'Our Programs.',
                    style: TextStyle(
                      fontSize: _R.fs(context, 50),
                      fontWeight: FontWeight.w900,
                      height: 1.02,
                      letterSpacing: -1,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.012),
                _FadeSlide(
                  controller: entrance,
                  delay: 0.18,
                  end: 0.6,
                  child: Text(
                    'Every program designed with real-world standards to help you grow with confidence and become the pilot you aspire to be.',
                    style: TextStyle(
                      fontSize: _R.fs(context, 13),
                      height: 1.65,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.022),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(pad, 0, pad, 150),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, i) {
              final p = _programs[i];
              return _FadeSlide(
                controller: entrance,
                delay: (0.2 + i * 0.14).clamp(0.0, 0.85),
                end: (0.6 + i * 0.1).clamp(0.1, 1.0),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _ProgramCard(
                    badge: p.$1,
                    title: p.$2,
                    body: p.$3,
                    color: p.$4,
                    icon: p.$5,
                  ),
                ),
              );
            }, childCount: _programs.length),
          ),
        ),
      ],
    );
  }
}

class _ProgramCard extends StatelessWidget {
  final String badge, title, body;
  final Color color;
  final IconData icon;
  const _ProgramCard({
    required this.badge,
    required this.title,
    required this.body,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.22), width: 1),
        color: _kCard,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: color.withOpacity(0.1),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: color.withOpacity(0.15),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: _R.fs(context, 13.5),
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: TextStyle(
                    fontSize: _R.fs(context, 12),
                    height: 1.6,
                    color: Colors.white.withOpacity(0.57),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'EXPLORE PROGRAM',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        color: color.withOpacity(0.85),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 12,
                      color: color.withOpacity(0.85),
                    ),
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
class _BlogPage extends StatelessWidget {
  final AnimationController entrance;
  final double offset;
  const _BlogPage({required this.entrance, required this.offset});

  static const _posts = [
    (
      'TSA',
      'TSA Clearance for Flight Training in the USA',
      'A complete guide for international students on obtaining mandatory TSA clearance before beginning any flight training program in the United States.',
      Color(0xFFFFB74D),
      Icons.verified_user_outlined,
      'APR 10, 2026',
    ),
    (
      '61/141',
      'Part 61 vs Part 141: Comprehensive Differences',
      'One of the most important decisions an aspiring pilot will make — a detailed breakdown of both FAA-regulated training frameworks.',
      Color(0xFF4DB6AC),
      Icons.balance_outlined,
      'APR 10, 2026',
    ),
    (
      'GUIDE',
      'How to Become a Pilot in the USA (Step-by-Step)',
      'A structured walkthrough of the most advanced and rewarding aviation career path in the world — from zero to professional pilot.',
      Color(0xFFF48FB1),
      Icons.route_outlined,
      'APR 10, 2026',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final pad = _R.pad(context);

    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(pad, size.height * 0.19, pad, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FadeSlide(
                  controller: entrance,
                  delay: 0.0,
                  end: 0.4,
                  child: const _Eyebrow('Insights, Guidance, and Aviation Knowledge'),
                ),
                SizedBox(height: size.height * 0.014),
                _FadeSlide(
                  controller: entrance,
                  delay: 0.08,
                  end: 0.5,
                  child: Text(
                    'Cougar Blog.',
                    style: TextStyle(
                      fontSize: _R.fs(context, 50),
                      fontWeight: FontWeight.w900,
                      height: 1.02,
                      letterSpacing: -1,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.012),
                _FadeSlide(
                  controller: entrance,
                  delay: 0.18,
                  end: 0.6,
                  child: Text(
                    'Expert tips, industry updates, and valuable lessons that support your training journey and keep you informed as you advance in aviation.',
                    style: TextStyle(
                      fontSize: _R.fs(context, 13),
                      height: 1.65,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.022),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(pad, 0, pad, 150),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, i) {
              final p = _posts[i];
              return _FadeSlide(
                controller: entrance,
                delay: (0.2 + i * 0.14).clamp(0.0, 0.85),
                end: (0.6 + i * 0.1).clamp(0.1, 1.0),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _BlogCard(
                    badge: p.$1,
                    title: p.$2,
                    body: p.$3,
                    color: p.$4,
                    icon: p.$5,
                    date: p.$6,
                  ),
                ),
              );
            }, childCount: _posts.length),
          ),
        ),
      ],
    );
  }
}

class _BlogCard extends StatelessWidget {
  final String badge, title, body, date;
  final Color color;
  final IconData icon;

  const _BlogCard({
    required this.badge,
    required this.title,
    required this.body,
    required this.color,
    required this.icon,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.22), width: 1),
        color: _kCard,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: color.withOpacity(0.1),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: color.withOpacity(0.15),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Date chip ──
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white.withOpacity(0.06),
                  ),
                  child: Text(
                    date,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                      color: Colors.white.withOpacity(0.35),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: _R.fs(context, 13.5),
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: TextStyle(
                    fontSize: _R.fs(context, 12),
                    height: 1.6,
                    color: Colors.white.withOpacity(0.57),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'READ ARTICLE',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        color: color.withOpacity(0.85),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 12,
                      color: color.withOpacity(0.85),
                    ),
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

// ═══════════════════════════════════════════════════════════════════════════════
//  Page 6 — Get Started
// ═══════════════════════════════════════════════════════════════════════════════
class _GetStartedPage extends StatelessWidget {
  final AnimationController entrance;
  final AnimationController orbit;
  final VoidCallback onStart;
  const _GetStartedPage({
    required this.entrance,
    required this.orbit,
    required this.onStart,
  });

  static const _checklist = [
    'Enroll online — takes 3 minutes',
    'Schedule your orientation flight',
    'Begin ground school immediately',
    'Earn your wings in record time',
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final pad = _R.pad(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedBuilder(
          animation: orbit,
          builder: (_, __) =>
              CustomPaint(painter: _RunwayPainter(t: orbit.value)),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(pad, size.height * 0.22, pad, 140),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FadeSlide(
                controller: entrance,
                delay: 0.0,
                end: 0.4,
                child: const _Eyebrow('Train. Fly. Become a pilot. join now. '),
              ),
              SizedBox(height: size.height * 0.02),
              _FadeSlide(
                controller: entrance,
                delay: 0.1,
                end: 0.55,
                child: Text(
                  'Are You Ready ?',
                  style: TextStyle(
                    fontSize: _R.fs(context, 50),
                    fontWeight: FontWeight.w900,
                    height: 0.95,
                    letterSpacing: -1.5,
                    color: Colors.white,
                    shadows: [
                      Shadow(color: _kYellow.withOpacity(0.3), blurRadius: 40),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.025),
              _FadeSlide(
                controller: entrance,
                delay: 0.25,
                end: 0.7,
                child: Text(
                  'Join a legacy built on discipline, precision, and passion for flight. Take the controls of your future today.',
                  style: TextStyle(
                    fontSize: _R.fs(context, 14.5),
                    height: 1.7,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.038),
              ..._checklist.asMap().entries.map((e) {
                return _FadeSlide(
                  controller: entrance,
                  delay: (0.35 + e.key * 0.12).clamp(0.0, 0.9),
                  end: (0.7 + e.key * 0.08).clamp(0.1, 1.0),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: size.height * 0.013),
                    child: Row(
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: _kYellow, width: 1.5),
                            color: _kYellow.withOpacity(0.12),
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 12,
                            color: _kYellow,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            e.value,
                            style: TextStyle(
                              fontSize: _R.fs(context, 13),
                              color: Colors.white.withOpacity(0.75),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}


class _TopBar extends StatelessWidget {
  final int page, total;
  final VoidCallback onSkip;
  const _TopBar({
    required this.page,
    required this.total,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final isLast = page == total - 1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _kYellow.withOpacity(0.55), width: 1),
                color: _kMid,
              ),
              child: const Icon(
                Icons.airplanemode_active,
                size: 16,
                color: _kYellow,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'COUGAR',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 3,
                color: _kYellow,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              '${page + 1} / $total',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 1,
                color: Colors.white.withOpacity(0.3),
                fontWeight: FontWeight.w500,
              ),
            ),
            if (!isLast) ...[
              const SizedBox(width: 14),
              GestureDetector(
                onTap: onSkip,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white.withOpacity(0.12)),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white.withOpacity(0.04),
                  ),
                  child: const Text(
                    'SKIP',
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600,
                      color: _kYellow,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  Bottom Controls
// ═══════════════════════════════════════════════════════════════════════════════
class _BottomControls extends StatelessWidget {
  final int page, total;
  final double offset;
  final VoidCallback onBack, onNext;
  final bool isLast;

  const _BottomControls({
    required this.page,
    required this.total,
    required this.offset,
    required this.onBack,
    required this.onNext,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(total, (i) {
            final active = i == page;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 24 : 7,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: active ? _kYellow : Colors.white.withOpacity(0.15),
                boxShadow: active
                    ? [
                        BoxShadow(
                          color: _kYellow.withOpacity(0.5),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
            );
          }),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            AnimatedOpacity(
              opacity: page > 0 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 250),
              child: GestureDetector(
                onTap: page > 0 ? onBack : null,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.12)),
                    color: Colors.white.withOpacity(0.04),
                  ),
                  child: const Icon(
                    Icons.chevron_left_rounded,
                    color: Colors.white70,
                    size: 26,
                  ),
                ),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                onNext();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 26),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    colors: isLast
                        ? [_kYellow, _kYellowD]
                        : [_kBlue, const Color(0xFF1565C0)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (isLast ? _kYellow : _kBlue).withOpacity(0.4),
                      blurRadius: 18,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isLast ? 'GET STARTED' : 'CONTINUE',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.8,
                        color: isLast ? _kBg : Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      isLast
                          ? Icons.flight_takeoff_rounded
                          : Icons.arrow_forward_rounded,
                      size: 18,
                      color: isLast ? _kBg : Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  Background
// ═══════════════════════════════════════════════════════════════════════════════
class _BgLayer extends StatelessWidget {
  final double ambient, orbit, offset;
  const _BgLayer({
    required this.ambient,
    required this.orbit,
    required this.offset,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1, -1),
              end: Alignment(1.2, 1.1),
              colors: [_kBg, _kMid, _kBlue, _kMid, _kBg],
              stops: [0.0, 0.25, 0.5, 0.75, 1.0],
            ),
          ),
        ),
        const _StarField(),
        CustomPaint(
          size: size,
          painter: _AuroraPainter(t: ambient),
        ),
        CustomPaint(
          size: size,
          painter: _OrbitPainter(angle: orbit * math.pi * 2),
        ),
        CustomPaint(
          size: size,
          painter: _GridPainter(offset: offset),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  Reusable Widgets
// ═══════════════════════════════════════════════════════════════════════════════
class _Eyebrow extends StatelessWidget {
  final String text;
  const _Eyebrow(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 18, height: 1.5, color: _kYellow),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: _R.fs(context, 9.5),
              fontWeight: FontWeight.w700,
              letterSpacing: 2.5,
              color: _kYellow.withOpacity(0.85),
            ),
          ),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  const _Pill(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _kYellow.withOpacity(0.28)),
        color: _kYellow.withOpacity(0.07),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: _R.fs(context, 11),
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
          color: _kYellow.withOpacity(0.9),
        ),
      ),
    );
  }
}

class _FadeSlide extends StatelessWidget {
  final AnimationController controller;
  final double delay, end;
  final Widget child;

  const _FadeSlide({
    required this.controller,
    required this.delay,
    required this.end,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final d = delay.clamp(0.0, 0.94);
    final e = end.clamp(d + 0.05, 1.0);
    final curve = CurvedAnimation(
      parent: controller,
      curve: Interval(d, e, curve: Curves.easeOut),
    );
    return FadeTransition(
      opacity: curve,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.22), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: controller,
                curve: Interval(d, e, curve: Curves.easeOutCubic),
              ),
            ),
        child: child,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  Painters
// ═══════════════════════════════════════════════════════════════════════════════
class _StarField extends StatelessWidget {
  const _StarField();
  @override
  Widget build(BuildContext context) => CustomPaint(painter: _StarPainter());
}

class _StarPainter extends CustomPainter {
  static final _stars = List.generate(80, (i) {
    final r = math.Random(i * 31 + 7);
    return (
      x: r.nextDouble(),
      y: r.nextDouble(),
      rad: r.nextDouble() * 1.2 + 0.3,
      op: r.nextDouble() * 0.5 + 0.15,
    );
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final s in _stars) {
      canvas.drawCircle(
        Offset(s.x * size.width, s.y * size.height),
        s.rad,
        Paint()..color = Colors.white.withOpacity(s.op),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

class _AuroraPainter extends CustomPainter {
  final double t;
  const _AuroraPainter({required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final s = t * 2 * math.pi;
    _blob(
      canvas,
      size,
      cx: 0.5 + math.cos(s) * 0.3,
      cy: 0.38 + math.sin(s * 0.7) * 0.18,
      r: 0.72,
      color: _kYellow.withOpacity(0.048),
    );
    _blob(
      canvas,
      size,
      cx: 0.3 + math.sin(s * 0.8) * 0.25,
      cy: 0.65 + math.cos(s * 0.5) * 0.2,
      r: 0.55,
      color: const Color(0xFF1E5799).withOpacity(0.12),
    );
  }

  void _blob(
    Canvas canvas,
    Size size, {
    required double cx,
    required double cy,
    required double r,
    required Color color,
  }) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = RadialGradient(
          center: Alignment(cx * 2 - 1, cy * 2 - 1),
          radius: r,
          colors: [color, Colors.transparent],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );
  }

  @override
  bool shouldRepaint(covariant _AuroraPainter old) => old.t != t;
}

class _OrbitPainter extends CustomPainter {
  final double angle;
  const _OrbitPainter({required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.35;
    const or = 140.0;
    canvas.drawCircle(
      Offset(cx, cy),
      or,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.white.withOpacity(0.025)
        ..strokeWidth = 1,
    );
    canvas.drawCircle(
      Offset(cx + math.cos(angle) * or, cy + math.sin(angle) * or),
      2.5,
      Paint()..color = _kYellow.withOpacity(0.6),
    );
    canvas.drawCircle(
      Offset(
        cx + math.cos(angle + math.pi) * or,
        cy + math.sin(angle + math.pi) * or,
      ),
      1.5,
      Paint()..color = Colors.white.withOpacity(0.25),
    );
  }

  @override
  bool shouldRepaint(covariant _OrbitPainter old) => old.angle != angle;
}

class _GridPainter extends CustomPainter {
  final double offset;
  const _GridPainter({required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _kYellow.withOpacity(0.02)
      ..strokeWidth = 0.6;
    const cols = 5, rows = 9;
    final shift = (offset * 42) % (size.width / cols);
    for (int c = 0; c <= cols + 1; c++) {
      canvas.drawLine(
        Offset(c * size.width / cols - shift, 0),
        Offset(c * size.width / cols - shift, size.height),
        paint,
      );
    }
    for (int r = 0; r <= rows; r++) {
      canvas.drawLine(
        Offset(0, r * size.height / rows),
        Offset(size.width, r * size.height / rows),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter old) => old.offset != offset;
}

class _RunwayPainter extends CustomPainter {
  final double t;
  const _RunwayPainter({required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * 0.72;
    final cy = size.height * 0.26;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (int i = 0; i < 6; i++) {
      final spread = 16.0 * i;
      stroke.color = _kYellow.withOpacity(0.055 - i * 0.007);
      canvas.drawLine(
        Offset(cx, cy),
        Offset(cx - spread * 3, cy + 150),
        stroke,
      );
      canvas.drawLine(
        Offset(cx, cy),
        Offset(cx + spread * 3, cy + 150),
        stroke,
      );
    }
    stroke
      ..color = _kYellow.withOpacity(0.18 + 0.08 * math.sin(t * math.pi * 2))
      ..strokeWidth = 1.5;
    for (int i = 0; i < 6; i++) {
      final y0 = cy + 26.0 + i * 22;
      canvas.drawLine(Offset(cx, y0), Offset(cx, y0 + 12), stroke);
    }
  }

  @override
  bool shouldRepaint(covariant _RunwayPainter old) => old.t != t;
}
