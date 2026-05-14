// ════════════════════════════════════════════════════════════════
//  fleet_page.dart  –  Cougar Aviation Academy
// ════════════════════════════════════════════════════════════════
//  pubspec.yaml:
//    cached_network_image: ^3.3.1
//    smooth_page_indicator: ^1.1.0
// ════════════════════════════════════════════════════════════════

import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/constants/app_colors.dart';

// ─── Brand Colors ────────────────────────────────────────────────
class _C {
  static const navy      = Color(0xFF081F2F);
  static const navyLight = Color(0xFF0D2D42);
  static const gold      = Color(0xFFB68826);
  static const goldDim   = Color(0x44B68826);
  static const white     = Color(0xFFFFFFFF);
  static const whiteDim  = Color(0xD9FFFFFF);
  static const offWhite  = Color(0xFFF8F6F1);
  static const grey      = Color(0xFF666666);
}

// ─── Aircraft Model ──────────────────────────────────────────────
class _Aircraft {
  final String name;
  final String type;
  final String description;
  final String imageUrl;
  final List<({String label, String value, IconData icon})> specs;

  const _Aircraft({
    required this.name,
    required this.type,
    required this.description,
    required this.imageUrl,
    required this.specs,
  });
}

// ─── Fleet Data ──────────────────────────────────────────────────
const _fleetData = [
  _Aircraft(
    name: 'Cessna 172S Skyhawk',
    type: 'Primary Trainer · Single Engine',
    description:
    'The backbone of our fleet. The Cessna 172S offers outstanding stability, '
        'G1000 glass cockpit avionics, and exceptional training characteristics. '
        'Ideal for PPL, IR and early CPL training.',
    imageUrl:
    'https://cougaraviationacademy.com/wp-content/uploads/2026/01/WhatsApp-Image-2025-12-09-at-8.12.30-PM.jpeg',
    specs: [
      (label: 'Cruise Speed', value: '124 kts', icon: Icons.speed),
      (label: 'Service Ceiling', value: '14,000 ft', icon: Icons.height),
      (label: 'Range', value: '640 nm', icon: Icons.map_outlined),
      (label: 'Engine', value: 'Lycoming IO-360', icon: Icons.settings),
      (label: 'Fuel Capacity', value: '53 Gal', icon: Icons.local_gas_station),
      (label: 'Wingspan', value: '36 ft 1 in', icon: Icons.straighten),
    ],
  ),
  _Aircraft(
    name: 'Cessna 152',
    type: 'Basic Trainer · Single Engine',
    description:
    'A proven two-seat trainer perfect for initial flight training. '
        'Simple, reliable and economical. Used for ab initio pilot training '
        'and solo cross-country flights.',
    imageUrl:
    'https://www.aeroclubalicante.com/wp-content/uploads/2021/09/Cessna-152-ED-ESO.jpg',
    specs: [
      (label: 'Cruise Speed', value: '107 kts', icon: Icons.speed),
      (label: 'Service Ceiling', value: '14,700 ft', icon: Icons.height),
      (label: 'Range', value: '415 nm', icon: Icons.map_outlined),
      (label: 'Engine', value: 'Lycoming O-235', icon: Icons.settings),
      (label: 'Fuel Capacity', value: '26 Gal', icon: Icons.local_gas_station),
      (label: 'Wingspan', value: '33 ft 4 in', icon: Icons.straighten),
    ],
  ),
  _Aircraft(
    name: 'Fleet Model 1',
    type: 'Advanced Trainer · Biplane',
    description:
    'A classic advanced training biplane that builds superior stick-and-rudder '
        'skills. Experience real aviation heritage while mastering advanced '
        'maneuvers and aerobatics.',
    imageUrl:
    'https://oldrhinebeck.org/wp-content/uploads/2021/04/Trost-Fleet-Model-1.jpeg',
    specs: [
      (label: 'Cruise Speed', value: '90 kts', icon: Icons.speed),
      (label: 'Service Ceiling', value: '13,000 ft', icon: Icons.height),
      (label: 'Range', value: '280 nm', icon: Icons.map_outlined),
      (label: 'Engine', value: 'Kinner B-5', icon: Icons.settings),
      (label: 'Fuel Capacity', value: '24 Gal', icon: Icons.local_gas_station),
      (label: 'Wingspan', value: '28 ft 0 in', icon: Icons.straighten),
    ],
  ),
  _Aircraft(
    name: 'Advanced Warplane',
    type: 'High Performance · Multi Role',
    description:
    'High-performance advanced trainer designed for experienced pilots '
        'seeking to sharpen aerobatic and high-speed flight skills. '
        'Takes your training to the next professional level.',
    imageUrl: 'https://www.warplane.com/images/Aircraft/Fleet_Fort_197.jpg',
    specs: [
      (label: 'Cruise Speed', value: '180 kts', icon: Icons.speed),
      (label: 'Service Ceiling', value: '22,000 ft', icon: Icons.height),
      (label: 'Range', value: '850 nm', icon: Icons.map_outlined),
      (label: 'Engine', value: 'Radial 9-Cyl', icon: Icons.settings),
      (label: 'Fuel Capacity', value: '80 Gal', icon: Icons.local_gas_station),
      (label: 'Wingspan', value: '38 ft 0 in', icon: Icons.straighten),
    ],
  ),
  _Aircraft(
    name: 'Cessna 172 – Academy',
    type: 'Cross-Country Trainer',
    description:
    'Our second Cessna 172 dedicated to cross-country and instrument training. '
        'Equipped with full IFR suite, this aircraft prepares students for '
        'real airline operations.',
    imageUrl:
    'https://cougaraviationacademy.com/wp-content/uploads/2026/01/WhatsApp-Image-2025-12-09-at-8.12.30-PM-1.jpeg',
    specs: [
      (label: 'Cruise Speed', value: '122 kts', icon: Icons.speed),
      (label: 'Service Ceiling', value: '14,000 ft', icon: Icons.height),
      (label: 'Range', value: '628 nm', icon: Icons.map_outlined),
      (label: 'Engine', value: 'Lycoming IO-360', icon: Icons.settings),
      (label: 'Fuel Capacity', value: '53 Gal', icon: Icons.local_gas_station),
      (label: 'Wingspan', value: '36 ft 1 in', icon: Icons.straighten),
    ],
  ),
  _Aircraft(
    name: 'Training Aircraft VI',
    type: 'Night & IFR Operations',
    description:
    'Fully equipped for night VFR and IFR training. This aircraft features '
        'advanced navigation systems and dual controls perfect for instrument '
        'rating and commercial pilot training.',
    imageUrl:
    'https://cougaraviationacademy.com/wp-content/uploads/2026/01/WhatsApp-Image-2025-12-09-at-8.12.04-PM.jpeg',
    specs: [
      (label: 'Cruise Speed', value: '118 kts', icon: Icons.speed),
      (label: 'Service Ceiling', value: '13,500 ft', icon: Icons.height),
      (label: 'Range', value: '590 nm', icon: Icons.map_outlined),
      (label: 'Engine', value: 'Continental IO-360', icon: Icons.settings),
      (label: 'Fuel Capacity', value: '48 Gal', icon: Icons.local_gas_station),
      (label: 'Wingspan', value: '35 ft 10 in', icon: Icons.straighten),
    ],
  ),
];

