// ════════════════════════════════════════════════════════════════
//  contact_page.dart  –  Cougar Aviation Academy
// ════════════════════════════════════════════════════════════════
//
//  pubspec.yaml — add:
//    google_maps_flutter: ^2.9.0
//    url_launcher: ^6.2.0
//
//  Android — AndroidManifest.xml inside <application>:
//    <meta-data android:name="com.google.android.geo.API_KEY"
//               android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
//
//  iOS — AppDelegate.swift:
//    GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
// ════════════════════════════════════════════════════════════════

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

// ─── Brand Colors ─────────────────────────────────────────────
class _C {
  static const navy = Color(0xFF081F2F);
  static const navyCard = Color(0xFF0D2D42);
  static const gold = Color(0xFFB68826);
  static const goldLight = Color(0xFFD4A843);
  static const white = Color(0xFFFFFFFF);
  static const whiteDim = Color(0xD9FFFFFF);
  static const lightBg = Color(0xFFF8F6F1);
  static const darkText = Color(0xFF081F2F);
  static const greyText = Color(0xFF555555);
  static const greyMuted = Color(0xFF999999);
  static const inputBg = Color(0xFFFFFFFF);
  static const border = Color(0x33B68826);
  static const success = Color(0xFF2ECC71);
  static const error = Color(0xFFE74C3C);
}

// ─── Country with dial code + emoji flag ──────────────────────
class _Country {
  final String name;
  final String code; // ISO-2
  final String dial;
  final String flag; // emoji

  const _Country(this.name, this.code, this.dial, this.flag);
}

const List<_Country> _countries = [
  _Country('Egypt', 'EG', '+20', '🇪🇬'),
  _Country('United States', 'US', '+1', '🇺🇸'),
  _Country('United Kingdom', 'GB', '+44', '🇬🇧'),
  _Country('Saudi Arabia', 'SA', '+966', '🇸🇦'),
  _Country('UAE', 'AE', '+971', '🇦🇪'),
  _Country('Qatar', 'QA', '+974', '🇶🇦'),
  _Country('Kuwait', 'KW', '+965', '🇰🇼'),
  _Country('Bahrain', 'BH', '+973', '🇧🇭'),
  _Country('Oman', 'OM', '+968', '🇴🇲'),
  _Country('Jordan', 'JO', '+962', '🇯🇴'),
  _Country('Libya', 'LY', '+218', '🇱🇾'),
  _Country('Tunisia', 'TN', '+216', '🇹🇳'),
  _Country('Morocco', 'MA', '+212', '🇲🇦'),
  _Country('Algeria', 'DZ', '+213', '🇩🇿'),
  _Country('Sudan', 'SD', '+249', '🇸🇩'),
  _Country('Iraq', 'IQ', '+964', '🇮🇶'),
  _Country('Syria', 'SY', '+963', '🇸🇾'),
  _Country('Lebanon', 'LB', '+961', '🇱🇧'),
  _Country('Yemen', 'YE', '+967', '🇾🇪'),
  _Country('Palestine', 'PS', '+970', '🇵🇸'),
  _Country('Germany', 'DE', '+49', '🇩🇪'),
  _Country('France', 'FR', '+33', '🇫🇷'),
  _Country('Italy', 'IT', '+39', '🇮🇹'),
  _Country('Spain', 'ES', '+34', '🇪🇸'),
  _Country('Netherlands', 'NL', '+31', '🇳🇱'),
  _Country('Turkey', 'TR', '+90', '🇹🇷'),
  _Country('Pakistan', 'PK', '+92', '🇵🇰'),
  _Country('India', 'IN', '+91', '🇮🇳'),
  _Country('Nigeria', 'NG', '+234', '🇳🇬'),
  _Country('South Africa', 'ZA', '+27', '🇿🇦'),
  _Country('Canada', 'CA', '+1', '🇨🇦'),
  _Country('Australia', 'AU', '+61', '🇦🇺'),
  _Country('China', 'CN', '+86', '🇨🇳'),
  _Country('Japan', 'JP', '+81', '🇯🇵'),
  _Country('Brazil', 'BR', '+55', '🇧🇷'),
  _Country('Russia', 'RU', '+7', '🇷🇺'),
];

