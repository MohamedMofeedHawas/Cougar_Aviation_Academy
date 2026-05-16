import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../blog_data.dart';


// ══════════════════════════════════════════════════════════════════════════════
//  ARTICLE DETAIL SCREEN
// ══════════════════════════════════════════════════════════════════════════════

class BlogArticleScreen extends StatefulWidget {
  const BlogArticleScreen({super.key, required this.post});
  final BlogPost post;

  @override
  State<BlogArticleScreen> createState() => _BlogArticleScreenState();
}

class _BlogArticleScreenState extends State<BlogArticleScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollCtrl = ScrollController();
  double _scrollProgress = 0;
  late AnimationController _heroCtrl;
  late Animation<double> _heroFade;
  late Animation<Offset> _heroSlide;

  @override
  void initState() {
    super.initState();
    // hero entrance
    _heroCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _heroFade = CurvedAnimation(parent: _heroCtrl, curve: Curves.easeOut);
    _heroSlide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _heroCtrl, curve: Curves.easeOut));
    _heroCtrl.forward();

    // progress bar
    _scrollCtrl.addListener(() {
      if (!_scrollCtrl.hasClients) return;
      final max = _scrollCtrl.position.maxScrollExtent;
      if (max <= 0) return;
      setState(() => _scrollProgress = (_scrollCtrl.offset / max).clamp(0, 1));
    });
  }

  @override
  void dispose() {
    _heroCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: kBg,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollCtrl,
            physics: const BouncingScrollPhysics(),
            slivers: [

              // ── Collapsing Hero ───────────────────────────────────────────
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                backgroundColor: kNavy,
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.all(8),
                  child: _CircleBack(),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: _ArticleHero(post: widget.post),
                  title: AnimatedOpacity(
                    opacity: _scrollProgress > 0.08 ? 1 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      widget.post.category,
                      style: TextStyle(
                        color: kGold,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  centerTitle: true,
                ),
              ),

              // ── Category + Meta pill ──────────────────────────────────────
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _heroFade,
                  child: SlideTransition(
                    position: _heroSlide,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                      child: Row(
                        children: [
                          _Pill(
                            icon: Icons.local_airport_rounded,
                            label: widget.post.category,
                            color: kGold,
                          ),
                          const SizedBox(width: 8),
                          _Pill(
                            icon: Icons.access_time_rounded,
                            label: widget.post.readTime,
                            color: kNavy,
                          ),
                          const SizedBox(width: 8),
                          _Pill(
                            icon: Icons.calendar_today_rounded,
                            label: widget.post.date,
                            color: kNavy,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ── Article Title ─────────────────────────────────────────────
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _heroFade,
                  child: SlideTransition(
                    position: _heroSlide,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Text(
                        widget.post.title,
                        style: const TextStyle(
                          color: kNavy,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Divider ───────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(children: [
                    Container(width: 40, height: 3, decoration: BoxDecoration(gradient: const LinearGradient(colors: [kGold, kGold2]), borderRadius: BorderRadius.circular(2))),
                    const SizedBox(width: 6),
                    Container(width: 10, height: 3, decoration: BoxDecoration(color: kGold.withOpacity(0.3), borderRadius: BorderRadius.circular(2))),
                  ]),
                ),
              ),

              // ── Content Sections ──────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, i) => _ArticleSection(
                      section: widget.post.sections[i],
                      index: i,
                    ),
                    childCount: widget.post.sections.length,
                  ),
                ),
              ),

              // ── Author / Academy Card ─────────────────────────────────────
              SliverToBoxAdapter(
                child: _ScrollFadeIn(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(20, 28, 20, 10),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF0D2B42), kNavy],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: kNavy.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8)),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: kGold, width: 2),
                            color: kGold.withOpacity(0.1),
                          ),
                          child: const Icon(Icons.flight_takeoff_rounded, color: kGold, size: 26),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Cougar Aviation Academy',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                              const SizedBox(height: 3),
                              Text('Florida – USA  •  cougaraviationacademy.com',
                                  style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 11)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Related posts header ──────────────────────────────────────
              SliverToBoxAdapter(
                child: _ScrollFadeIn(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
                    child: Row(
                      children: [
                        Container(width: 4, height: 20, decoration: BoxDecoration(gradient: const LinearGradient(colors: [kGold, kGold2], begin: Alignment.topCenter, end: Alignment.bottomCenter), borderRadius: BorderRadius.circular(2))),
                        const SizedBox(width: 10),
                        const Text('More Articles', style: TextStyle(color: kNavy, fontSize: 17, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Related cards ─────────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, i) {
                      final related = blogPosts.where((p) => p.id != widget.post.id).toList();
                      if (i >= related.length) return null;
                      return _ScrollFadeIn(
                        child: _RelatedCard(
                          post: related[i],
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              PageRouteBuilder(
                                pageBuilder: (_, anim, __) => BlogArticleScreen(post: related[i]),
                                transitionsBuilder: (_, anim, __, child) => FadeTransition(
                                  opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
                                  child: child,
                                ),
                                transitionDuration: const Duration(milliseconds: 300),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    childCount: blogPosts.where((p) => p.id != widget.post.id).length,
                  ),
                ),
              ),
            ],
          ),

          // ── Reading progress bar ──────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 3,
              child: LinearProgressIndicator(
                value: _scrollProgress,
                backgroundColor: Colors.transparent,
                valueColor: const AlwaysStoppedAnimation<Color>(kGold),
                minHeight: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Article Hero ─────────────────────────────────────────────────────────────

class _ArticleHero extends StatelessWidget {
  const _ArticleHero({required this.post});
  final BlogPost post;

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: [
      Image.network(
        post.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(color: kNavy),
      ),
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kNavy.withOpacity(0.3), kNavy.withOpacity(0.88)],
          ),
        ),
      ),
      Positioned(
        bottom: 24, left: 20, right: 20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: kGold,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(post.category,
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
            ),
          ],
        ),
      ),
    ]);
  }
}

