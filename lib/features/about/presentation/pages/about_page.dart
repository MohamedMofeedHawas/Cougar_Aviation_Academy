// ════════════════════════════════════════════════════════════════
//  about_page.dart  –  Cougar Aviation Academy
// ════════════════════════════════════════════════════════════════
//
//  pubspec.yaml — add:
//    google_maps_flutter: ^2.9.0
//
//  Android — android/app/src/main/AndroidManifest.xml
//  inside <application>:
//    <meta-data
//        android:name="com.google.android.geo.API_KEY"
//        android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
//
//  iOS — ios/Runner/AppDelegate.swift
//  before GeneratedPluginRegistrant.register:
//    GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
//
//  Assets — pubspec.yaml:
//    flutter:
//      assets:
//        - assets/images/cougar_img.png
// ════════════════════════════════════════════════════════════════

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ─── Brand Colors ─────────────────────────────────────────────
class AppColors {
  static const Color navy       = Color(0xFF081F2F);
  static const Color navyLight  = Color(0xFF0D2D42);
  static const Color gold       = Color(0xFFB68826);
  static const Color white      = Color(0xFFFFFFFF);
  static const Color whiteDim   = Color(0xD9FFFFFF);
  static const Color lightBg    = Color(0xFFF8F6F1);
  static const Color darkText   = Color(0xFF081F2F);
  static const Color greyText   = Color(0xFF555555);
  static const Color borderGold = Color(0x55B68826);
}

// ─── Image Paths ──────────────────────────────────────────────
class AppImages {
  // Local asset
  static const String cougarLogo = 'assets/images/cougar_img.png';
  // Remote
  static const String heroPilo  = 'https://cougaraviationacademy.com/wp-content/uploads/2025/12/why3.jpg';
  static const String ownerPhoto = 'https://cougaraviationacademy.com/wp-content/uploads/2026/04/newcoiugar-1-794x1024.png';
  static const String locationA1 = 'https://cougaraviationacademy.com/wp-content/uploads/2026/04/a1-768x490.jpeg';
  static const String locationA = 'https://cougaraviationacademy.com/wp-content/uploads/2026/04/a2-768x131.jpeg';
  static const String locationA3 = 'https://cougaraviationacademy.com/wp-content/uploads/2026/04/a3-768x566.jpeg';
  static const String airportB  = 'https://cougaraviationacademy.com/wp-content/uploads/2026/04/b1-768x552.jpeg';
  static const String airportB2  = 'https://cougaraviationacademy.com/wp-content/uploads/2026/04/b2-768x500.jpeg';
  static const String airportB3  = 'https://cougaraviationacademy.com/wp-content/uploads/2026/04/b3-768x600.jpeg';
  static const String airportB4  = 'https://cougaraviationacademy.com/wp-content/uploads/2026/04/b4-768x585.jpeg';
}

// ════════════════════════════════════════════════════════════════
//  SCROLL PROVIDER  –  passes ScrollController down the tree
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
//  ANIMATED SECTION  –  fade + slide triggered by scroll position
// ════════════════════════════════════════════════════════════════
class _AnimatedSection extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Offset slideBegin;

  const _AnimatedSection({
    required this.child,
    this.delay = Duration.zero,
    this.slideBegin = const Offset(0.0, 0.07),
  });

  @override
  State<_AnimatedSection> createState() => _AnimatedSectionState();
}

