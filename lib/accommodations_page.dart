import 'dart:math' as math;
import 'package:cougar_app/features/courses/presentation/pages/courses_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// ─── COLORS ──────────────────────────────────────────────────────────────────
const _kNavy      = Color(0xFF081F2F);
const _kNavyDeep  = Color(0xFF051520);
const _kGold      = Color(0xFFB68826);
const _kGoldLight = Color(0xFFD4A83A);
const _kWhite     = Color(0xFFFFFFFF);
const _kLight     = Color(0xFFF8F6F0);
const _kGrey      = Color(0xFF9AA5AF);



// ─────────────────────────────────────────────────────────────────────────────
// MAIN PAGE
// ─────────────────────────────────────────────────────────────────────────────
class AccommodationsPage extends StatefulWidget {
  const AccommodationsPage({super.key});
  @override
  State<AccommodationsPage> createState() => _AccommodationsPageState();
}

class _AccommodationsPageState extends State<AccommodationsPage>
    with TickerProviderStateMixin {

  final _scrollController = ScrollController();
  late final AnimationController _heroCtrl;
  late final AnimationController _floatCtrl;
  late final AnimationController _shimmerCtrl;

  // Section visibility keys
  final _introKey     = GlobalKey();
  final _whyKey       = GlobalKey();
  final _packagesKey  = GlobalKey();
  final _servicesKey  = GlobalKey();
  final _videosKey    = GlobalKey();
  final _bookingKey   = GlobalKey();

  // Visibility flags
  bool _introVisible    = false;
  bool _whyVisible      = false;
  bool _packagesVisible = false;
  bool _servicesVisible = false;
  bool _videosVisible   = false;
  bool _bookingVisible  = false;

  @override
  void initState() {
    super.initState();

    _heroCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1200),
    )..forward();

    _floatCtrl = AnimationController(
      vsync: this, duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _shimmerCtrl = AnimationController(
      vsync: this, duration: const Duration(seconds: 3),
    )..repeat();

    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  void _onScroll() {
    final screenH = MediaQuery.of(context).size.height;
    void check(GlobalKey key, bool current, void Function(bool) set) {
      if (current) return;
      final ctx = key.currentContext;
      if (ctx == null) return;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null) return;
      final pos = box.localToGlobal(Offset.zero);
      if (pos.dy < screenH * 0.92) set(true);
    }
    setState(() {
      check(_introKey,    _introVisible,    (v) => _introVisible    = v);
      check(_whyKey,      _whyVisible,      (v) => _whyVisible      = v);
      check(_packagesKey, _packagesVisible, (v) => _packagesVisible = v);
      check(_servicesKey, _servicesVisible, (v) => _servicesVisible = v);
      check(_videosKey,   _videosVisible,   (v) => _videosVisible   = v);
      check(_bookingKey,  _bookingVisible,  (v) => _bookingVisible  = v);
    });
  }

  @override
  void dispose() {
    _heroCtrl.dispose();
    _floatCtrl.dispose();
    _shimmerCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: _kLight,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Hero ──
          SliverToBoxAdapter(
            child: _HeroSection(
              heroCtrl: _heroCtrl,
              floatCtrl: _floatCtrl,
            ),
          ),
          // ── Intro ──
          SliverToBoxAdapter(
            child: _FadeSlideSection(
              key: _introKey,
              visible: _introVisible,
              delay: 0,
              child: _IntroSection(),
            ),
          ),
          // ── Why Choose ──
          SliverToBoxAdapter(
            child: _FadeSlideSection(
              key: _whyKey,
              visible: _whyVisible,
              delay: 0,
              child: _WhyChooseSection(floatCtrl: _floatCtrl),
            ),
          ),
          // ── Packages ──
          SliverToBoxAdapter(
            child: _FadeSlideSection(
              key: _packagesKey,
              visible: _packagesVisible,
              delay: 0,
              child: _PackagesSection(),
            ),
          ),
          // ── Services ──
          SliverToBoxAdapter(
            child: _FadeSlideSection(
              key: _servicesKey,
              visible: _servicesVisible,
              delay: 0,
              child: _ServicesSection(),
            ),
          ),
          // ── Videos ──
          SliverToBoxAdapter(
            child: _FadeSlideSection(
              key: _videosKey,
              visible: _videosVisible,
              delay: 0,
              child: _VideosSection(),
            ),
          ),
          // ── Price ──
          SliverToBoxAdapter(
            child: _PriceSection(shimmerCtrl: _shimmerCtrl),
          ),
          // ── How to Book ──
          SliverToBoxAdapter(
            child: _FadeSlideSection(
              key: _bookingKey,
              visible: _bookingVisible,
              delay: 0,
              child: _BookingSection(),
            ),
          ),
          // ── Footer CTA ──
          SliverToBoxAdapter(child: _FooterCTA()),
        ],
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
        'Our Accommodations',
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