// ── Circle back button ───────────────────────────────────────────────────────

class _CircleBack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
      ),
    );
  }
}

// ── Pill badge ───────────────────────────────────────────────────────────────

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.label, required this.color});
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.09),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ── Article Section ──────────────────────────────────────────────────────────

class _ArticleSection extends StatelessWidget {
  const _ArticleSection({required this.section, required this.index});
  final BlogSection section;
  final int index;

  @override
  Widget build(BuildContext context) {
    return _ScrollFadeIn(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 22),
        child: section.isCallout
            ? _CalloutBox(section: section)
            : _NormalSection(section: section),
      ),
    );
  }
}

class _NormalSection extends StatelessWidget {
  const _NormalSection({required this.section});
  final BlogSection section;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (section.heading != null) ...[
          Text(
            section.heading!,
            style: const TextStyle(
              color: kNavy,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),
        ],
        Text(
          section.body,
          style: TextStyle(
            color: kBody.withOpacity(0.82),
            fontSize: 14,
            height: 1.75,
          ),
        ),
      ],
    );
  }
}

class _CalloutBox extends StatelessWidget {
  const _CalloutBox({required this.section});
  final BlogSection section;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [kNavy.withOpacity(0.06), kGold.withOpacity(0.06)],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kGold.withOpacity(0.35), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (section.heading != null) ...[
            Row(
              children: [
                Container(width: 4, height: 18,
                    decoration: BoxDecoration(gradient: const LinearGradient(colors: [kGold, kGold2], begin: Alignment.topCenter, end: Alignment.bottomCenter), borderRadius: BorderRadius.circular(2))),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    section.heading!,
                    style: const TextStyle(color: kNavy, fontSize: 15, fontWeight: FontWeight.w700, height: 1.3),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          Text(
            section.body,
            style: TextStyle(color: kBody.withOpacity(0.88), fontSize: 14, height: 1.75),
          ),
        ],
      ),
    );
  }
}

// ── Related Card ─────────────────────────────────────────────────────────────

class _RelatedCard extends StatefulWidget {
  const _RelatedCard({required this.post, required this.onTap});
  final BlogPost post;
  final VoidCallback onTap;

  @override
  State<_RelatedCard> createState() => _RelatedCardState();
}

class _RelatedCardState extends State<_RelatedCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 14),
        transform: Matrix4.identity()..scale(_pressed ? 0.985 : 1.0),
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 3)),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Row(
          children: [
            // Thumbnail
            SizedBox(
              width: 100,
              height: 80,
              child: Image.network(
                widget.post.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: kNavy.withOpacity(0.1),
                  child: const Icon(Icons.flight_rounded, color: kGold, size: 28),
                ),
              ),
            ),
            // Text
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.category,
                      style: const TextStyle(color: kGold, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.8),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.post.title,
                      style: const TextStyle(color: kNavy, fontSize: 13, fontWeight: FontWeight.w600, height: 1.3),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(widget.post.readTime,
                            style: const TextStyle(color: kMuted, fontSize: 10)),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_rounded, color: kGold, size: 14),
                      ],
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

// ── Scroll-triggered fade-in ─────────────────────────────────────────────────

class _ScrollFadeIn extends StatefulWidget {
  const _ScrollFadeIn({required this.child});
  final Widget child;

  @override
  State<_ScrollFadeIn> createState() => _ScrollFadeInState();
}

class _ScrollFadeInState extends State<_ScrollFadeIn> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _opacity = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    // small stagger relative to widget birth
    Future.microtask(() {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _opacity,
    child: SlideTransition(position: _slide, child: widget.child),
  );
}