// ════════════════════════════════════════════════════════════════
//  SCROLL ANIMATION WRAPPER
// ════════════════════════════════════════════════════════════════
class _ScrollProvider extends InheritedWidget {
  final ScrollController controller;
  const _ScrollProvider({required this.controller, required super.child});
  static _ScrollProvider? of(BuildContext ctx) =>
      ctx.dependOnInheritedWidgetOfExactType<_ScrollProvider>();
  @override
  bool updateShouldNotify(_ScrollProvider old) => false;
}

class _Reveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Offset from;
  const _Reveal({
    required this.child,
    this.delay = Duration.zero,
    this.from = const Offset(0, 0.06),
  });
  @override
  State<_Reveal> createState() => _RevealState();
}

class _RevealState extends State<_Reveal> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  bool _done = false;
  final GlobalKey _key = GlobalKey();
  ScrollController? _sc;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: widget.from,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
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
    if (top < MediaQuery.of(context).size.height * 0.93) {
      _done = true;
      Future.delayed(widget.delay, () {
        if (mounted) _ctrl.forward();
      });
    }
  }

  @override
  void dispose() {
    _sc?.removeListener(_check);
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    key: _key,
    width: double.infinity,
    child: FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    ),
  );
}

// ════════════════════════════════════════════════════════════════
//  CONTACT PAGE
// ════════════════════════════════════════════════════════════════
class ContactPage extends StatefulWidget {
  const ContactPage({super.key});
  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _sc = ScrollController();

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
        backgroundColor: _C.white,
        appBar: _buildAppBar(),
        body: SingleChildScrollView(
          controller: _sc,
          child: const Column(
            children: [
              // ── Hero Band ──
              _HeroBand(),

              // ── Main contact section ──
              _Reveal(
                delay: Duration(milliseconds: 50),
                child: _ContactMainSection(),
              ),

              // ── Google Map ──
              _Reveal(
                from: Offset(0, 0.04),
                delay: Duration(milliseconds: 80),
                child: _MapSection(),
              ),

              // ── Footer band ──
              _Reveal(from: Offset(0, 0.04), child: _FooterBand()),
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
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: _C.white,
          size: 20,
        ),
        onPressed: () => Navigator.maybePop(context),
      ),
      title: const Text(
        'Contact Us',
        style: TextStyle(
          color: _C.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
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
//  HERO BAND
// ════════════════════════════════════════════════════════════════
class _HeroBand extends StatelessWidget {
  const _HeroBand();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: _C.navy,
      padding: const EdgeInsets.fromLTRB(28, 36, 28, 44),
      child: Stack(
        children: [
          // Ghost icon
          Positioned(
            right: -10,
            top: -10,
            child: Icon(
              Icons.send_rounded,
              size: 160,
              color: Colors.white.withOpacity(0.03),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Small pill
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: _C.gold.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'GET IN TOUCH',
                  style: TextStyle(
                    color: _C.gold,
                    fontSize: 10,
                    letterSpacing: 1.8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Seamless Communication,\nGlobal Impact.',
                style: TextStyle(
                  color: _C.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
               //   letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 10),
              Container(width: 48, height: 3, color: _C.gold),
              const SizedBox(height: 14),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    color: _C.whiteDim,
                    fontSize: 14,
                    height: 1.65,
                  ),
                  children: [
                    TextSpan(text: 'At '),
                    TextSpan(
                      text: 'Cougar Aviation Academy',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: _C.white,
                      ),
                    ),
                    TextSpan(
                      text:
                          ", excellence is not by chance — it's by design. "
                          'We are selective in every detail, ensuring our students receive only the best.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  MAIN CONTACT SECTION  –  Left info  |  Right form card
// ════════════════════════════════════════════════════════════════
class _ContactMainSection extends StatelessWidget {
  const _ContactMainSection();

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 720;
    return Container(
      color: _C.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 56),
      child: isWide
          ? const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 45, child: _LeftInfo()),
                SizedBox(width: 36),
                Expanded(flex: 55, child: _FormCard()),
              ],
            )
          : const Column(
              children: [_LeftInfo(), SizedBox(height: 40), _FormCard()],
            ),
    );
  }
}

// ── Left – contact info ──────────────────────────────────────
class _LeftInfo extends StatelessWidget {
  const _LeftInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(
          children: [
            Container(
              width: 4,
              height: 16,
              margin: const EdgeInsets.only(right: 8),
              color: _C.gold,
            ),
            const Text(
              'GET IN TOUCH',
              style: TextStyle(
                color: _C.gold,
                fontSize: 10.5,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Seamless Communication,\nGlobal Impact.',
          style: TextStyle(
            color: _C.darkText,
            fontSize: 26,
            fontWeight: FontWeight.w900,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 10),
        Container(width: 44, height: 3, color: _C.gold),
        const SizedBox(height: 18),
        RichText(
          text: const TextSpan(
            style: TextStyle(color: _C.greyText, fontSize: 14.5, height: 1.7),
            children: [
              TextSpan(text: 'At '),
              TextSpan(
                text: 'Cougar Aviation Academy',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: _C.darkText,
                ),
              ),
              TextSpan(
                text:
                    ", excellence is not by chance — it's by design. "
                    'We are selective in every detail, ensuring our students receive only the best.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 36),

        // Contact cards
        _ContactCard(
          icon: Icons.location_on_rounded,
          title: 'Head Office',
          lines: const ['1991 Industrial Dr, DeLand 32724', 'Florida, USA'],
          onTap: () async {
            final url = Uri.parse(
              'https://maps.google.com/?q=1991+Industrial+Dr+DeLand+FL',
            );
            if (await canLaunchUrl(url)) launchUrl(url);
          },
        ),
        const SizedBox(height: 16),
        _ContactCard(
          icon: Icons.email_rounded,
          title: 'Email Support',
          lines: const ['Info@cougaraviationacademy.com'],
          onTap: () async {
            final url = Uri.parse('mailto:Info@cougaraviationacademy.com');
            if (await canLaunchUrl(url)) launchUrl(url);
          },
        ),
        const SizedBox(height: 16),
        _ContactCard(
          icon: Icons.phone_rounded,
          title: "Let's Talk",
          lines: const ['+201001290196', '+1(386)450-3395'],
          onTap: () async {
            final url = Uri.parse('tel:+201001290196');
            if (await canLaunchUrl(url)) launchUrl(url);
          },
        ),

        const SizedBox(height: 32),

        // Social row
        const Row(
          children: [
            Text(
              'FOLLOW US',
              style: TextStyle(
                color: _C.gold,
                fontSize: 10,
                letterSpacing: 1.4,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 12),
            Expanded(child: Divider(color: Color(0x33B68826))),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SocialBtn(
                icon: const FaIcon(FontAwesomeIcons.facebook),
                label: 'Facebook',
                color: const Color(0xFF1877F2),
                onTap: () {},
              ),

              const SizedBox(width: 12),

              _SocialBtn(
                icon: const FaIcon(FontAwesomeIcons.instagram),
                label: 'Instagram',
                color: const Color(0xFFE1306C),
                onTap: () {},
              ),

              const SizedBox(width: 12),

              _SocialBtn(
                icon: const FaIcon(FontAwesomeIcons.youtube),
                label: 'YouTube',
                color: const Color(0xFFFF0000),
                onTap: () {},
              ),

              const SizedBox(width: 12),

              _SocialBtn(
                icon: const FaIcon(FontAwesomeIcons.xTwitter),
                label: 'Twitter',
                color: const Color(0xFF000000),
                onTap: () {},
              ),

              const SizedBox(width: 12),

              _SocialBtn(
                icon: const Icon(Icons.chat_bubble_rounded),
                label: 'WhatsApp',
                color: const Color(0xFF25D366),
                onTap: () async {
                  final whatsappUri = Uri.parse(
                    'whatsapp://send?phone=13864503395&text=Hello',
                  );

                  final webUri = Uri.parse('https://wa.me/13864503395');

                  if (await canLaunchUrl(whatsappUri)) {
                    await launchUrl(
                      whatsappUri,
                      mode: LaunchMode.externalApplication,
                    );
                  } else {
                    await launchUrl(
                      webUri,
                      mode: LaunchMode.externalApplication,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> lines;
  final VoidCallback onTap;

  const _ContactCard({
    required this.icon,
    required this.title,
    required this.lines,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: _C.lightBg,
          borderRadius: BorderRadius.circular(14),
          border: const Border(left: BorderSide(color: _C.gold, width: 4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Gold icon badge
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _C.gold,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _C.gold.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(icon, color: _C.white, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: _C.gold,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.5,
                    ),
                  ),
                  const SizedBox(height: 3),
                  for (final l in lines)
                    Text(
                      l,
                      style: const TextStyle(
                        color: _C.greyText,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: _C.gold, size: 20),
          ],
        ),
      ),
    );
  }
}

class _SocialBtn extends StatelessWidget {
  final Widget icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _SocialBtn({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: _C.lightBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconTheme(
              data: IconThemeData(
                color: color,
                size: 18,
              ),
              child: icon,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: _C.darkText,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Right – Dark Form Card ───────────────────────────────────
class _FormCard extends StatefulWidget {
  const _FormCard();
  @override
  State<_FormCard> createState() => _FormCardState();
}

class _FormCardState extends State<_FormCard> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtr = TextEditingController();
  final _emailCtr = TextEditingController();
  final _phoneCtr = TextEditingController();
  final _msgCtr = TextEditingController();
  _Country _selected = _countries[0]; // Egypt default
  bool _sending = false;
  bool _sent = false;

  @override
  void dispose() {
    _nameCtr.dispose();
    _emailCtr.dispose();
    _phoneCtr.dispose();
    _msgCtr.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _sending = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _sending = false;
      _sent = true;
    });
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    setState(() {
      _sent = false;
      _nameCtr.clear();
      _emailCtr.clear();
      _phoneCtr.clear();
      _msgCtr.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: _C.navy,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _C.navy.withOpacity(0.35),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card header
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _C.gold.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: _C.gold.withOpacity(0.3)),
                  ),
                  child: const Icon(
                    Icons.send_rounded,
                    color: _C.gold,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 14),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Send us a Message',
                      style: TextStyle(
                        color: _C.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      "We'll get back to you within 24 hours",
                      style: TextStyle(color: _C.whiteDim, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 28),
            Divider(color: Colors.white.withOpacity(0.08), height: 1),
            const SizedBox(height: 28),

            // Name
            _label('Full Name'),
            const SizedBox(height: 8),
            _buildField(
              controller: _nameCtr,
              hint: 'e.g. Ahmed Mohamed',
              icon: Icons.person_outline_rounded,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Please enter your name'
                  : null,
            ),
            const SizedBox(height: 20),

            // Email
            _label('Email Address'),
            const SizedBox(height: 8),
            _buildField(
              controller: _emailCtr,
              hint: 'your@email.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty)
                  return 'Please enter your email';
                if (!v.contains('@') || !v.contains('.'))
                  return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Mobile with country code
            _label('Mobile Number'),
            const SizedBox(height: 8),
            _PhoneField(
              controller: _phoneCtr,
              selected: _selected,
              onCountryChanged: (c) => setState(() => _selected = c),
            ),
            const SizedBox(height: 20),

            // Message
            _label('Your Message'),
            const SizedBox(height: 8),
            _buildTextArea(
              controller: _msgCtr,
              hint: 'Tell us how we can help you...',
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Please write a message'
                  : null,
            ),
            const SizedBox(height: 28),

            // Send button
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: _sent
                  ? _SuccessBanner()
                  : SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _sending ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _C.gold,
                          disabledBackgroundColor: _C.gold.withOpacity(0.6),
                          foregroundColor: _C.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _sending
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.send_rounded, size: 18),
                                  SizedBox(width: 10),
                                  Text(
                                    'Send Message',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      letterSpacing: 0.4,
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
    );
  }

  Widget _label(String text) => Text(
    text,
    style: TextStyle(
      color: Colors.white.withOpacity(0.7),
      fontSize: 12.5,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
    ),
  );

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: _C.darkText, fontSize: 14),
      decoration: _fieldDec(hint, icon),
    );
  }

  Widget _buildTextArea({
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: 5,
      validator: validator,
      style: const TextStyle(color: _C.darkText, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: _C.greyMuted, fontSize: 14),
        filled: true,
        fillColor: _C.inputBg,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _C.gold, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _C.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _C.error, width: 1.5),
        ),
        errorStyle: const TextStyle(color: _C.error, fontSize: 11.5),
      ),
    );
  }

  InputDecoration _fieldDec(String hint, IconData icon) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: _C.greyMuted, fontSize: 14),
    prefixIcon: Icon(icon, color: _C.gold, size: 20),
    filled: true,
    fillColor: _C.inputBg,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _C.gold, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _C.error, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _C.error, width: 1.5),
    ),
    errorStyle: const TextStyle(color: _C.error, fontSize: 11.5),
  );
}

// ─── Success banner ────────────────────────────────────────────
class _SuccessBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: _C.success.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _C.success.withOpacity(0.4)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_rounded, color: _C.success, size: 22),
          SizedBox(width: 10),
          Text(
            'Message sent successfully!',
            style: TextStyle(
              color: _C.success,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Phone field with country code picker ──────────────────────
class _PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final _Country selected;
  final ValueChanged<_Country> onCountryChanged;

  const _PhoneField({
    required this.controller,
    required this.selected,
    required this.onCountryChanged,
  });

  void _openPicker(BuildContext context) {
    final searchCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CountryPickerSheet(
        searchController: searchCtrl,
        selected: selected,
        onSelect: onCountryChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _C.inputBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          // Country code button
          GestureDetector(
            onTap: () => _openPicker(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: Colors.grey.withOpacity(0.2)),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(selected.flag, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 6),
                  Text(
                    selected.dial,
                    style: const TextStyle(
                      color: _C.darkText,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: _C.gold,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),

          // Phone number input
          Flexible(
            child: Padding(
              padding: const EdgeInsetsGeometry.directional(end: 7),
              child: SizedBox(
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(color: _C.white, fontSize: 14),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return 'Please enter your phone number';
                    if (v.length < 7) return 'Number too short';
                    return null;
                  },
                  decoration: const InputDecoration(
                    fillColor: Colors.grey,
                    hintText: 'Phone number',
                    hintStyle: TextStyle(color: _C.greyText, fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    errorStyle: TextStyle(color: _C.error, fontSize: 11.5),
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

// ─── Country Picker Bottom Sheet ───────────────────────────────
class _CountryPickerSheet extends StatefulWidget {
  final TextEditingController searchController;
  final _Country selected;
  final ValueChanged<_Country> onSelect;

  const _CountryPickerSheet({
    required this.searchController,
    required this.selected,
    required this.onSelect,
  });

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  late List<_Country> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = _countries;
    widget.searchController.addListener(_onSearch);
  }

  void _onSearch() {
    final q = widget.searchController.text.toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? _countries
          : _countries
                .where(
                  (c) => c.name.toLowerCase().contains(q) || c.dial.contains(q),
                )
                .toList();
    });
  }

  @override
  void dispose() {
    widget.searchController.removeListener(_onSearch);
    widget.searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: _C.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(Icons.flag_rounded, color: _C.gold, size: 20),
                SizedBox(width: 10),
                Text(
                  'Select Country Code',
                  style: TextStyle(
                    color: _C.darkText,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: widget.searchController,
              autofocus: true,
              style: const TextStyle(color: _C.darkText, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search country or dial code...',
                hintStyle: const TextStyle(color: _C.greyMuted),
                prefixIcon: const Icon(Icons.search, color: _C.gold, size: 20),
                filled: true,
                fillColor: _C.lightBg,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _C.gold, width: 1.5),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Divider(height: 1, color: Colors.grey.shade100),

          // List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 6),
              itemCount: _filtered.length,
              itemBuilder: (_, i) {
                final c = _filtered[i];
                final isSelected = c.code == widget.selected.code;
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      widget.onSelect(c);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 13,
                      ),
                      color: isSelected ? _C.gold.withOpacity(0.06) : null,
                      child: Row(
                        children: [
                          Text(c.flag, style: const TextStyle(fontSize: 22)),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              c.name,
                              style: TextStyle(
                                color: isSelected ? _C.gold : _C.darkText,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? _C.gold.withOpacity(0.15)
                                  : _C.lightBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              c.dial,
                              style: TextStyle(
                                color: isSelected ? _C.gold : _C.greyText,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          if (isSelected) ...[
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.check_circle_rounded,
                              color: _C.gold,
                              size: 18,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  MAP SECTION
// ════════════════════════════════════════════════════════════════
class _MapSection extends StatefulWidget {
  const _MapSection();
  @override
  State<_MapSection> createState() => _MapSectionState();
}

class _MapSectionState extends State<_MapSection> {
  final _completer = Completer<GoogleMapController>();

  static const _kded = LatLng(29.0633216, -81.2876747);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _C.lightBg,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 52),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                margin: const EdgeInsets.only(right: 8),
                color: _C.gold,
              ),
              const Text(
                'FIND US',
                style: TextStyle(
                  color: _C.gold,
                  fontSize: 10.5,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Our Location',
            style: TextStyle(
              color: _C.darkText,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Container(width: 44, height: 3, color: _C.gold),
          const SizedBox(height: 12),
          const Text(
            'Cougar Aviation Academy — DeLand Municipal Airport (KDED)\n'
            '1991 Industrial Dr, DeLand 32724, Florida, USA',
            style: TextStyle(color: _C.greyText, fontSize: 14, height: 1.6),
          ),
          const SizedBox(height: 28),

          // Map container
          Container(
            height: 360,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _C.border, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: _C.gold.withOpacity(0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(19),
              child: Stack(
                children: [
                  GoogleMap(
                    mapType: MapType.satellite,
                    initialCameraPosition: const CameraPosition(
                      target: _kded,
                      zoom: 15,
                    ),
                    onMapCreated: _completer.complete,
                    markers: {
                      const Marker(
                        markerId: MarkerId('academy'),
                        position: _kded,
                        infoWindow: InfoWindow(
                          title: 'Cougar Aviation Academy',
                          snippet: 'DeLand Municipal Airport (KDED)',
                        ),
                        // Default marker is red pin ─ matches request
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

                  // Top info overlay
                  Positioned(
                    top: 14,
                    left: 14,
                    right: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: _C.navy.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _C.gold.withOpacity(0.3)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: _C.gold,
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'DeLand Municipal Airport (KDED) — Cougar Aviation Academy',
                              style: TextStyle(
                                color: _C.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
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

          const SizedBox(height: 24),

          // Quick info chips
          const Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _InfoChip(Icons.access_time_rounded, '24h Response'),
              _InfoChip(Icons.flight_takeoff_rounded, 'Near KDED Airport'),
              _InfoChip(Icons.location_city_rounded, 'DeLand, Florida'),
              _InfoChip(
                Icons.language_rounded,
                'International Students Welcome',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _C.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: _C.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: _C.gold, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: _C.darkText,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  FOOTER BAND
// ════════════════════════════════════════════════════════════════
class _FooterBand extends StatelessWidget {
  const _FooterBand();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _C.navy,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 52),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: _C.gold.withOpacity(0.12),
              shape: BoxShape.circle,
              border: Border.all(color: _C.gold.withOpacity(0.3)),
            ),
            child: const Icon(
              Icons.headset_mic_rounded,
              color: _C.gold,
              size: 28,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'We\'re Here When You Need Us.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _C.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Container(width: 44, height: 3, color: _C.gold),
          const SizedBox(height: 14),
          const Text(
            'Our team is available to answer your questions about pilot training,\n'
            'programs, accommodation, and more.',
            textAlign: TextAlign.center,
            style: TextStyle(color: _C.whiteDim, fontSize: 14, height: 1.7),
          ),
          const SizedBox(height: 28),
          // Two quick-action buttons
          Wrap(
            spacing: 14,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              _FooterAction(
                icon: Icons.phone_rounded,
                label: 'Call Us Now',
                onTap: () async {
                  final url = Uri.parse('tel:+201001290196');
                  if (await canLaunchUrl(url)) launchUrl(url);
                },
              ),
              /*_FooterAction(
                icon: Icons.chat_bubble_rounded,
                label: 'WhatsApp',
                outlined: true,
                onTap: () async {
                  final whatsappUri = Uri.parse(
                    'whatsapp://send?phone=13864503395&text=Hello',
                  );

                  final webUri = Uri.parse('https://wa.me/13864503395');

                  if (await canLaunchUrl(whatsappUri)) {
                    await launchUrl(
                      whatsappUri,
                      mode: LaunchMode.externalApplication,
                    );
                  } else {
                    await launchUrl(
                      webUri,
                      mode: LaunchMode.externalApplication,
                    );
                  }
                },
              ),*/
            ],
          ),
        ],
      ),
    );
  }
}

class _FooterAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool outlined;

  const _FooterAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
        decoration: BoxDecoration(
          color: outlined ? Colors.transparent : _C.gold,
          borderRadius: BorderRadius.circular(30),
          border: outlined ? Border.all(color: _C.gold, width: 1.5) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: _C.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: _C.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
