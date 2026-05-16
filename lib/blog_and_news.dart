import 'package:cougar_app/shared/blog_article.dart';
import 'package:flutter/material.dart';
import 'blog_data.dart';


// ══════════════════════════════════════════════════════════════════════════════
//  BLOG & NEWS SCREEN
// ══════════════════════════════════════════════════════════════════════════════

class BlogAndNewsScreen extends StatelessWidget {
  const BlogAndNewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: kBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [

          // ── Hero SliverAppBar ───────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            elevation: 0,
            backgroundColor: kNavy,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: _HeroBanner(),
            ),
            leading: const SizedBox.shrink(),
          ),

          // ── Section intro ───────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: _FadeInSlide(
              delay: 0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 32, 22, 6),
                child: Column(
                  children: [
                    Text(
                      'INSIGHTS · GUIDANCE · KNOWLEDGE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kGold,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Cougar Aviation Blog',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kNavy,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Expert tips, industry updates, and valuable lessons that support your training journey and help you stay informed as you advance in aviation.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: kBody.withOpacity(0.7), fontSize: 13.5, height: 1.65),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width: 8, height: 3, decoration: BoxDecoration(color: kGold, borderRadius: BorderRadius.circular(2))),
                        const SizedBox(width: 4),
                        Container(width: 40, height: 3, decoration: BoxDecoration(color: kGold, borderRadius: BorderRadius.circular(2))),
                        const SizedBox(width: 4),
                        Container(width: 8, height: 3, decoration: BoxDecoration(color: kGold, borderRadius: BorderRadius.circular(2))),
                      ],
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ),

          // ── Blog Cards ──────────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, i) => _FadeInSlide(
                  delay: 80 + i * 130,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 22),
                    child: _BlogCard(post: blogPosts[i]),
                  ),
                ),
                childCount: blogPosts.length,
              ),
            ),
          ),

          // ── CTA Banner ──────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: _FadeInSlide(
              delay: 500,
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 6, 16, 40),
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0D2B42), Color(0xFF081F2F)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: kNavy.withOpacity(0.35), blurRadius: 24, offset: const Offset(0, 10)),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Choose Cougar.\nChoose Excellence.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800, height: 1.3),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Step into an academy where standards, discipline, and professionalism define your future.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13, height: 1.6),
                    ),
                    const SizedBox(height: 24),
                    _GoldButton(label: 'Get Started', onTap: () {}),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: _C.navy,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
            Icons.arrow_back_ios_new_rounded, color: _C.white, size: 20),
        onPressed: () => Navigator.maybePop(
          context,
          // If we can't pop, it means this is the root of the stack, so we can just do nothing or maybe show a toast.
        )
      ),
      title: const Text(
        'Blogs & News',
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

// ── Hero Banner ─────────────────────────────────────────────────────────────

class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          'https://cougaraviationacademy.com/wp-content/uploads/2026/04/IMG_0665-768x428.jpeg',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(color: kNavy),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [kNavy.withOpacity(0.55), kNavy.withOpacity(0.92)],
            ),
          ),
        ),

      ],
    );
  }
}

// ── Blog Card ────────────────────────────────────────────────────────────────

class _BlogCard extends StatefulWidget {
  const _BlogCard({required this.post});
  final BlogPost post;

  @override
  State<_BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<_BlogCard> with SingleTickerProviderStateMixin {
  bool _pressed = false;
  late AnimationController _scaleCtrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 180));
    _scale = Tween<double>(begin: 1.0, end: 1.016)
        .animate(CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() { _scaleCtrl.dispose(); super.dispose(); }

  void _navigate(BuildContext ctx) {
    Navigator.of(ctx).push(
      PageRouteBuilder(
        pageBuilder: (_, anim, __) => BlogArticleScreen(post: widget.post),
        transitionsBuilder: (_, anim, __, child) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
            child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero)
                  .animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 380),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigate(context),
      onTapDown: (_) { _scaleCtrl.forward(); setState(() => _pressed = true); },
      onTapUp: (_) { _scaleCtrl.reverse(); setState(() => _pressed = false); },
      onTapCancel: () { _scaleCtrl.reverse(); setState(() => _pressed = false); },
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: kCard,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_pressed ? 0.13 : 0.07),
                blurRadius: _pressed ? 22 : 14,
                offset: Offset(0, _pressed ? 9 : 4),
              ),
            ],
          ),
          clipBehavior: Clip.hardEdge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Thumbnail ──
              _CardThumbnail(post: widget.post),

              // ── Content ──
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Meta row
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, size: 11, color: kMuted),
                        const SizedBox(width: 4),
                        Text(widget.post.date, style: const TextStyle(color: kMuted, fontSize: 11)),
                        const SizedBox(width: 14),
                        const Icon(Icons.access_time_rounded, size: 11, color: kMuted),
                        const SizedBox(width: 4),
                        Text(widget.post.readTime, style: const TextStyle(color: kMuted, fontSize: 11)),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Title
                    Text(
                      widget.post.title,
                      style: const TextStyle(color: kNavy, fontSize: 16, fontWeight: FontWeight.w700, height: 1.4),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),

                    // Excerpt
                    Text(
                      widget.post.excerpt,
                      style: TextStyle(color: kBody.withOpacity(0.7), fontSize: 13, height: 1.6),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 18),

                    // Read More row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'READ MORE',
                              style: TextStyle(color: kGold, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.2),
                            ),
                            const SizedBox(width: 6),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              transform: Matrix4.translationValues(_pressed ? 6 : 0, 0, 0),
                              child: const Icon(Icons.arrow_forward_rounded, color: kGold, size: 16),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: kGold.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.post.category,
                            style: const TextStyle(color: kGold, fontSize: 10, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Gold accent line
              Container(
                height: 3,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [kGold, kGold2]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Card Thumbnail ───────────────────────────────────────────────────────────

class _CardThumbnail extends StatelessWidget {
  const _CardThumbnail({required this.post});
  final BlogPost post;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 7.5,
      child: Stack(fit: StackFit.expand, children: [
        Image.network(
          post.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: kNavy.withOpacity(0.12),
            child: const Center(child: Icon(Icons.flight_takeoff_rounded, size: 44, color: kGold)),
          ),
        ),
        Positioned(
          bottom: 0, left: 0, right: 0,
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.5), Colors.transparent],
              ),
            ),
          ),
        ),
        Positioned(
          top: 12, right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: kNavy.withOpacity(0.82),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kGold.withOpacity(0.45), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.local_airport_rounded, size: 11, color: kGold),
                const SizedBox(width: 4),
                Text(post.category,
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

// ── Gold Button ──────────────────────────────────────────────────────────────

class _GoldButton extends StatelessWidget {
  const _GoldButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [kGold, kGold2]),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: kGold.withOpacity(0.38), blurRadius: 14, offset: const Offset(0, 6))],
        ),
        child: Text(label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, letterSpacing: 0.8, fontSize: 14)),
      ),
    );
  }
}

// ── Fade + Slide entrance animation ─────────────────────────────────────────

class _FadeInSlide extends StatefulWidget {
  const _FadeInSlide({required this.child, required this.delay});
  final Widget child;
  final int delay;

  @override
  State<_FadeInSlide> createState() => _FadeInSlideState();
}

class _FadeInSlideState extends State<_FadeInSlide> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _opacity = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.14), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    Future.delayed(Duration(milliseconds: widget.delay), () { if (mounted) _ctrl.forward(); });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _opacity,
    child: SlideTransition(position: _slide, child: widget.child),
  );
}