// ─────────────────────────────────────────────────────────────────────────────
// FADE+SLIDE WRAPPER
// ─────────────────────────────────────────────────────────────────────────────
class _FadeSlideSection extends StatefulWidget {
  final Widget child;
  final bool visible;
  final int delay;
  const _FadeSlideSection({
    super.key, required this.child, required this.visible, required this.delay,
  });
  @override State<_FadeSlideSection> createState() => _FadeSlideSectionState();
}

class _FadeSlideSectionState extends State<_FadeSlideSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this, duration: const Duration(milliseconds: 700),
  );
  late final Animation<double> _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  late final Animation<double> _slide = Tween(begin: 40.0, end: 0.0).animate(
    CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
  );

  @override void didUpdateWidget(_FadeSlideSection old) {
    super.didUpdateWidget(old);
    if (widget.visible && !old.visible) {
      Future.delayed(Duration(milliseconds: widget.delay), () {
        if (mounted) _ctrl.forward();
      });
    }
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _ctrl,
    builder: (_, child) => Opacity(
      opacity: _fade.value,
      child: Transform.translate(offset: Offset(0, _slide.value), child: child),
    ),
    child: widget.child,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// HERO SECTION
// ─────────────────────────────────────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  final AnimationController heroCtrl;
  final AnimationController floatCtrl;
  const _HeroSection({required this.heroCtrl, required this.floatCtrl});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return AnimatedBuilder(
      animation: heroCtrl,
      builder: (_, __) {
        final t = CurvedAnimation(parent: heroCtrl, curve: Curves.easeOutCubic).value;
        return Container(
          height: w < 600 ? 340 : 420,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://cougaraviationacademy.com/wp-content/uploads/2025/12/Ten60-Halifax-web-5.jpg',
              ),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Gradient overlay
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _kNavyDeep.withOpacity(0.3),
                      _kNavy.withOpacity(0.88),
                    ],
                    stops: const [0.2, 1.0],
                  ),
                ),
              ),
              // Floating decorative planes
              ..._buildPlanes(floatCtrl, w),
              // Content
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Opacity(
                      opacity: t,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - t)),
                        child: Text(
                          'Welcome To Cougar Aviation Academy',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _kGold,
                            fontSize: w < 600 ? 12 : 14,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Opacity(
                      opacity: t,
                      child: Transform.translate(
                        offset: Offset(0, 30 * (1 - t)),
                        child: Text(
                          'Ten60 Halifax',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _kWhite,
                            fontSize: w < 600 ? 32 : 46,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                            height: 1.1,
                            shadows: const [
                              Shadow(color: Colors.black45, blurRadius: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Opacity(
                      opacity: t,
                      child: _GoldDivider(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildPlanes(AnimationController ctrl, double w) {
    return [
      _FloatingPlane(ctrl: ctrl, top: 0.18, speed: 1.0, opacity: 0.18, size: 22),
      _FloatingPlane(ctrl: ctrl, top: 0.45, speed: 0.65, opacity: 0.12, size: 16),
      _FloatingPlane(ctrl: ctrl, top: 0.28, speed: 0.8, opacity: 0.15, size: 18),
    ];
  }
}

class _FloatingPlane extends StatelessWidget {
  final AnimationController ctrl;
  final double top;
  final double speed;
  final double opacity;
  final double size;
  const _FloatingPlane({
    required this.ctrl, required this.top, required this.speed,
    required this.opacity, required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.sizeOf(context).width;
    return LayoutBuilder(builder: (_, constraints) {
      return AnimatedBuilder(
        animation: ctrl,
        builder: (_, __) {
          final progress = (ctrl.value * speed) % 1.0;
          final x = -60.0 + (sw + 120) * progress;
          final y = constraints.maxHeight * top +
              math.sin(progress * math.pi * 2) * 8;
          return Positioned(
            left: x, top: y,
            child: Opacity(
              opacity: opacity,
              child: Icon(Icons.airplanemode_active_rounded,
                  color: _kGold, size: size),
            ),
          );
        },
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// INTRO SECTION
// ─────────────────────────────────────────────────────────────────────────────
class _IntroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return Container(
      color: _kNavy,
      padding: EdgeInsets.symmetric(
        horizontal: w < 600 ? 24 : 80,
        vertical: 72,
      ),
      child: Column(
        children: [
          _GoldLabel('Comfort, Safety & Convenience'),
          const SizedBox(height: 16),
          Text(
            'Your Home During Training',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _kWhite,
              fontSize: w < 600 ? 26 : 38,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 24),
          _GoldDivider(),
          const SizedBox(height: 24),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Text(
              'Cougar Aviation Academy provides students with high-quality '
                  'accommodation options designed to make your training experience '
                  'smooth, safe, and comfortable. Our primary housing partner is '
                  'Ten60 Halifax, one of the most modern and secure residential '
                  'buildings in the Daytona Beach – DeLand area.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _kWhite.withOpacity(0.75),
                fontSize: w < 600 ? 14 : 16,
                height: 1.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// WHY CHOOSE SECTION
// ─────────────────────────────────────────────────────────────────────────────
class _WhyChooseSection extends StatelessWidget {
  final AnimationController floatCtrl;
  const _WhyChooseSection({required this.floatCtrl});

  static const _features = [
    (
    icon: Icons.location_on_rounded,
    title: 'Premium Location',
    points: [
      '10 minutes from Daytona Beach International Airport',
      '20–25 minutes from Cougar Aviation Academy (DeLand)',
      'Close to shopping centers, restaurants & transportation',
      'Quiet, safe, and student-friendly environment',
    ],
    ),
    (
    icon: Icons.apartment_rounded,
    title: 'Modern, Fully-Furnished Apartments',
    points: [
      'Private bedroom & bathroom',
      'Fully equipped kitchen + High-speed Wi-Fi',
      'Smart TV, Air conditioning, Washer & dryer',
      'Balcony with stunning views (selected units)',
    ],
    ),
    (
    icon: Icons.pool_rounded,
    title: 'Building Facilities',
    points: [
      'Swimming pool & Fitness center',
      'Study lounges & Secure parking',
      '24/7 security and controlled access',
      'Game area, social spaces & On-site management',
    ],
    ),
    (
    icon: Icons.attach_money_rounded,
    title: 'Price',
    points: [
      '\$1,000 per course',
      'Flexible booking options',
      'Early booking recommended',
      'Limited spaces available',
    ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return Container(
      color: _kLight,
      padding: EdgeInsets.symmetric(
        horizontal: w < 600 ? 20 : 60,
        vertical: 72,
      ),
      child: Column(
        children: [
          _GoldLabel('Start Your Journey With Peace of Mind'),
          const SizedBox(height: 12),
          Text(
            'Why Choose Ten60 Halifax?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _kNavy,
              fontSize: w < 600 ? 26 : 38,
              fontWeight: FontWeight.w900,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 14),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Text(
              'At Cougar Aviation Academy, we believe the right home is part of your '
                  'success. Ten60 Halifax ensures you have the perfect balance of comfort, '
                  'safety, and convenience while becoming a professional pilot.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _kNavy.withOpacity(0.6),
                fontSize: 15,
                height: 1.7,
              ),
            ),
          ),
          const SizedBox(height: 48),
          // Gallery + features side by side on wide screens
          if (w >= 900)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: _features.map((f) => _FeatureCard(
                      icon: f.icon,
                      title: f.title,
                      points: f.points,
                    )).toList(),
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  flex: 6,
                  child: _GalleryGrid(),
                ),
              ],
            )
          else ...[
            ..._features.map((f) => _FeatureCard(
              icon: f.icon, title: f.title, points: f.points,
            )),
            const SizedBox(height: 32),
            _GalleryGrid(),
          ],
        ],
      ),
    );
  }
}

class _FeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final List<String> points;
  const _FeatureCard({required this.icon, required this.title, required this.points});
  @override State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _hovered ? _kNavy : _kWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered ? _kGold : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _kNavy.withOpacity(_hovered ? 0.15 : 0.06),
              blurRadius: _hovered ? 20 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 46, height: 46,
              decoration: BoxDecoration(
                color: _hovered
                    ? _kGold.withOpacity(0.2)
                    : _kGold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(widget.icon, color: _kGold, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: _hovered ? _kGold : _kNavy,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...widget.points.map((p) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5, right: 6),
                          child: Container(
                            width: 5, height: 5,
                            decoration: BoxDecoration(
                              color: _kGold,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            p,
                            style: TextStyle(
                              color: _hovered
                                  ? _kWhite.withOpacity(0.75)
                                  : _kNavy.withOpacity(0.65),
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
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
// GALLERY GRID
// ─────────────────────────────────────────────────────────────────────────────
class _GalleryGrid extends StatefulWidget {
  @override State<_GalleryGrid> createState() => _GalleryGridState();
}

class _GalleryGridState extends State<_GalleryGrid> {
  int _hoveredIndex = -1;

  static const _images = [
    'https://cougaraviationacademy.com/wp-content/uploads/2025/12/Ten60-Halifax-web-39-300x200.jpg',
    'https://cougaraviationacademy.com/wp-content/uploads/2025/12/Ten60-Halifax-web-38-300x200.jpg',
    'https://cougaraviationacademy.com/wp-content/uploads/2025/12/Ten60-Halifax-web-32-300x200.jpg',
    'https://cougaraviationacademy.com/wp-content/uploads/2025/12/Ten60-Halifax-web-30-300x200.jpg',
    'https://cougaraviationacademy.com/wp-content/uploads/2025/12/Ten60-Halifax-web-29-300x200.jpg',
    'https://cougaraviationacademy.com/wp-content/uploads/2025/12/Ten60-Halifax-web-25-300x200.jpg',
    'https://cougaraviationacademy.com/wp-content/uploads/2025/12/Ten60-Halifax-web-11-300x200.jpg',
    'https://cougaraviationacademy.com/wp-content/uploads/2025/12/Ten60-Halifax-web-10-300x200.jpg',
    'https://cougaraviationacademy.com/wp-content/uploads/2025/12/Ten60-Halifax-web-9-300x200.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1.4,
        ),
        itemCount: _images.length,
        itemBuilder: (_, i) => MouseRegion(
          onEnter: (_) => setState(() => _hoveredIndex = i),
          onExit:  (_) => setState(() => _hoveredIndex = -1),
          child: AnimatedScale(
            scale: _hoveredIndex == i ? 1.03 : 1.0,
            duration: const Duration(milliseconds: 220),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    _images[i],
                    fit: BoxFit.cover,
                    loadingBuilder: (_, child, p) => p == null ? child
                        : Container(color: _kNavy.withOpacity(0.2),
                        child: const Center(child: CircularProgressIndicator(
                            color: _kGold, strokeWidth: 1.5))),
                    errorBuilder: (_, __, ___) => Container(
                      color: _kNavy.withOpacity(0.3),
                      child: const Icon(Icons.image_not_supported, color: _kGold),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: _hoveredIndex == i ? 0.5 : 0,
                    duration: const Duration(milliseconds: 220),
                    child: Container(
                      color: _kNavy,
                      child: const Center(
                        child: Icon(Icons.zoom_in_rounded, color: _kGold, size: 28),
                      ),
                    ),
                  ),
                  // Gold border on hover
                  AnimatedOpacity(
                    opacity: _hoveredIndex == i ? 1 : 0,
                    duration: const Duration(milliseconds: 220),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: _kGold, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PACKAGES SECTION
// ─────────────────────────────────────────────────────────────────────────────
class _PackagesSection extends StatelessWidget {
  static const _packages = [
    (
    icon: Icons.king_bed_rounded,
    title: 'Single Room – Private Bathroom',
    desc: 'Ideal for students who prefer full privacy and comfort during their training.',
    tag: 'Most Popular',
    ),
    (
    icon: Icons.people_rounded,
    title: 'Shared Apartment (2–3 students)',
    desc: 'A cost-effective option for long-term programs (PPL–CPL, 10–12 months).',
    tag: 'Best Value',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return Container(
      color: _kNavy,
      padding: EdgeInsets.symmetric(
        horizontal: w < 600 ? 24 : 80,
        vertical: 80,
      ),
      child: Column(
        children: [
          _GoldLabel('Everything Delivered With Excellence'),
          const SizedBox(height: 12),
          Text(
            'Accommodation Packages',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _kWhite,
              fontSize: w < 600 ? 28 : 40,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Cougar Aviation Academy helps students secure housing before their arrival.',
            textAlign: TextAlign.center,
            style: TextStyle(color: _kWhite.withOpacity(0.65), fontSize: 15, height: 1.6),
          ),
          const SizedBox(height: 48),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: _packages.map((p) => _PackageCard(
              icon: p.icon,
              title: p.title,
              desc: p.desc,
              tag: p.tag,
              width: w < 600 ? w - 48 : (w < 900 ? w - 80 : 320),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class _PackageCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String desc;
  final String tag;
  final double width;
  const _PackageCard({
    required this.icon, required this.title, required this.desc,
    required this.tag, required this.width,
  });
  @override State<_PackageCard> createState() => _PackageCardState();
}

class _PackageCardState extends State<_PackageCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: widget.width,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _hovered
                ? [_kGold.withOpacity(0.15), _kGold.withOpacity(0.05)]
                : [_kWhite.withOpacity(0.06), _kWhite.withOpacity(0.02)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered ? _kGold : _kWhite.withOpacity(0.12),
            width: _hovered ? 1.5 : 1,
          ),
          boxShadow: _hovered
              ? [BoxShadow(
              color: _kGold.withOpacity(0.15),
              blurRadius: 24, offset: const Offset(0, 8))]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    color: _kGold.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _kGold.withOpacity(0.3)),
                  ),
                  child: Icon(widget.icon, color: _kGold, size: 26),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _kGold.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _kGold.withOpacity(0.4)),
                  ),
                  child: Text(
                    widget.tag,
                    style: const TextStyle(
                      color: _kGold, fontSize: 11,
                      fontWeight: FontWeight.w700, letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              widget.title,
              style: const TextStyle(
                color: _kWhite, fontSize: 18,
                fontWeight: FontWeight.w700, height: 1.3,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.desc,
              style: TextStyle(
                color: _kWhite.withOpacity(0.65), fontSize: 14, height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SERVICES SECTION
// ─────────────────────────────────────────────────────────────────────────────
class _ServicesSection extends StatelessWidget {
  static const _services = [
    (icon: Icons.flight_takeoff_rounded, label: 'Airport Pick-up'),
    (icon: Icons.directions_car_rounded, label: 'Transportation'),
    (icon: Icons.map_rounded,             label: 'Orientation'),
    (icon: Icons.handshake_rounded,       label: 'Maintenance'),
    (icon: Icons.access_time_rounded,     label: 'Emergency 24/7'),
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return Container(
      color: _kWhite,
      padding: EdgeInsets.symmetric(
        horizontal: w < 600 ? 24 : 80,
        vertical: 72,
      ),
      child: Column(
        children: [
          _GoldLabel('Everything Delivered With Excellence'),
          const SizedBox(height: 12),
          Text(
            'Included Services',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _kNavy,
              fontSize: w < 600 ? 28 : 40,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Text(
              'Our goal is to ensure you feel at home throughout your aviation journey. '
                  'We offer everything a pilot student needs: comfort, privacy, security, '
                  'and an environment suitable for rest and study.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _kNavy.withOpacity(0.6), fontSize: 15, height: 1.7,
              ),
            ),
          ),
          const SizedBox(height: 48),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: _services.asMap().entries.map((e) =>
                _ServiceChip(
                  icon: e.value.icon,
                  label: e.value.label,
                  index: e.key,
                ),
            ).toList(),
          ),
        ],
      ),
    );
  }
}

class _ServiceChip extends StatefulWidget {
  final IconData icon;
  final String label;
  final int index;
  const _ServiceChip({required this.icon, required this.label, required this.index});
  @override State<_ServiceChip> createState() => _ServiceChipState();
}

class _ServiceChipState extends State<_ServiceChip>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late final AnimationController _ctrl = AnimationController(
    vsync: this, duration: const Duration(milliseconds: 600),
  );

  @override void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100 * widget.index), () {
      if (mounted) _ctrl.forward();
    });
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) => Opacity(
        opacity: _ctrl.value,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - _ctrl.value)),
          child: child,
        ),
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit:  (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: _hovered ? _kNavy : _kLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered ? _kGold : _kNavy.withOpacity(0.08),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _kNavy.withOpacity(_hovered ? 0.12 : 0.04),
                blurRadius: _hovered ? 16 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 56, height: 56,
                decoration: BoxDecoration(
                  color: _hovered ? _kGold.withOpacity(0.15) : _kGold.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.icon,
                    color: _kGold, size: 26),
              ),
              const SizedBox(height: 12),
              Text(
                widget.label,
                style: TextStyle(
                  color: _hovered ? _kWhite : _kNavy,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// VIDEOS SECTION
// ─────────────────────────────────────────────────────────────────────────────


// ─── helper ───────────────────────────────────────────────
Future<void> _openYouTube(String videoId) async {
  // tries YouTube app first, falls back to browser
  final appUri     = Uri.parse('youtube://www.youtube.com/watch?v=$videoId');
  final browserUri = Uri.parse('https://www.youtube.com/watch?v=$videoId');

  if (await canLaunchUrl(appUri)) {
    await launchUrl(appUri);
  } else {
    await launchUrl(browserUri, mode: LaunchMode.externalApplication);
  }
}

Future<void> _openChannel(String channelUrl) async {
  final uri = Uri.parse(channelUrl);
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

// ─── _VideoCard ────────────────────────────────────────────



// ─── _VideoCard ────────────────────────────────────────────
class _VideoCard extends StatefulWidget {
  final String videoId;
  final String title;
  final String channel;
  final String thumb;
  final String channelUrl;

  const _VideoCard({
    required this.videoId,
    required this.title,
    required this.channel,
    required this.thumb,
    required this.channelUrl,
  });

  @override
  State<_VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<_VideoCard> {
  bool _hovered = false;
  bool _playing = false;
  YoutubePlayerController? _controller;

  void _startPlaying() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: false,
      ),
    );
    setState(() => _playing = true);
  }

  Future<void> _openChannel() async {
    final uri = Uri.parse(widget.channelUrl);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _kNavy.withOpacity(_hovered ? 0.18 : 0.08),
              blurRadius: _hovered ? 24 : 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Video / Thumbnail area ──
              AspectRatio(
                aspectRatio: 16 / 9,
                child: _playing && _controller != null
                // ── Playing state: show YouTube player ──
                    ? YoutubePlayer(
                  controller: _controller!,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.red,
                  progressColors: const ProgressBarColors(
                    playedColor: Colors.red,
                    handleColor: Colors.redAccent,
                  ),
                )
                // ── Idle state: show thumbnail + play button ──
                    : Stack(
                  fit: StackFit.expand,
                  children: [
                    // Thumbnail
                    Image.network(
                      widget.thumb,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: _kNavy),
                    ),
                    // Dark overlay
                    AnimatedOpacity(
                      opacity: _hovered ? 0.4 : 0.25,
                      duration: const Duration(milliseconds: 200),
                      child: Container(color: _kNavyDeep),
                    ),
                    // Play button → play inside app
                    Center(
                      child: GestureDetector(
                        onTap: _startPlaying,
                        child: AnimatedScale(
                          scale: _hovered ? 1.1 : 1.0,
                          duration: const Duration(milliseconds: 220),
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.red.shade600,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.4),
                                  blurRadius: 16,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              color: _kWhite,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // YouTube badge → open channel
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: _openChannel,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.play_circle_fill,
                                  color: Colors.red, size: 14),
                              SizedBox(width: 4),
                              Text(
                                'YouTube',
                                style: TextStyle(
                                  color: _kWhite,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Info ──
              Container(
                width: double.infinity,
                color: _kNavy,
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _kWhite,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.channel,
                      style: TextStyle(
                        color: _kGold.withOpacity(0.8),
                        fontSize: 11,
                      ),
                    ),
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

// ─── _VideosSection ────────────────────────────────────────
class _VideosSection extends StatelessWidget {
  static const _videos = [
    (
    id: '2TAlvjalfDo',
    title: "Ten60 Halifax | Daytona Beach's Newest Off-Campus",
    channel: 'Ten60 Halifax Apartments',
    thumb: 'https://img.youtube.com/vi/2TAlvjalfDo/hqdefault.jpg',
    channelUrl: 'https://www.youtube.com/@Ten60HalifaxApartments',
    ),
    (
    id: 'rferHIFda7Y',
    title: 'TEN60 Halifax | Where Modern Living Begins Now',
    channel: 'Ten60 Halifax Apartments',
    thumb: 'https://img.youtube.com/vi/rferHIFda7Y/hqdefault.jpg',
    channelUrl: 'https://www.youtube.com/@Ten60HalifaxApartments',
    ),
    (
    id: 'y2UwiCXt_dk',
    title: "What's happening with these Halifax apartments",
    channel: 'CBC News Nova Scotia',
    thumb: 'https://img.youtube.com/vi/y2UwiCXt_dk/hqdefault.jpg',
    channelUrl: 'https://www.youtube.com/@CBCNewsNovaScotia',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return Container(
      color: _kLight,
      padding: EdgeInsets.symmetric(
        horizontal: w < 600 ? 20 : 60,
        vertical: 72,
      ),
      child: Column(
        children: [
          _GoldLabel('See It For Yourself'),
          const SizedBox(height: 12),
          Text(
            'Experience Ten60 Halifax',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _kNavy,
              fontSize: w < 600 ? 28 : 38,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 40),
          LayoutBuilder(builder: (_, constraints) {
            if (constraints.maxWidth >= 800) {
              return Row(
                children: _videos
                    .map((v) => Expanded(
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8),
                    child: _VideoCard(
                      videoId: v.id,
                      title: v.title,
                      channel: v.channel,
                      thumb: v.thumb,
                      channelUrl: v.channelUrl,
                    ),
                  ),
                ))
                    .toList(),
              );
            }
            return Column(
              children: _videos
                  .map((v) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _VideoCard(
                  videoId: v.id,
                  title: v.title,
                  channel: v.channel,
                  thumb: v.thumb,
                  channelUrl: v.channelUrl,
                ),
              ))
                  .toList(),
            );
          }),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PRICE SECTION
// ─────────────────────────────────────────────────────────────────────────────
class _PriceSection extends StatelessWidget {
  final AnimationController shimmerCtrl;
  const _PriceSection({required this.shimmerCtrl});

  @override
  Widget build(BuildContext context) {
    return Container(
     margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: _kWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _kGold.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: _kGold.withOpacity(0.15),
            blurRadius: 32, offset: const Offset(0, 8),
          ),
        ],
      ),

      padding: const EdgeInsets.symmetric(vertical: 56),
      alignment: Alignment.center,
      child: AnimatedBuilder(
        animation: shimmerCtrl,
        builder: (_, child) {
          return ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              begin: Alignment(-2 + shimmerCtrl.value * 4, 0),
              end: Alignment(-1 + shimmerCtrl.value * 4, 0),
              colors: [_kGold, _kGoldLight, _kGold],
            ).createShader(bounds),
            child: child,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 36),
          decoration: BoxDecoration(
            color: Colors.cyan.shade200,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: _kGold.withOpacity(0.4), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: _kGold.withOpacity(0.15),
                blurRadius: 32, offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50, height: 50,
                decoration: BoxDecoration(
                  color: _kGold.withOpacity(0.12),
                  shape: BoxShape.circle,
                  border: Border.all(color: _kGold.withOpacity(0.3)),
                ),
                child: const Icon(Icons.attach_money_rounded, color: _kWhite, size: 32),
              ),
              const SizedBox(height: 16),
              const Text(
                'Price',
                style: TextStyle(
                  color: _kWhite, fontSize: 18,
                  fontWeight: FontWeight.w700, letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '\$1,000',
                style: TextStyle(
                  color: _kNavy, fontSize: 48,
                  fontWeight: FontWeight.w900, height: 1,
                ),
              ),
              const Text(
                'per course',
                style: TextStyle(
                  color: _kWhite, fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HOW TO BOOK SECTION
// ─────────────────────────────────────────────────────────────────────────────
class _BookingSection extends StatelessWidget {
  static const _steps = [
    (icon: Icons.flight_rounded,       title: 'Choose Your Program',      desc: 'Choose and apply for a suitable aviation training program.'),
    (icon: Icons.check_circle_rounded, title: 'Request Accommodation',     desc: 'Request accommodation during your admission process.'),
    (icon: Icons.shield_rounded,       title: 'Room Secured By Our Team',  desc: 'Our team will secure your room here or at an equivalent student residence.'),
    (icon: Icons.handshake_rounded,    title: 'Receive Confirmation',      desc: 'Receive your booking confirmation before arrival.'),
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return Container(
      color: _kLight,
      padding: EdgeInsets.symmetric(
        horizontal: w < 600 ? 24 : 80,
        vertical: 80,
      ),
      child: Column(
        children: [
          _GoldLabel('Booking Is Easy'),
          const SizedBox(height: 12),
          Text(
            'How to Book Your Accommodation',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _kNavy,
              fontSize: w < 600 ? 26 : 38,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Spaces are limited, especially during peak training months. Early booking is recommended.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _kNavy.withOpacity(0.55),
              fontSize: 14, fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 56),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
              children: _steps.asMap().entries.map((e) =>
                  _BookingStep(
                    icon: e.value.icon,
                    title: e.value.title,
                    desc: e.value.desc,
                    stepNumber: e.key + 1,
                    isLast: e.key == _steps.length - 1,
                  ),
              ).toList(),
            ),
          ),
          const SizedBox(height: 48),
          _GoldButton(
            label: 'Book Your Program Now',
            icon: Icons.arrow_forward_rounded,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CoursesPage()));
            },
          ),
        ],
      ),
    );
  }
}

class _BookingStep extends StatefulWidget {
  final IconData icon;
  final String title;
  final String desc;
  final int stepNumber;
  final bool isLast;
  const _BookingStep({
    required this.icon, required this.title, required this.desc,
    required this.stepNumber, required this.isLast,
  });
  @override State<_BookingStep> createState() => _BookingStepState();
}

class _BookingStepState extends State<_BookingStep>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late final AnimationController _ctrl = AnimationController(
    vsync: this, duration: const Duration(milliseconds: 500),
  );

  @override void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 120 * widget.stepNumber), () {
      if (mounted) _ctrl.forward();
    });
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) => Opacity(
        opacity: _ctrl.value,
        child: Transform.translate(
          offset: Offset(-20 * (1 - _ctrl.value), 0),
          child: child,
        ),
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit:  (_) => setState(() => _hovered = false),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: Icon + line
            Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    color: _hovered ? _kNavy : _kGold.withOpacity(0.12),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _kGold.withOpacity(_hovered ? 1 : 0.4),
                      width: 1.5,
                    ),
                    boxShadow: _hovered
                        ? [BoxShadow(
                        color: _kGold.withOpacity(0.2),
                        blurRadius: 14)]
                        : [],
                  ),
                  child: Icon(widget.icon, color: _kGold, size: 24),
                ),
                if (!widget.isLast)
                  Container(
                    width: 1.5,
                    height: 48,
                    color: _kGold.withOpacity(0.25),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
              ],
            ),
            const SizedBox(width: 20),
            // Right: Text
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 12,
                  bottom: widget.isLast ? 0 : 48,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '0${widget.stepNumber}',
                          style: TextStyle(
                            color: _kGold.withOpacity(0.5),
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                              color: _kNavy, fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.desc,
                      style: TextStyle(
                        color: _kNavy.withOpacity(0.6),
                        fontSize: 14, height: 1.6,
                      ),
                    ),
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

// ─────────────────────────────────────────────────────────────────────────────
// FOOTER CTA
// ─────────────────────────────────────────────────────────────────────────────
class _FooterCTA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://cougaraviationacademy.com/wp-content/uploads/2025/12/Ten60-Halifax-web-5.jpg',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _kNavyDeep.withOpacity(0.82),
              _kNavy.withOpacity(0.95),
            ],
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: w < 600 ? 24 : 80,
          vertical: 80,
        ),
        child: Column(
          children: [
            Text(
              'Choose Cougar. Choose Excellence.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _kWhite,
                fontSize: w < 600 ? 26 : 36,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Step into an academy where standards, discipline, and professionalism define your future.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _kWhite.withOpacity(0.7),
                fontSize: 15, height: 1.7,
              ),
            ),
            const SizedBox(height: 36),
            _GoldButton(
              label: 'Get Started Today',
              icon: Icons.rocket_launch_rounded,
              onTap: () {},
            ),
            const SizedBox(height: 48),
            _GoldDivider(),
            const SizedBox(height: 24),
            Text(
              'Copyright © 2026 Cougar Aviation Academy. All rights reserved.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _kWhite.withOpacity(0.35),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED WIDGETS
// ─────────────────────────────────────────────────────────────────────────────
class _GoldLabel extends StatelessWidget {
  final String text;
  const _GoldLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(
    text,
    textAlign: TextAlign.center,
    style: const TextStyle(
      color: _kGold,
      fontSize: 12,
      fontWeight: FontWeight.w700,
      letterSpacing: 2,
    ),
  );
}

class _GoldDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      width: 60, height: 2,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [_kGold, _kGoldLight, _kGold]),
        borderRadius: BorderRadius.circular(2),
      ),
    ),
  );
}

class _GoldButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _GoldButton({required this.label, required this.icon, required this.onTap});
  @override State<_GoldButton> createState() => _GoldButtonState();
}

class _GoldButtonState extends State<_GoldButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
          decoration: BoxDecoration(
            color: _hovered ? Colors.transparent : _kGold,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: _kGold, width: 2),
            boxShadow: _hovered
                ? []
                : [BoxShadow(
                color: _kGold.withOpacity(0.35),
                blurRadius: 20, offset: const Offset(0, 6))],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  color: _hovered ? _kGold : _kNavy,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(width: 10),
              AnimatedSlide(
                offset: _hovered ? const Offset(0.15, 0) : Offset.zero,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  widget.icon,
                  color: _hovered ? _kGold : _kNavy,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}