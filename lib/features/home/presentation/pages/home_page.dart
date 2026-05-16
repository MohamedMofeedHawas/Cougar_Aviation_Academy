// ignore_for_file: deprecated_member_use

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../accommodations_page.dart';
import '../../../../app_drawer.dart';

// ─── COLORS ────────────────────────────────────────────────────────────────────
const Color kNavy     = Color(0xFF081F2F);
const Color kNavyDark = Color(0xFF051420);
const Color kNavyMid  = Color(0xFF0A2234);
const Color kGold     = Color(0xFFB68826);
const Color kWhite    = Colors.white;
const Color kWhite70  = Color(0xB3FFFFFF);
const Color kWhite30  = Color(0x4DFFFFFF);

// Splash palette (reused for hero bg)
const Color _kBg  = Color(0xFF020810);
const Color _kMid = Color(0xFF081A36);
const Color _kBlu = Color(0xFF0D3260);

// ─── PHONE ─────────────────────────────────────────────────────────────────────
const String kPhone = '+20 1001290196';

// ═══════════════════════════════════════════════════════════════════════════════
// HOME PAGE  — drawer on the LEFT
// ═══════════════════════════════════════════════════════════════════════════════
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kNavy,
      // ← left drawer
      drawer: AppDrawer(),
      body: _HomeBody(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// APP DRAWER  (left side)
// ═══════════════════════════════════════════════════════════════════════════════

// ═══════════════════════════════════════════════════════════════════════════════
// HOME BODY
// ═══════════════════════════════════════════════════════════════════════════════
class _HomeBody extends StatefulWidget {
  const _HomeBody();
  @override
  State<_HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<_HomeBody> {
  final ScrollController _scroll = ScrollController();
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() => setState(() => _scrollOffset = _scroll.offset));
  }

  @override
  void dispose() { _scroll.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scroll,
      slivers: [
        // ── Animated hero header (replaces old SliverToBoxAdapter hero) ──
        _SliverHeroHeader(scrollOffset: _scrollOffset),

        const SliverToBoxAdapter(child: _StatsSection()),
        const SliverToBoxAdapter(child: _WhyCougarSection()),
        SliverToBoxAdapter(child: _ProgramsSection()),
        SliverToBoxAdapter(child: _AccommodationSection()),
        const SliverToBoxAdapter(child: _ServicesSection()),
        SliverToBoxAdapter(child: _TestimonialsSection()),
        const SliverToBoxAdapter(child: _CtaSection()),
        const SliverToBoxAdapter(child: _Footer()),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SLIVER HERO HEADER  — splash-style animated background, smaller height
// ═══════════════════════════════════════════════════════════════════════════════
class _SliverHeroHeader extends StatefulWidget {
  final double scrollOffset;
  const _SliverHeroHeader({required this.scrollOffset});

  @override
  State<_SliverHeroHeader> createState() => _SliverHeroHeaderState();
}

class _SliverHeroHeaderState extends State<_SliverHeroHeader>
    with TickerProviderStateMixin {
  // text entrance
  late AnimationController _textCtrl;
  late Animation<double>   _fadeIn;
  late Animation<Offset>   _slideUp;

  // ambient (splash-style)
  late AnimationController _aurora;
  late AnimationController _orbit;
  late AnimationController _pulse;

  late Animation<double> _auroraShift;
  late Animation<double> _orbitAngle;
  late Animation<double> _pulseScale;

  @override
  void initState() {
    super.initState();

    // text
    _textCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fadeIn   = CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut);
    _slideUp  = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero)
        .animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut));
    Future.delayed(const Duration(milliseconds: 400), () { if (mounted) _textCtrl.forward(); });

    // aurora
    _aurora      = AnimationController(vsync: this, duration: const Duration(seconds: 7))..repeat();
    _auroraShift = Tween<double>(begin: 0, end: 1).animate(_aurora);

    // orbit
    _orbit      = AnimationController(vsync: this, duration: const Duration(seconds: 12))..repeat();
    _orbitAngle = Tween<double>(begin: 0, end: 2 * math.pi).animate(_orbit);

    // pulse
    _pulse      = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat(reverse: true);
    _pulseScale = Tween<double>(begin: 0.94, end: 1.06)
        .animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    _aurora.dispose();
    _orbit.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Smaller header: 55 % of screen height
    final double headerH = MediaQuery.of(context).size.height * 0.55;

    return SliverToBoxAdapter(
      child: SizedBox(
        height: headerH,
        child: AnimatedBuilder(
          animation: Listenable.merge([_aurora, _orbit, _pulse, _textCtrl]),
          builder: (context, _) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                // ── Mesh gradient background ───────────────────────────
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(-1, -1),
                        end:   Alignment(1.2, 1.1),
                        colors: [_kBg, _kMid, _kBlu, _kMid, _kBg],
                        stops:  [0.0, 0.25, 0.5, 0.75, 1.0],
                      ),
                    ),
                  ),
                ),

                // ── Stars ─────────────────────────────────────────────
                Positioned.fill(child: CustomPaint(painter: _HeroStarPainter())),

                // ── Aurora blobs ──────────────────────────────────────
                Positioned.fill(
                  child: CustomPaint(
                    painter: _HeroAuroraPainter(t: _auroraShift.value),
                  ),
                ),

                // ── Orbit ring + dots ─────────────────────────────────
                Positioned.fill(
                  child: CustomPaint(
                    painter: _HeroOrbitPainter(
                      angle: _orbitAngle.value,
                      headerH: headerH,
                    ),
                  ),
                ),

                // ── Pulse ring (decorative) ───────────────────────────
                Align(
                  alignment: const Alignment(0.6, -0.1),
                  child: ScaleTransition(
                    scale: _pulseScale,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: kGold.withOpacity(0.10), width: 1),
                      ),
                    ),
                  ),
                ),

                // ── Gold accent bar (right edge) ──────────────────────
                Positioned(
                  right: -40,
                  top: headerH * 0.08,
                  child: Transform.rotate(
                    angle: -0.15,
                    child: Container(
                      width: 4,
                      height: headerH * 0.75,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end:   Alignment.bottomCenter,
                          colors: [
                            kGold.withOpacity(0),
                            kGold.withOpacity(0.4),
                            kGold.withOpacity(0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Text content ──────────────────────────────────────
                Positioned(
                  left: 0, right: 0,
                  bottom: headerH * 0.20,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: FadeTransition(
                      opacity: _fadeIn,
                      child: SlideTransition(
                        position: _slideUp,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(width: 26, height: 2, color: kGold),
                                const SizedBox(width: 10),
                                const Text(
                                  'FLORIDA — USA',
                                  style: TextStyle(color: kGold, fontSize: 13, letterSpacing: 4, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            RichText(
                              textAlign: TextAlign.center,
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 30,
                                  height: 1.0,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2,
                                  color: kWhite,
                                ),
                                children: [
                                  TextSpan(text: 'COUGAR AVIATION\n'),
                                  TextSpan(
                                    text: 'ACADEMY',
                                    style: TextStyle(color: kGold),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Building disciplined, confident pilots\nthrough proven, high-standard training.',
                              style: TextStyle(color: kWhite70, fontSize: 13, height: 1.65),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Scroll indicator ──────────────────────────────────


                // ── Nav bar (hamburger opens LEFT drawer) ─────────────
                _HeroNav(),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ─── Hero star painter (static) ──────────────────────────────────────────────
class _HeroStarPainter extends CustomPainter {
  static final _stars = List.generate(70, (i) {
    final r = math.Random(i * 31 + 13);
    return (x: r.nextDouble(), y: r.nextDouble(), rad: r.nextDouble() * 1.1 + 0.3, op: r.nextDouble() * 0.55 + 0.2);
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
  bool shouldRepaint(_) => false;
}

// ─── Hero aurora painter ──────────────────────────────────────────────────────
class _HeroAuroraPainter extends CustomPainter {
  final double t;
  const _HeroAuroraPainter({required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final s = t * 2 * math.pi;
    _blob(canvas, size,
        cx: 0.55 + math.cos(s) * 0.30,
        cy: 0.45 + math.sin(s * 0.65) * 0.20,
        r: 0.65,
        color: kGold.withOpacity(0.06));
    _blob(canvas, size,
        cx: 0.28 + math.sin(s * 0.8) * 0.28,
        cy: 0.60 + math.cos(s * 0.5) * 0.22,
        r: 0.50,
        color: const Color(0xFF1E5799).withOpacity(0.13));
  }

  void _blob(Canvas canvas, Size size,
      {required double cx, required double cy, required double r, required Color color}) {
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
  bool shouldRepaint(covariant _HeroAuroraPainter old) => old.t != t;
}

// ─── Hero orbit painter ───────────────────────────────────────────────────────
class _HeroOrbitPainter extends CustomPainter {
  final double angle;
  final double headerH;
  const _HeroOrbitPainter({required this.angle, required this.headerH});

  @override
  void paint(Canvas canvas, Size size) {
    final cx  = size.width * 0.72;
    final cy  = headerH   * 0.38;
    const or  = 72.0;

    // orbit ring
    canvas.drawCircle(Offset(cx, cy), or,
        Paint()
          ..style       = PaintingStyle.stroke
          ..color       = Colors.white.withOpacity(0.05)
          ..strokeWidth = 1);

    // moving dot 1
    canvas.drawCircle(
        Offset(cx + math.cos(angle) * or, cy + math.sin(angle) * or),
        2.5,
        Paint()..color = kGold.withOpacity(0.75));

    // moving dot 2 (opposite)
    canvas.drawCircle(
        Offset(cx + math.cos(angle + math.pi) * or, cy + math.sin(angle + math.pi) * or),
        1.4,
        Paint()..color = Colors.white.withOpacity(0.35));

    // second larger ring
    const or2 = 105.0;
    canvas.drawCircle(Offset(cx, cy), or2,
        Paint()
          ..style       = PaintingStyle.stroke
          ..color       = kGold.withOpacity(0.04)
          ..strokeWidth = 1);

    canvas.drawCircle(
        Offset(cx + math.cos(-angle * 0.7) * or2, cy + math.sin(-angle * 0.7) * or2),
        1.8,
        Paint()..color = kGold.withOpacity(0.45));
  }

  @override
  bool shouldRepaint(covariant _HeroOrbitPainter old) => old.angle != angle;
}

// ─── Scroll indicator (unchanged) ────────────────────────────────────────────
class _ScrollIndicator extends StatefulWidget {
  @override
  State<_ScrollIndicator> createState() => _ScrollIndicatorState();
}

class _ScrollIndicatorState extends State<_ScrollIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
  }

  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) => Container(
        width: 22, height: 36,
        decoration: BoxDecoration(
          border: Border.all(color: kGold, width: 1.4),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Align(
          alignment: Alignment(0, -0.5 + _c.value),
          child: Container(
            width: 3.5, height: 7,
            decoration: BoxDecoration(color: kGold, borderRadius: BorderRadius.circular(2)),
          ),
        ),
      ),
    );
  }
}

// ─── Nav bar — opens LEFT drawer ──────────────────────────────────────────────
class _HeroNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0, left: 0, right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo
              Row(
                children: [
                  Container(
                    width: 50, height: 50,

                    child:  Image.asset('assets/images/cougar_img.png'),
                  ),
                  const SizedBox(width: 9),
                  const Text('COUGAR', style: TextStyle(color: kWhite, fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: 3)),
                ],
              ),

              // Hamburger → opens LEFT drawer
              GestureDetector(
                onTap: () => Scaffold.of(context).openDrawer(),  // ← openDrawer (left)
                child: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    border: Border.all(color: kWhite30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.menu, color: kWhite, size: 21),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// STATS BAR
// ═══════════════════════════════════════════════════════════════════════════════
class _StatsSection extends StatelessWidget {
  const _StatsSection();

  static const _data = [
    {'value': '500+',  'label': 'Students',    'icon': Icons.people_alt_outlined},
    {'value': '25K+',  'label': 'Flight Hours', 'icon': Icons.access_time_outlined},
    {'value': '15+',   'label': 'Certificates', 'icon': Icons.verified_outlined},
    {'value': '10+',   'label': 'Years Exp.',   'icon': Icons.workspace_premium_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kGold,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
      child: Row(
        children: _data.map((s) => Expanded(
          child: _StatItem(
            value: s['value'] as String,
            label: s['label'] as String,
            icon:  s['icon']  as IconData,
          ),
        )).toList(),
      ),
    );
  }
}

class _StatItem extends StatefulWidget {
  final String value, label;
  final IconData icon;
  const _StatItem({required this.value, required this.label, required this.icon});
  @override
  State<_StatItem> createState() => _StatItemState();
}

class _StatItemState extends State<_StatItem> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _s;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _s = CurvedAnimation(parent: _c, curve: Curves.elasticOut);
    Future.delayed(const Duration(milliseconds: 500), () { if (mounted) _c.forward(); });
  }

  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _s,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(widget.icon, color: kNavy, size: 18),
          const SizedBox(height: 3),
          FittedBox(fit: BoxFit.scaleDown,
              child: Text(widget.value, style: const TextStyle(color: kNavy, fontSize: 19, fontWeight: FontWeight.w900, letterSpacing: 0.5))),
          FittedBox(fit: BoxFit.scaleDown,
              child: Text(widget.label, style: TextStyle(color: kNavy.withOpacity(0.65), fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 0.5))),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// WHY COUGAR
// ═══════════════════════════════════════════════════════════════════════════════
class _WhyCougarSection extends StatelessWidget {
  const _WhyCougarSection();

  static const _points = [
    {'title': 'No Hidden Fees',    'sub': 'Everything is clear and transparent from day one.'},
    {'title': 'Full Support',      'sub': 'From instructors to admin, we stand with you.'},
    {'title': 'Your Success First','sub': 'We are dedicated to seeing you achieve your goals.'},
    {'title': 'Industry Experts',  'sub': 'CFIs with real-world airline experience guide you.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kNavyMid,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 52),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel('Welcome To Cougar Aviation Academy'),
          const SizedBox(height: 10),
          const Text('Why Cougar\nAviation Academy?',
              style: TextStyle(color: kWhite, fontSize: 30, fontWeight: FontWeight.w800, height: 1.2)),
          const SizedBox(height: 14),
          const Text(
            'We believe in a journey that starts simple and transparent — and grows into full professionalism.',
            style: TextStyle(color: kWhite70, fontSize: 14, height: 1.65),
          ),
          const SizedBox(height: 32),
          ..._points.asMap().entries.map((e) => _AnimatedCheckItem(
            title:    e.value['title']!,
            subtitle: e.value['sub']!,
            delay:    e.key * 110,
          )),
          const SizedBox(height: 24),
          const Text(
            "With us, you don't just earn a license —\nyou build a career.",
            style: TextStyle(color: kGold, fontSize: 14, fontStyle: FontStyle.italic, height: 1.6),
          ),
        ],
      ),
    );
  }
}

class _AnimatedCheckItem extends StatefulWidget {
  final String title, subtitle;
  final int delay;
  const _AnimatedCheckItem({required this.title, required this.subtitle, required this.delay});
  @override
  State<_AnimatedCheckItem> createState() => _AnimatedCheckItemState();
}

class _AnimatedCheckItemState extends State<_AnimatedCheckItem> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<Offset>   _slide;
  late Animation<double>   _fade;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 550));
    _slide = Tween<Offset>(begin: const Offset(-0.25, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));
    _fade  = CurvedAnimation(parent: _c, curve: Curves.easeOut);
    Future.delayed(Duration(milliseconds: 550 + widget.delay), () { if (mounted) _c.forward(); });
  }

  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 30, height: 30,
                decoration: BoxDecoration(
                  color:  kGold.withOpacity(0.13),
                  shape:  BoxShape.circle,
                  border: Border.all(color: kGold.withOpacity(0.35)),
                ),
                child: const Icon(Icons.check, color: kGold, size: 15),
              ),
              const SizedBox(width: 14),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title,    style: const TextStyle(color: kWhite,   fontSize: 14, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(widget.subtitle, style: const TextStyle(color: kWhite70, fontSize: 12, height: 1.5)),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// PROGRAMS CAROUSEL
// ═══════════════════════════════════════════════════════════════════════════════
class _ProgramsSection extends StatefulWidget {
  @override
  State<_ProgramsSection> createState() => _ProgramsSectionState();
}

class _ProgramsSectionState extends State<_ProgramsSection> {
  final _pageCtrl = PageController(viewportFraction: 0.86);
  int _current = 0;

  static final _programs = <Map<String, dynamic>>[
    {'code': 'PPL',     'title': 'Private Pilot License',    'desc': 'Your first step into aviation. Essential flying skills, safety, and foundational training.',                      'duration': '6 Months',  'hours': '40+ Hrs',  'icon': Icons.flight_takeoff, 'color': const Color(0xFF1A4A6B)},
    {'code': 'IR',      'title': 'Instrument Rating',        'desc': 'Fly in low visibility. High-fidelity simulator sessions for precision and cockpit mastery.',                       'duration': '3 Months',  'hours': '50+ Hrs',  'icon': Icons.radar,          'color': const Color(0xFF1B3A52)},
    {'code': 'CPL',     'title': 'Commercial Pilot License', 'desc': 'Build the skills, discipline, and professionalism for a commercial aviation career.',                             'duration': '12 Months', 'hours': '250+ Hrs', 'icon': Icons.airlines,       'color': const Color(0xFF0D2E44)},
    {'code': 'ATP-CTP', 'title': 'ATP Certification',        'desc': 'The highest FAA pilot certification. Mandatory first step toward airline transport pilot.',                       'duration': '30 Days',   'hours': '30 Hrs',   'icon': Icons.stars,          'color': const Color(0xFF16334A)},
  ];

  @override
  void dispose() { _pageCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kNavy,
      padding: const EdgeInsets.only(top: 52, bottom: 44),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionLabel('Professional Pathways'),
                SizedBox(height: 10),
                Text('Our Training Programs',
                    style: TextStyle(color: kWhite, fontSize: 30, fontWeight: FontWeight.w800, height: 1.2)),
              ],
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: 295,
            child: PageView.builder(
              controller:    _pageCtrl,
              itemCount:     _programs.length,
              onPageChanged: (i) => setState(() => _current = i),
              itemBuilder:   (_, i) {
                final active = i == _current;
                return AnimatedScale(
                  scale:    active ? 1.0 : 0.93,
                  duration: const Duration(milliseconds: 280),
                  child:    AnimatedOpacity(
                    opacity:  active ? 1.0 : 0.5,
                    duration: const Duration(milliseconds: 280),
                    child:    _ProgramCard(program: _programs[i], isActive: active),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_programs.length, (i) {
              final a = i == _current;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: a ? 26 : 7, height: 7,
                decoration: BoxDecoration(
                  color:        a ? kGold : kWhite30,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _ProgramCard extends StatelessWidget {
  final Map<String, dynamic> program;
  final bool isActive;
  const _ProgramCard({required this.program, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
        color:         program['color'] as Color,
        borderRadius:  BorderRadius.circular(22),
        border:        Border.all(color: isActive ? kGold.withOpacity(0.45) : Colors.transparent, width: 1.4),
        boxShadow:     isActive ? [BoxShadow(color: kGold.withOpacity(0.12), blurRadius: 26, spreadRadius: 1)] : [],
      ),
      child: Stack(
        children: [
          Positioned(right: -18, bottom: -18,
              child: Opacity(opacity: 0.07,
                  child: Icon(program['icon'] as IconData, color: kWhite, size: 145))),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(color: kGold, borderRadius: BorderRadius.circular(20)),
                  child: Text(program['code'] as String,
                      style: const TextStyle(color: kNavy, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1)),
                ),
                const SizedBox(height: 14),
                Text(program['title'] as String,
                    style: const TextStyle(color: kWhite, fontSize: 20, fontWeight: FontWeight.w800, height: 1.2)),
                const SizedBox(height: 8),
                Text(program['desc'] as String,
                    style: const TextStyle(color: kWhite70, fontSize: 12, height: 1.6),
                    maxLines: 3, overflow: TextOverflow.ellipsis),
                const Spacer(),
                Row(
                  children: [
                    _MetaChip(icon: Icons.schedule, label: program['duration'] as String),
                    const SizedBox(width: 10),
                    _MetaChip(icon: Icons.flight,   label: program['hours']    as String),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color:  kGold.withOpacity(0.15),
                        shape:  BoxShape.circle,
                        border: Border.all(color: kGold.withOpacity(0.35)),
                      ),
                      child: const Icon(Icons.arrow_forward, color: kGold, size: 15),
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

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String   label;
  const _MetaChip({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, color: kGold, size: 13),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(color: kGold, fontSize: 11, fontWeight: FontWeight.w600)),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// ACCOMMODATION
// ═══════════════════════════════════════════════════════════════════════════════
class _AccommodationSection extends StatefulWidget {
  @override
  State<_AccommodationSection> createState() => _AccommodationSectionState();
}

class _AccommodationSectionState extends State<_AccommodationSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    Future.delayed(const Duration(seconds: 1), () { if (mounted) _c.forward(); });
  }

  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _c, curve: Curves.easeOut),
      child: Container(
        margin: const EdgeInsets.all(18),
        height: 210,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Color(0xFF0D3555), Color(0xFF081F2F)],
          ),
          border:    Border.all(color: kGold.withOpacity(0.35), width: 1.4),
          boxShadow: [BoxShadow(color: kGold.withOpacity(0.08), blurRadius: 22, spreadRadius: 1)],
        ),
        child: Stack(
          children: [
            const Positioned(right: 16, top: 16,
                child: Opacity(opacity: 0.06,
                    child: Icon(Icons.hotel, color: kWhite, size: 110))),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color:  kGold.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: kGold.withOpacity(0.3)),
                    ),
                    child: const Text('ACCOMMODATIONS',
                        style: TextStyle(color: kGold, fontSize: 9, letterSpacing: 2, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 12),
                  const Text('Ten60 Halifax',
                      style: TextStyle(color: kWhite, fontSize: 24, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  const Text('Comfort, Safety & Convenience\nYour Home During Training',
                      style: TextStyle(color: kWhite70, fontSize: 12, height: 1.5)),
                  const Spacer(),
                  _GoldButton(label: 'Explore Ten60 →', onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AccommodationsPage(),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SERVICES
// ═══════════════════════════════════════════════════════════════════════════════
class _ServicesSection extends StatelessWidget {
  const _ServicesSection();

  static const _services = <Map<String, dynamic>>[
    {'icon': Icons.flight_takeoff,       'title': 'Expert Instructors', 'desc': 'Highly qualified CFIs with airline experience.'},
    {'icon': Icons.airplanemode_active,  'title': 'Modern Fleet',       'desc': 'High-standard aircraft for maximum safety.'},
    {'icon': Icons.computer,             'title': 'Simulators',         'desc': 'Advanced simulators for precision training.'},
    {'icon': Icons.hotel,                'title': 'Accommodation',      'desc': 'Premium housing during your training.'},
    {'icon': Icons.directions_car,       'title': 'Transportation',     'desc': 'Reliable airport transfers, in & out.'},
    {'icon': Icons.star_border,          'title': 'VIP Check-In',       'desc': 'Premium Cairo airport fast-track service.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kNavyMid,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 52),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel('Everything Delivered With Excellence'),
          const SizedBox(height: 10),
          const Text('Cougar Services',
              style: TextStyle(color: kWhite, fontSize: 30, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          const Text(
            'Fully integrated services — instructors, aircraft, simulators, housing, and transportation.',
            style: TextStyle(color: kWhite70, fontSize: 13, height: 1.6),
          ),
          const SizedBox(height: 28),
          GridView.builder(
            shrinkWrap: true,
            physics:    const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 14, crossAxisSpacing: 14, childAspectRatio: 1.1,
            ),
            itemCount:   _services.length,
            itemBuilder: (_, i) => _ServiceCard(
              icon:  _services[i]['icon']  as IconData,
              title: _services[i]['title'] as String,
              desc:  _services[i]['desc']  as String,
              delay: i * 70,
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatefulWidget {
  final IconData icon;
  final String title, desc;
  final int delay;
  const _ServiceCard({required this.icon, required this.title, required this.desc, required this.delay});
  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  bool _pressed = false;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    Future.delayed(Duration(milliseconds: 700 + widget.delay), () { if (mounted) _c.forward(); });
  }

  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _c, curve: Curves.easeOut),
      child: GestureDetector(
        onTapDown:  (_) => setState(() => _pressed = true),
        onTapUp:    (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color:  _pressed ? kGold.withOpacity(0.09) : kNavy.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _pressed ? kGold.withOpacity(0.45) : kWhite30, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: kGold.withOpacity(0.11), borderRadius: BorderRadius.circular(10)),
                child: Icon(widget.icon, color: kGold, size: 20),
              ),
              const SizedBox(height: 12),
              Text(widget.title, style: const TextStyle(color: kWhite, fontSize: 12, fontWeight: FontWeight.w700)),
              const SizedBox(height: 5),
              Text(widget.desc,  style: const TextStyle(color: kWhite70, fontSize: 10, height: 1.45),
                  maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// TESTIMONIALS
// ═══════════════════════════════════════════════════════════════════════════════
class _TestimonialsSection extends StatefulWidget {
  @override
  State<_TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<_TestimonialsSection> {
  final _ctrl = PageController();
  int _current = 0;

  static const _list = <Map<String, String>>[
    {'quote': 'The best training I could have asked for. Instructors are top-notch and equipment is modern. Cougar changed my life.',    'name': 'Ahmed K.',   'role': 'CPL Graduate', 'initials': 'AK'},
    {'quote': 'Transparent pricing, world-class facilities, and unparalleled support. I passed my checkride on the first attempt!',      'name': 'Omar S.',    'role': 'PPL Student',  'initials': 'OS'},
    {'quote': "Cougar's simulators are incredible. I felt confident in actual IFR conditions thanks to the rigorous training.",           'name': 'Youssef M.', 'role': 'IR Graduate',  'initials': 'YM'},
  ];

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kNavy,
      padding: const EdgeInsets.symmetric(vertical: 52, horizontal: 22),
      child: Column(
        children: [
          const _SectionLabel('Student Voices'),
          const SizedBox(height: 10),
          const Text('What Our Pilots Say',
              style: TextStyle(color: kWhite, fontSize: 26, fontWeight: FontWeight.w800)),
          const SizedBox(height: 30),
          SizedBox(
            height: 210,
            child: PageView.builder(
              controller:    _ctrl,
              itemCount:     _list.length,
              onPageChanged: (i) => setState(() => _current = i),
              itemBuilder:   (_, i) => _TestimonialCard(data: _list[i], isActive: i == _current),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_list.length, (i) {
              final a = i == _current;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: a ? 26 : 7, height: 7,
                decoration: BoxDecoration(color: a ? kGold : kWhite30, borderRadius: BorderRadius.circular(4)),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final Map<String, String> data;
  final bool isActive;
  const _TestimonialCard({required this.data, required this.isActive});
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity:  isActive ? 1.0 : 0.38,
      duration: const Duration(milliseconds: 280),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color:        const Color(0xFF0D2E44),
          borderRadius: BorderRadius.circular(18),
          border:       Border.all(color: isActive ? kGold.withOpacity(0.35) : Colors.transparent),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.format_quote, color: kGold, size: 28),
            const SizedBox(height: 8),
            Expanded(
              child: Text(data['quote']!,
                  style: const TextStyle(color: kWhite70, fontSize: 12, height: 1.7, fontStyle: FontStyle.italic),
                  overflow: TextOverflow.ellipsis, maxLines: 4),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                CircleAvatar(radius: 20, backgroundColor: kGold,
                    child: Text(data['initials']!, style: const TextStyle(color: kNavy, fontWeight: FontWeight.w900, fontSize: 12))),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data['name']!, style: const TextStyle(color: kWhite, fontWeight: FontWeight.w700, fontSize: 13)),
                    Text(data['role']!, style: const TextStyle(color: kGold,  fontSize: 11)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// CTA
// ═══════════════════════════════════════════════════════════════════════════════
class _CtaSection extends StatelessWidget {
  const _CtaSection();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(18),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient:     const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [kGold, Color(0xFF8A6418)]),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          const Icon(Icons.airplanemode_active, color: kNavy, size: 44),
          const SizedBox(height: 14),
          const Text('Choose Cougar.\nChoose Excellence.',
              textAlign: TextAlign.center,
              style: TextStyle(color: kNavy, fontSize: 24, fontWeight: FontWeight.w900, height: 1.3)),
          const SizedBox(height: 10),
          Text(
            'Step into an academy where standards, discipline,\nand professionalism define your future.',
            textAlign: TextAlign.center,
            style: TextStyle(color: kNavy.withOpacity(0.65), fontSize: 12, height: 1.6),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: kNavy,
                foregroundColor: kGold,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape:   RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                elevation: 0,
              ),
              child: const Text('Get Started Today',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, letterSpacing: 0.4)),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// FOOTER
// ═══════════════════════════════════════════════════════════════════════════════
class _Footer extends StatelessWidget {
  const _Footer();

  Future<void> _callNow() async {
    final uri = Uri.parse('tel:$kPhone');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kNavyDark,
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 36),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 60, height: 60, child: Image.asset('assets/images/cougar_img.png')),
              const SizedBox(width: 11),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('COUGAR AVIATION', style: TextStyle(color: kWhite, fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: 2)),
                  Text('ACADEMY',         style: TextStyle(color: kGold,  fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 3)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 22),
          const Text(
            "At Cougar Aviation Academy, excellence\nis not by chance — it's by design.",
            textAlign: TextAlign.center,
            style: TextStyle(color: kWhite70, fontSize: 12, height: 1.65),
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: _callNow,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color:        kGold,
                borderRadius: BorderRadius.circular(30),
                boxShadow:    [BoxShadow(color: kGold.withOpacity(0.32), blurRadius: 18, offset: const Offset(0, 4))],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone_in_talk, color: kNavy, size: 21),
                  SizedBox(width: 10),
                  Text('Call Now', style: TextStyle(color: kNavy, fontSize: 17, fontWeight: FontWeight.w900, letterSpacing: 0.4)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(kPhone, style: TextStyle(color: kGold.withOpacity(0.65), fontSize: 13, letterSpacing: 2, fontWeight: FontWeight.w600)),
          const SizedBox(height: 28),
          Divider(color: kWhite.withOpacity(0.07)),
          const SizedBox(height: 14),
          Text(
            '© ${DateTime.now().year} Cougar Aviation Academy\nAll rights reserved.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: kWhite70, fontSize: 10, height: 1.6),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SHARED WIDGETS
// ═══════════════════════════════════════════════════════════════════════════════
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 22, height: 2, color: kGold),
        const SizedBox(width: 9),
        Flexible(
          child: Text(text,
              style: const TextStyle(color: kGold, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}

class _GoldButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _GoldButton({required this.label, required this.onTap});
  @override
  State<_GoldButton> createState() => _GoldButtonState();
}

class _GoldButtonState extends State<_GoldButton> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  bool _pressed = false;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 90), lowerBound: 0.95, upperBound: 1.0, value: 1.0);
  }

  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) { setState(() => _pressed = true); _c.reverse(); HapticFeedback.lightImpact(); },
      onTapUp:   (_) { setState(() => _pressed = false); _c.forward(); widget.onTap(); },
      onTapCancel: () { setState(() => _pressed = false); _c.forward(); },
      child: ScaleTransition(
        scale: _c,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          decoration: BoxDecoration(
            color:        kGold,
            borderRadius: BorderRadius.circular(28),
            boxShadow: _pressed ? [] : [BoxShadow(color: kGold.withOpacity(0.36), blurRadius: 14, offset: const Offset(0, 4))],
          ),
          child: Text(widget.label,
              style: const TextStyle(color: kNavy, fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 0.4)),
        ),
      ),
    );
  }
}