class _AnimatedSectionState extends State<_AnimatedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  bool _revealed = false;
  ScrollController? _scrollCtrl;
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: widget.slideBegin, end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollCtrl = _ScrollProvider.of(context)?.controller;
      _scrollCtrl?.addListener(_check);
      _check();
    });
  }

  void _check() {
    if (_revealed || !mounted) return;
    final box = _key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final top     = box.localToGlobal(Offset.zero).dy;
    final screenH = MediaQuery.of(context).size.height;
    if (top < screenH * 0.94) {
      _revealed = true;
      Future.delayed(widget.delay, () {
        if (mounted) _ctrl.forward();
      });
    }
  }

  @override
  void dispose() {
    _scrollCtrl?.removeListener(_check);
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
//  ABOUT PAGE
// ════════════════════════════════════════════════════════════════
class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final ScrollController _sc = ScrollController();
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ScrollProvider(
      controller: _sc,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: _buildAppBar(),
        body: SingleChildScrollView(
          controller: _sc,
          child: Column(
            children: [
              // ── 1. Hero Banner (no animation – always visible) ──
              const _HeroBanner(),

              // ── 2. What Makes Us Best ──
              const _AnimatedSection(
                delay: Duration(milliseconds: 60),
                child: _WhatMakesBestSection(),
              ),

              // ── 3. Owner's Message  (slides from left) ──
              const _AnimatedSection(
                slideBegin: Offset(-0.06, 0.02),
                child: _OwnerMessageSection(),
              ),

              // ── 4. Why Cougar  (slides from right) ──
              const _AnimatedSection(
                slideBegin: Offset(0.06, 0.02),
                child: _WhyCougarSection(),
              ),

              // ── 5. Location + Map ──
              _AnimatedSection(child: _LocationSection(

              )),

              // ── 6. Training Environment ──
              const _AnimatedSection(child: _TrainingSection()),

              // ── 7. CTA Band ──
              const _AnimatedSection(child: _CtaBand()),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.navy,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            color: AppColors.white, size: 20),
        onPressed: () => Navigator.maybePop(context),
      ),
      title: const Text(
        'About Us',
        style: TextStyle(
          color: AppColors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
      // Gold accent line under the AppBar
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: Container(height: 2, color: AppColors.gold),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  1. HERO BANNER
// ════════════════════════════════════════════════════════════════
class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Navy base
          Container(color: AppColors.navy),

          // Subtle gold radial glow – left side
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.centerLeft,
                radius: 1.1,
                colors: [
                  AppColors.gold.withOpacity(0.09),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Ghost flight icon (decorative)
          Positioned(
            right: -16,
            bottom: -24,
            child: Icon(
              Icons.flight_takeoff,
              size: 200,
              color: Colors.white.withOpacity(0.04),
            ),
          ),

          // Text content
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pill label
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColors.gold.withOpacity(0.55), width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'COUGAR AVIATION ACADEMY',
                    style: TextStyle(
                      color: AppColors.gold,
                      fontSize: 10.5,
                      letterSpacing: 1.6,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                /*const Text(
                  'About Us',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    height: 1.0,
                  ),
                ),*/

                const SizedBox(height: 14),
                Container(width: 52, height: 3, color: AppColors.gold),
                const SizedBox(height: 16),

                const Text(
                  'Excellence by Design, Not by Chance.',
                  style: TextStyle(
                    color: AppColors.whiteDim,
                    fontSize: 14.5,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),

          // Bottom gradient fade
          Positioned(
            bottom: 0, left: 0, right: 0, height: 60,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, AppColors.navy.withOpacity(0.6)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  2. WHAT MAKES US BEST
// ════════════════════════════════════════════════════════════════
class _WhatMakesBestSection extends StatelessWidget {
  const _WhatMakesBestSection();

  static const _features = [
    ('Selective CFIs',         'Only instructors with 750–1,000+ flight hours'),
    ('Character First',        'Personality and communication valued before technical skills'),
    ('Strong Team Identity',   'Unified values, vision, and training approach'),
    ('High-Standard Aircraft', 'Carefully selected and maintained for maximum safety'),
    ('Premium Accommodation',  '5-star housing for comfort and focus'),
    ('Top-Tier Facilities',    'Training spaces chosen for quality and professionalism'),
    ('Supportive Environment', 'A positive atmosphere that boosts learning'),
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: isWide
          ? Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 6, child: _left(context)),
          const SizedBox(width: 40),
          Expanded(flex: 4, child: _photo()),
        ],
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_photo(), const SizedBox(height: 36), _left(context)],
      ),
    );
  }

  Widget _left(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel('Welcome to Cougar Aviation Academy'),
        const SizedBox(height: 10),
        Text(
          "What Makes Us Florida's Best?",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.navy,
            fontWeight: FontWeight.w800,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "At Cougar Aviation Academy, excellence is not by chance — it's by design. "
              'We are selective in every detail, ensuring our students receive only the best.',
          style: TextStyle(
              color: AppColors.greyText, fontSize: 14.5, height: 1.75),
        ),
        const SizedBox(height: 28),
        for (final f in _features) _FeatureTile(title: f.$1, desc: f.$2),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.lightBg,
            borderRadius: BorderRadius.circular(12),
            border:
            const Border(left: BorderSide(color: AppColors.gold, width: 4)),
          ),
          child: const Text(
            'At Cougar Aviation Academy, everything is chosen with purpose — '
                'because your success deserves nothing less.',
            style: TextStyle(
              color: AppColors.darkText,
              fontSize: 13.5,
              height: 1.65,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  Widget _photo() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold, width: 3),
        boxShadow: [
          BoxShadow(
              color: AppColors.gold.withOpacity(0.2),
              blurRadius: 22,
              offset: const Offset(0, 8)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17),
        child: CachedNetworkImage(
          imageUrl: AppImages.heroPilo,
          fit: BoxFit.cover,
          placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
          errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
        ),
        /*Image.network(
          AppImages.heroPilot,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 320,
        ),*/
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final String title, desc;
  const _FeatureTile({required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child:
            const Icon(Icons.check_rounded, color: AppColors.gold, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: AppColors.darkText,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
                const SizedBox(height: 3),
                Text(desc,
                    style: const TextStyle(
                        color: AppColors.greyText,
                        fontSize: 13,
                        height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  3. OWNER'S MESSAGE
// ════════════════════════════════════════════════════════════════
class _OwnerMessageSection extends StatelessWidget {
  const _OwnerMessageSection();

  static const _paragraphs = [
    'My name is Captain Mahmoud WAHBY, founder of Cougar Aviation Academy.',
    'I bring with me over 4,000 flight hours, holding both FAA & ICAO Airline Transport Pilot Licenses, and I am A320 type-rated.',
    'With more than 25 years of service in the Egyptian Air Force, I have led as an instructor, commander, and aerobatic team leader. I have also served as a Defence Attaché in Europe, representing Egypt across four countries. Along the way, I earned two Master\'s degrees, multiple safety and training certifications, and international recognition for leadership and excellence.',
    'My philosophy is simple: Learning Never Ends.',
    'At Cougar Aviation Academy, my mission is to provide world-class training built on professionalism, safety, and passion for aviation.',
    'At Cougar Aviation Academy, the satisfaction of our CFIs comes first — because when instructors are supported and motivated, our students naturally receive the highest quality of training and care.',
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    return Container(
      color: AppColors.navy,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: isWide
          ? Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: _photo()),
          const SizedBox(width: 48),
          Expanded(flex: 6, child: _content(context)),
        ],
      )
          : Column(
        children: [
          _photo(),
          const SizedBox(height: 36),
          _content(context),
        ],
      ),
    );
  }

  Widget _photo() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold, width: 3),
        boxShadow: [
          BoxShadow(
              color: AppColors.gold.withOpacity(0.25),
              blurRadius: 24,
              offset: const Offset(0, 8)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17),
        child: CachedNetworkImage(
          imageUrl: AppImages.ownerPhoto,
          fit: BoxFit.cover,
          placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
          errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
        )
      ),
    );
  }

  Widget _content(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel("Owner's Message", isLight: true),
        const SizedBox(height: 10),
        Text(
          'A Message from Our Founder',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w800,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 8),
        Container(width: 50, height: 3, color: AppColors.gold),
        const SizedBox(height: 28),
        for (final p in _paragraphs)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(p,
                style: const TextStyle(
                    color: AppColors.whiteDim, fontSize: 14.5, height: 1.8)),
          ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  4. WHY THE NAME "COUGAR"  –  logo shown beside content
// ════════════════════════════════════════════════════════════════
class _WhyCougarSection extends StatelessWidget {
  const _WhyCougarSection();

  static const _paragraphs = [
    'The name Cougar carries a very special meaning in my life and career.',
    'A cougar is a symbol of discipline, speed, precision, seriousness, transparency, and professionalism — all values I believe in deeply. But beyond the symbolism, Cougar is much more personal.',
    'It was the name of my fighter section unit formation in the Egyptian Air Force. Most importantly, it was also the callsign of my beloved instructor, Hany Salah — the man I admired, respected, and learned everything from when he first instructed me in 1996.',
    'Tragically, he passed away at the young age of 27 in an accident on May 15, 2000. Since that day, I have carried the name Cougar forward — not only as a mark of excellence, but also as a tribute of loyalty, respect, and belonging. Even today, I keep close contact with his family, because for me, his story never ends — and his legacy lives on through everything I do at Cougar Aviation Academy.',
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    return Container(
      color: AppColors.lightBg,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: isWide
          ? Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(flex: 6, child: _content(context)),
          const SizedBox(width: 48),
          Expanded(flex: 4, child: _logo()),
        ],
      )
          : Column(
        children: [_logo(), const SizedBox(height: 36), _content(context)],
      ),
    );
  }

  Widget _content(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel('The Story Behind the Name'),
        const SizedBox(height: 10),
        Text(
          'Why the Name "Cougar"?',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.navy,
            fontWeight: FontWeight.w800,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 8),
        Container(width: 50, height: 3, color: AppColors.gold),
        const SizedBox(height: 28),
        for (final p in _paragraphs)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(p,
                style: const TextStyle(
                    color: AppColors.darkText, fontSize: 14.5, height: 1.8)),
          ),
      ],
    );
  }

  Widget _logo() {
    return Image.asset(
      AppImages.cougarLogo,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => const Padding(
        padding: EdgeInsets.all(24),
        child: Icon(Icons.image_not_supported_outlined,
            color: AppColors.gold, size: 80),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  5. LOCATION  –  Google Map + photos + accordion
// ════════════════════════════════════════════════════════════════
class _LocationSection extends StatelessWidget {

   _LocationSection();
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  // DeLand Municipal Airport (KDED)
  static const _kded = LatLng(29.0633216, -81.2876747);

  static const _accordionItems = [
    _AccordionData(
      title: 'Prime Aviation Location',
      body:
      "Strategically positioned near one of Florida's most active training airports — "
          'low air traffic, ideal year-round weather, professional environment used by top '
          'flight schools, and quick access from briefing room to aircraft.',
    ),
    _AccordionData(
      title: 'Professional Regus Facility',
      body: 'Our administrative HQ is inside a high-standard Regus office — modern '
          'environment, professional meeting rooms, high-speed internet, and comfortable '
          'student coordination space. Low overhead means more competitive training prices '
          'without compromising quality.',
    ),
    _AccordionData(
      title: 'Ideal for International Students',
      body: 'DeLand is a calm, secure city close to Orlando International Airport, with '
          'easy access to student accommodation and nearby aviation institutions and universities.',
    ),
    _AccordionData(
      title: 'Accessibility & Convenience',
      body: "A few minutes' drive to the airport, close to restaurants, supermarkets, "
          'and student services, with easy transportation and ample parking.',
    ),
    _AccordionData(
      title: 'Why Our Location Matters',
      body: 'A professional business environment combined with direct access to an active '
          'training airport gives students the perfect balance of efficiency, comfort, '
          'and real aviation exposure.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.navy,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          const _SectionLabel('DeLand, Florida', isLight: true),
          const SizedBox(height: 10),
          Text(
            'Our Location',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.white, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Container(width: 50, height: 3, color: AppColors.gold),
          const SizedBox(height: 16),
          const Text(
            "Located in the heart of Florida's aviation hub, Cougar Aviation Academy "
                'operates from a modern office within a prestigious Regus business center, '
                'just minutes from DeLand Municipal Airport.',
            style: TextStyle(
                color: AppColors.whiteDim, fontSize: 14.5, height: 1.7),
          ),
          const SizedBox(height: 32),

          // ── Google Map ──
          Container(
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.borderGold, width: 1.5),
              boxShadow: [
                BoxShadow(
                    color: AppColors.gold.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 6)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(19),
              child: GoogleMap(
                mapType: MapType.hybrid,
                initialCameraPosition:
                const CameraPosition(target: _kded, zoom: 14),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                markers: {
                  const Marker(
                    markerId: MarkerId('kded'),
                    position: _kded,
                    // Default marker is red – matches the user's request
                    infoWindow: InfoWindow(
                      title: 'Cougar Aviation Academy',
                      snippet: 'DeLand Municipal Airport (KDED), Florida',
                    ),
                  ),
                },
                zoomControlsEnabled: true,
                zoomGesturesEnabled: true,
                scrollGesturesEnabled: true,
                rotateGesturesEnabled: false,
                tiltGesturesEnabled: false,
                myLocationButtonEnabled: false,
                mapToolbarEnabled: true,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // ── Photo Grid ──
          Row(
            children: [CachedNetworkImage(
            imageUrl: AppImages.locationA1,
            fit: BoxFit.cover,
            placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
            errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
          ), CachedNetworkImage(
      imageUrl: AppImages.locationA,
      fit: BoxFit.cover,
      placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
      errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
    ), CachedNetworkImage(
              imageUrl: AppImages.locationA3,
              fit: BoxFit.cover,
              placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
              errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
            ),]
                .map((url) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: AppColors.borderGold, width: 1.5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child:
                    CachedNetworkImage(
                      imageUrl: url.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
                      errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
                    ),
                  ),
                ),
              ),
            ))
                .toList(),
          ),

          const SizedBox(height: 32),

          // ── Accordion ──
          const _AccordionGroup(isDark: true, items: _accordionItems),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  6. TRAINING ENVIRONMENT
// ════════════════════════════════════════════════════════════════
class _TrainingSection extends StatelessWidget {
  const _TrainingSection();

  static const _accordionItems = [
    _AccordionData(
      title: 'Why DeLand Airport is Ideal for Training',
      body: 'Minimal congestion means more time flying and less time waiting. '
          'The airport is widely used by multiple flight schools, creating a serious and '
          "focused aviation environment. Florida's year-round favorable weather ensures "
          'consistent schedules with fewer delays.',
    ),
    _AccordionData(
      title: 'Airport Facilities & Infrastructure',
      body: 'Well-maintained runways for training aircraft, dedicated general aviation areas, '
          'reliable fuel services and maintenance support, and an easy ground movement layout '
          'for student pilots.',
    ),
    _AccordionData(
      title: 'Training Advantage',
      body: 'Build confidence in real operational environments, enhance radio communication '
          'and situational awareness, accelerate progression through efficient flight '
          'operations, and develop airline-level discipline from day one.',
    ),
    _AccordionData(
      title: 'The Cougar Advantage',
      body: 'Our proximity to DeLand Airport allows seamless integration between ground '
          'training and flight operations — smooth, professional, and highly efficient '
          'from start to finish.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel('DeLand Municipal Airport (KDED)'),
          const SizedBox(height: 10),
          Text(
            'Training Environment',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.navy, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Container(width: 50, height: 3, color: AppColors.gold),
          const SizedBox(height: 16),
          const Text(
            'Just minutes from our headquarters, DeLand Municipal Airport (KDED) is one of '
                "Florida's most respected and training-friendly airports.",
            style:
            TextStyle(color: AppColors.greyText, fontSize: 14.5, height: 1.7),
          ),
          const SizedBox(height: 32),

          // Airport Photos
          GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.3,
            children: [
              CachedNetworkImage(
                imageUrl: AppImages.airportB,
                fit: BoxFit.cover,
                placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
                errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
              ),
              CachedNetworkImage(
                imageUrl: AppImages.airportB2,
                fit: BoxFit.cover,
                placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
                errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
              ),
              CachedNetworkImage(
                imageUrl: AppImages.airportB3,
                fit: BoxFit.cover,
                placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
                errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
              ),
              CachedNetworkImage(
                imageUrl: AppImages.airportB4,
                fit: BoxFit.cover,
                placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
                errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
              ),
            ]
                .map((url) => Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: AppColors.borderGold, width: 1.5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: url.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
                ),
              ),
            ))
                .toList(),
          ),

          const SizedBox(height: 32),
          const _TrainingHighlights(),
          const SizedBox(height: 32),
          const _AccordionGroup(isDark: false, items: _accordionItems),
        ],
      ),
    );
  }
}

class _TrainingHighlights extends StatelessWidget {
  const _TrainingHighlights();

  static const _items = [
    ('Low Traffic, High Efficiency',   'Less waiting, more flying — reduced cost and duration.'),
    ('Professional Atmosphere',        'Multiple flight schools. Focused, serious environment.'),
    ('Excellent Weather',              "Florida's climate keeps your schedule on track year-round."),
    ('Real-World Exposure',            'Hands-on experience with real operational procedures.'),
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    return isWide
        ? Row(
      children: _items
          .map((h) => Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: _HighlightTile(title: h.$1, desc: h.$2),
        ),
      ))
          .toList(),
    )
        : Column(
      children: _items
          .map((h) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: _HighlightTile(title: h.$1, desc: h.$2),
      ))
          .toList(),
    );
  }
}

class _HighlightTile extends StatelessWidget {
  final String title, desc;
  const _HighlightTile({required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightBg,
        borderRadius: BorderRadius.circular(12),
        border:
        const Border(left: BorderSide(color: AppColors.gold, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w700,
                  fontSize: 13)),
          const SizedBox(height: 6),
          Text(desc,
              style: const TextStyle(
                  color: AppColors.greyText, fontSize: 12.5, height: 1.5)),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  7. CTA BAND  –  no "Get Started" button
// ════════════════════════════════════════════════════════════════
class _CtaBand extends StatelessWidget {
  const _CtaBand();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.navy,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 72),
      child: Center(
        child: Column(
          children: [
            // Icon badge
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.12),
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppColors.gold.withOpacity(0.3), width: 1.5),
              ),
              child: const Icon(Icons.flight_takeoff_rounded,
                  color: AppColors.gold, size: 36),
            ),
            const SizedBox(height: 24),
            Text(
              'Choose Cougar.\nChoose Excellence.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w900,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            Container(width: 60, height: 3, color: AppColors.gold),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Step into an academy where standards, discipline, '
                    'and professionalism define your future.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.whiteDim, fontSize: 15, height: 1.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  SHARED: PROFESSIONAL ACCORDION
// ════════════════════════════════════════════════════════════════
class _AccordionData {
  final String title, body;
  const _AccordionData({required this.title, required this.body});
}

// ── Group manages open/close state ──
class _AccordionGroup extends StatefulWidget {
  final List<_AccordionData> items;
  final bool isDark;
  const _AccordionGroup({required this.items, required this.isDark});

  @override
  State<_AccordionGroup> createState() => _AccordionGroupState();
}

class _AccordionGroupState extends State<_AccordionGroup> {
  int _openIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        widget.items.length,
            (i) => _AccordionTile(
          data: widget.items[i],
          isOpen: _openIndex == i,
          isDark: widget.isDark,
          onTap: () =>
              setState(() => _openIndex = (_openIndex == i) ? -1 : i),
        ),
      ),
    );
  }
}

// ── Individual tile ──
class _AccordionTile extends StatelessWidget {
  final _AccordionData data;
  final bool isOpen, isDark;
  final VoidCallback onTap;

  const _AccordionTile({
    required this.data,
    required this.isOpen,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg       = isDark ? AppColors.navyLight : AppColors.white;
    final bodyText = isDark ? AppColors.whiteDim   : AppColors.greyText;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isOpen ? AppColors.gold : AppColors.borderGold,
          width: isOpen ? 1.5 : 1.0,
        ),
        boxShadow: [
          if (isOpen)
            BoxShadow(
              color: AppColors.gold.withOpacity(0.14),
              blurRadius: 18,
              offset: const Offset(0, 4),
            )
          else
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: AppColors.gold.withOpacity(0.06),
          highlightColor: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        data.title,
                        style: TextStyle(
                          color: isOpen
                              ? AppColors.gold
                              : AppColors.gold.withOpacity(0.78),
                          fontWeight: FontWeight.w700,
                          fontSize: 14.5,
                        ),
                      ),
                    ),
                    // Rotating arrow button
                    AnimatedRotation(
                      turns: isOpen ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: AppColors.gold
                              .withOpacity(isOpen ? 0.18 : 0.07),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.keyboard_arrow_down,
                            color: AppColors.gold, size: 20),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Body – smooth AnimatedSize expansion ──
              AnimatedSize(
                duration: const Duration(milliseconds: 330),
                curve: Curves.easeInOut,
                child: isOpen
                    ? Padding(
                  padding:
                  const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                        height: 1,
                        color: AppColors.gold.withOpacity(0.25),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        data.body,
                        style: TextStyle(
                          color: bodyText,
                          fontSize: 14,
                          height: 1.8,
                        ),
                      ),
                    ],
                  ),
                )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  SHARED: SECTION LABEL  (small gold pill with vertical bar)
// ════════════════════════════════════════════════════════════════
class _SectionLabel extends StatelessWidget {
  final String text;
  final bool isLight;
  const _SectionLabel(this.text, {this.isLight = false});

  @override
  Widget build(BuildContext context) {
    final color =
    isLight ? AppColors.gold.withOpacity(0.85) : AppColors.gold;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 4,
          height: 16,
          margin: const EdgeInsets.only(right: 8),
          color: color,
        ),
        Text(
          text.toUpperCase(),
          style: TextStyle(
            color: color,
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
          ),
        ),
      ],
    );
  }
}