// Hero gallery images (carousel)
const _heroImages = [
  'https://oldrhinebeck.org/wp-content/uploads/2021/04/Trost-Fleet-Model-1.jpeg',
  'https://www.warplane.com/images/Aircraft/Fleet_Fort_197.jpg',
  'https://cougaraviationacademy.com/wp-content/uploads/2026/01/WhatsApp-Image-2025-12-09-at-8.12.27-PM.jpeg',
  'https://cougaraviationacademy.com/wp-content/uploads/2026/01/WhatsApp-Image-2025-12-09-at-8.12.30-PM-1.jpeg',
  'https://cougaraviationacademy.com/wp-content/uploads/2026/01/WhatsApp-Image-2025-12-09-at-8.12.29-PM-1.jpeg',
  'https://cougaraviationacademy.com/wp-content/uploads/2026/01/WhatsApp-Image-2025-12-09-at-8.12.04-PM.jpeg',
  'https://www.aeroclubalicante.com/wp-content/uploads/2021/09/Cessna-152-ED-ESO.jpg',
];

// ════════════════════════════════════════════════════════════════
//  SCROLL PROVIDER
// ════════════════════════════════════════════════════════════════
class _ScrollProvider extends InheritedWidget {
  final ScrollController controller;
  const _ScrollProvider({required this.controller, required super.child});
  static _ScrollProvider? of(BuildContext ctx) =>
      ctx.dependOnInheritedWidgetOfExactType<_ScrollProvider>();
  @override
  bool updateShouldNotify(_ScrollProvider old) => false;
}

// ════════════════════════════════════════════════════════════════
//  ANIMATED SECTION  (fade + slide on scroll)
// ════════════════════════════════════════════════════════════════
class _AnimSection extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Offset slideBegin;
  const _AnimSection({
    required this.child,
    this.delay = Duration.zero,
    this.slideBegin = const Offset(0, 0.07),
  });
  @override
  State<_AnimSection> createState() => _AnimSectionState();
}

class _AnimSectionState extends State<_AnimSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  final GlobalKey _key = GlobalKey();
  ScrollController? _sc;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 680));
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: widget.slideBegin, end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sc = _ScrollProvider.of(context)?.controller;
      _sc?.addListener(_check);
      _check();
    });
  }

  void _check() {
    if (_done || !mounted) return;
    final box = _key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final top = box.localToGlobal(Offset.zero).dy;
    if (top < MediaQuery.of(context).size.height * 0.94) {
      _done = true;
      Future.delayed(widget.delay, () { if (mounted) _ctrl.forward(); });
    }
  }

  @override
  void dispose() {
    _sc?.removeListener(_check);
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: _key,
      width: double.infinity,
      child: FadeTransition(
        opacity: _fade,
        child: SlideTransition(position: _slide, child: widget.child),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  FLEET PAGE
// ════════════════════════════════════════════════════════════════
class FleetPage extends StatefulWidget {
  const FleetPage({super.key});
  @override
  State<FleetPage> createState() => _FleetPageState();
}

class _FleetPageState extends State<FleetPage> {
  final ScrollController _sc = ScrollController();

  @override
  void dispose() { _sc.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return _ScrollProvider(
      controller: _sc,
      child: Scaffold(
        backgroundColor: _C.white,
        appBar: _buildAppBar(),
        body: SingleChildScrollView(
          controller: _sc,
          child: const Column(
            children: [
              // 1 · Hero carousel
              _HeroCarousel(),

              // 2 · Intro section
              _AnimSection(child: _IntroSection()),

              // 3 · Fleet cards grid
              _AnimSection(
                delay: Duration(milliseconds: 80),
                child: _FleetGrid(),
              ),

              // 4 · Stats band
              _AnimSection(
                delay: Duration(milliseconds: 100),
                child: _StatsBand(),
              ),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _C.navy,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _C.white, size: 20),
        onPressed: () => Navigator.maybePop(context),
      ),
      title: const Text(
        'Our Fleet',
        style: TextStyle(
          color: _C.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: Container(height: 2, color: _C.gold),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  1 · HERO AUTO-PLAY CAROUSEL
// ════════════════════════════════════════════════════════════════
class _HeroCarousel extends StatefulWidget {
  const _HeroCarousel();
  @override
  State<_HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<_HeroCarousel> {
  final PageController _pc = PageController(
    viewportFraction: 1,
  );
  int _current = 0;
  Timer? _timer;

  @override

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoPlay();
    });
  }

  void _startAutoPlay() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!_pc.hasClients) return;

      final nextPage = (_current + 1) % _heroImages.length;

      _pc.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() { _timer?.cancel(); _pc.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ClipRRect(
     //   borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            /// =========================
            /// Images Slider
            /// =========================
            PageView.builder(
              controller: _pc,
              itemCount: _heroImages.length,
              onPageChanged: (i) => setState(() => _current = i),
              itemBuilder: (_, i) {
                return CachedNetworkImage(
                  imageUrl: _heroImages[i],
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    color: _C.navy,
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: _C.navyLight,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.flight,
                      color: _C.gold,
                      size: 60,
                    ),
                  ),
                );
              },
            ),

            /// =========================
            /// Dark cinematic overlay
            /// =========================
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.15),
                      Colors.black.withOpacity(0.72),
                    ],
                  ),
                ),
              ),
            ),

            /// =========================
            /// Top fade
            /// =========================
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 90,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _C.navy.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            /// =========================
            /// Bottom Content
            /// =========================
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isSmall = constraints.maxWidth < 340;

                  return isSmall
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [


                      Align(
                        alignment: Alignment.center,
                        child: SmoothPageIndicator(
                          controller: _pc,
                          count: _heroImages.length,
                          effect: WormEffect(
                            dotWidth: 8,
                            dotHeight: 8,
                            spacing: 6,
                            activeDotColor: _C.gold,
                            dotColor: Colors.white.withOpacity(0.35),
                          ),
                        ),
                      ),
                    ],
                  )
                      : Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [


                      SmoothPageIndicator(
                        controller: _pc,
                        count: _heroImages.length,
                        effect: WormEffect(
                          dotWidth: 8,
                          dotHeight: 8,
                          spacing: 6,
                          activeDotColor: _C.gold,
                          dotColor: Colors.white.withOpacity(0.35),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}


// ════════════════════════════════════════════════════════════════
//  2 · INTRO SECTION
// ════════════════════════════════════════════════════════════════
class _IntroSection extends StatelessWidget {
  const _IntroSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _C.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Row(
            children: [
              Container(width: 4, height: 16, color: _C.gold, margin: const EdgeInsets.only(right: 8)),
              const Text(
                'INSIDE OUR TRAINING FLEET',
                style: TextStyle(color: _C.gold, fontSize: 10.5, fontWeight: FontWeight.w700, letterSpacing: 1.5),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Training the Future with a World-Class Fleet',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: _C.navy,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 8),
          Container(width: 50, height: 3, color: _C.gold),
          const SizedBox(height: 20),
          const Text(
            'Every aircraft in the Cougar Aviation Academy fleet represents our dedication '
                'to the highest standards of aviation training and excellence. '
                'From advanced training aircraft to specialized platforms designed for diverse '
                'aviation missions, our fleet is built to prepare pilots beyond industry expectations.',
            style: TextStyle(color: _C.grey, fontSize: 14.5, height: 1.75),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  3 · FLEET CARDS GRID
// ════════════════════════════════════════════════════════════════
class _FleetGrid extends StatelessWidget {
  const _FleetGrid();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _C.offWhite,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Column(
        children: List.generate(_fleetData.length, (i) {
          return _AnimSection(
            delay: Duration(milliseconds: i * 60),
            slideBegin: i.isEven
                ? const Offset(-0.05, 0.03)
                : const Offset(0.05, 0.03),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _FleetCard(
                aircraft: _fleetData[i],
                index: i,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AircraftDetailPage(aircraft: _fleetData[i]),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─── Individual Fleet Card ──────────────────────────────────────
class _FleetCard extends StatefulWidget {
  final _Aircraft aircraft;
  final int index;
  final VoidCallback onTap;
  const _FleetCard({required this.aircraft, required this.index, required this.onTap});
  @override
  State<_FleetCard> createState() => _FleetCardState();
}

class _FleetCardState extends State<_FleetCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _hovered = true),
      onTapUp:   (_) => setState(() => _hovered = false),
      onTapCancel: ()  => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        transform: Matrix4.identity()..scale(_hovered ? 0.985 : 1.0),
        decoration: BoxDecoration(
          color: _C.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered ? _C.gold : _C.gold.withOpacity(0.22),
            width: _hovered ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: _hovered
                  ? _C.gold.withOpacity(0.18)
                  : Colors.black.withOpacity(0.06),
              blurRadius: _hovered ? 22 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ──
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.aircraft.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      height: 200,
                      color: _C.navyLight,
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(_C.gold),
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      height: 200,
                      color: _C.navyLight,
                      child: const Icon(Icons.flight, size: 64, color: _C.gold),
                    ),
                  ),
                  // Overlay gradient
                  Positioned(
                    bottom: 0, left: 0, right: 0, height: 80,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
                        ),
                      ),
                    ),
                  ),
                  // Number badge
                  Positioned(
                    top: 14, right: 14,
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: _C.navy.withOpacity(0.82),
                        shape: BoxShape.circle,
                        border: Border.all(color: _C.gold, width: 1.5),
                      ),
                      child: Center(
                        child: Text(
                          '${widget.index + 1}',
                          style: const TextStyle(
                            color: _C.gold,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Type badge
                  Positioned(
                    bottom: 12, left: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _C.gold.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.aircraft.type,
                        style: const TextStyle(
                          color: _C.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Content ──
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    widget.aircraft.name,
                    style: const TextStyle(
                      color: _C.navy,
                      fontWeight: FontWeight.w800,
                      fontSize: 17,
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Description
                  Text(
                    widget.aircraft.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: _C.grey, fontSize: 13.5, height: 1.6),
                  ),
                  const SizedBox(height: 16),

                  // Specs mini grid (3 items)
                  Row(
                    children: widget.aircraft.specs.take(3).map((s) {
                      return Expanded(
                        child: _MiniSpec(label: s.label, value: s.value, icon: s.icon),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // CTA row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'View Full Specs',
                        style: TextStyle(
                          color: _C.gold,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      Container(
                        width: 34, height: 34,
                        decoration: BoxDecoration(
                          color: _C.gold.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(color: _C.gold.withOpacity(0.4), width: 1),
                        ),
                        child: const Icon(Icons.arrow_forward_rounded, color: _C.gold, size: 18),
                      ),
                    ],
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

class _MiniSpec extends StatelessWidget {
  final String label, value;
  final IconData icon;
  const _MiniSpec({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: _C.gold, size: 16),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: _C.navy, fontWeight: FontWeight.w700, fontSize: 12)),
        Text(label, style: TextStyle(color: _C.grey.withOpacity(0.8), fontSize: 10, height: 1.3)),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  4 · STATS BAND
// ════════════════════════════════════════════════════════════════
class _StatsBand extends StatelessWidget {
  const _StatsBand();

  static const _stats = [
    (value: '6+',   label: 'Aircraft'),
    (value: '4,000+', label: 'Flight Hours'),
    (value: '100%', label: 'Safety Record'),
    (value: '3',    label: 'Aircraft Types'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _C.navy,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        children: [
          Row(
            children: [
              Container(width: 4, height: 16, color: _C.gold, margin: const EdgeInsets.only(right: 8)),
              const Text(
                'BY THE NUMBERS',
                style: TextStyle(color: _C.gold, fontSize: 10.5, fontWeight: FontWeight.w700, letterSpacing: 1.5),
              ),
            ],
          ),
          const SizedBox(height: 28),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.7,
            children: _stats.map((s) => _StatItem(value: s.value, label: s.label)).toList(),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value, label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: _C.navyLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.gold.withOpacity(0.25), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: _C.gold,
              fontSize: 26,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: _C.whiteDim, fontSize: 12, height: 1.2)),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  AIRCRAFT DETAIL PAGE
// ════════════════════════════════════════════════════════════════
class AircraftDetailPage extends StatefulWidget {
  final _Aircraft aircraft;
  const AircraftDetailPage({super.key, required this.aircraft});
  @override
  State<AircraftDetailPage> createState() => _AircraftDetailPageState();
}

class _AircraftDetailPageState extends State<AircraftDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    WidgetsBinding.instance.addPostFrameCallback((_) => _ctrl.forward());
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final a = widget.aircraft;

    return Scaffold(
      backgroundColor: _C.white,
      body: CustomScrollView(
        slivers: [
          // ── Collapsible hero image ──
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: _C.navy,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _C.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                a.name,
                style: const TextStyle(
                  color: _C.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: a.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: _C.navy),
                    errorWidget: (_, __, ___) => Container(
                      color: _C.navyLight,
                      child: const Icon(Icons.flight, color: _C.gold, size: 80),
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, _C.navy.withOpacity(0.75)],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(2),
              child: Container(height: 2, color: _C.gold),
            ),
          ),

          // ── Body ──
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Type badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                        decoration: BoxDecoration(
                          color: _C.gold.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _C.gold.withOpacity(0.4)),
                        ),
                        child: Text(
                          a.type,
                          style: const TextStyle(
                            color: _C.gold,
                            fontWeight: FontWeight.w600,
                            fontSize: 11.5,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Name
                      Text(
                        a.name,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: _C.navy,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(width: 50, height: 3, color: _C.gold),
                      const SizedBox(height: 18),

                      // Description
                      Text(
                        a.description,
                        style: const TextStyle(color: _C.grey, fontSize: 14.5, height: 1.75),
                      ),
                      const SizedBox(height: 32),

                      // ── Specs section ──
                      Row(
                        children: [
                          Container(width: 4, height: 18, color: _C.gold, margin: const EdgeInsets.only(right: 10)),
                          const Text(
                            'TECHNICAL SPECIFICATIONS',
                            style: TextStyle(
                              color: _C.gold,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.4,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Specs grid
                      Container(
                        decoration: BoxDecoration(
                          color: _C.navy,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _C.gold.withOpacity(0.2)),
                          boxShadow: [
                            BoxShadow(
                              color: _C.navy.withOpacity(0.15),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: 1.6,
                          padding: const EdgeInsets.all(16),
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          children: a.specs.map((s) => _SpecCard(
                            icon: s.icon,
                            label: s.label,
                            value: s.value,
                          )).toList(),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // ── Features banner ──
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [_C.gold, Color(0xFFD4A843)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
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
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ready to Fly?',
                                    style: TextStyle(color: _C.white, fontWeight: FontWeight.w800, fontSize: 16),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Book your training session with this aircraft today.',
                                    style: TextStyle(color: _C.white, fontSize: 12.5, height: 1.4),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecCard extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _SpecCard({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _C.navyLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _C.gold.withOpacity(0.18), width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: _C.gold, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(color: _C.white, fontWeight: FontWeight.w700, fontSize: 13)),
                Text(label, style: TextStyle(color: _C.whiteDim.withOpacity(0.6), fontSize: 10.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}