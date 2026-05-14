// lib/features/courses/presentation/widgets/booking_form.dart

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import 'country_Code_picker.dart';

class BookingForm extends StatefulWidget {
  final String courseName;

  const BookingForm({super.key, required this.courseName});

  @override
  State<BookingForm> createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _countryCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();

  CountryCode _selectedCode = countryCodes.firstWhere(
        (c) => c.code == 'EG',
    orElse: () => countryCodes.first,
  );

  bool _isSubmitting = false;
  bool _submitted = false;

  late AnimationController _successAnim;
  late Animation<double> _successScale;

  @override
  void initState() {
    super.initState();
    _successAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _successScale = CurvedAnimation(
      parent: _successAnim,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _countryCtrl.dispose();
    _messageCtrl.dispose();
    _successAnim.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() {
        _isSubmitting = false;
        _submitted = true;
      });
      _successAnim.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Decorative background pattern
          Positioned(
            right: -40,
            top: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            left: -20,
            bottom: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withOpacity(0.04),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(AppSpacing.xl),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: _submitted
                  ? _SuccessView(
                scaleAnim: _successScale,
                courseName: widget.courseName,
              )
                  : _FormView(
                formKey: _formKey,
                nameCtrl: _nameCtrl,
                emailCtrl: _emailCtrl,
                phoneCtrl: _phoneCtrl,
                countryCtrl: _countryCtrl,
                messageCtrl: _messageCtrl,
                selectedCode: _selectedCode,
                onCodeChanged: (c) =>
                    setState(() => _selectedCode = c),
                isSubmitting: _isSubmitting,
                onSubmit: _submit,
                courseName: widget.courseName,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormView extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController countryCtrl;
  final TextEditingController messageCtrl;
  final CountryCode selectedCode;
  final ValueChanged<CountryCode> onCodeChanged;
  final bool isSubmitting;
  final VoidCallback onSubmit;
  final String courseName;

  const _FormView({
    required this.formKey,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.phoneCtrl,
    required this.countryCtrl,
    required this.messageCtrl,
    required this.selectedCode,
    required this.onCodeChanged,
    required this.isSubmitting,
    required this.onSubmit,
    required this.courseName,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
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
             /* Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.flight_takeoff_rounded,
                  color: AppColors.accent,
                  size: 22,
                ),
              ),*/
              AppSpacing.horizontalMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Start Your Pilot Training Journey',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                    //    letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Book Your FAA Training',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.verticalMd,
          Text(
            'Complete the form below and our admissions team will contact you to discuss program availability, training timelines, and visa guidance.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.65),
              fontSize: 13,
              height: 1.5,
            ),
          ),
          AppSpacing.verticalLg,

          // Name
          _BookingField(
            controller: nameCtrl,
            label: 'Full Name',
            icon: Icons.person_outline_rounded,
            validator: (v) =>
            (v == null || v.trim().isEmpty) ? 'Please enter your name' : null,
          ),
          AppSpacing.verticalMd,

          // Email
          _BookingField(
            controller: emailCtrl,
            label: 'Email Address',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Please enter your email';
              if (!v.contains('@')) return 'Please enter a valid email';
              return null;
            },
          ),
          AppSpacing.verticalMd,

          // Phone with country code
          _PhoneField(
            controller: phoneCtrl,
            selectedCode: selectedCode,
            onCodeChanged: onCodeChanged,
          ),
          AppSpacing.verticalMd,

          // Country
          _BookingField(
            controller: countryCtrl,
            label: 'Country',
            icon: Icons.public_outlined,
            validator: (v) =>
            (v == null || v.trim().isEmpty) ? 'Please enter your country' : null,
          ),
          AppSpacing.verticalMd,

          // Message
          _BookingField(
            controller: messageCtrl,
            label: 'Message (Optional)',
            icon: Icons.message_outlined,
            maxLines: 4,
            validator: null,
          ),
          AppSpacing.verticalLg,

          // Submit Button
          SizedBox(
        //    width: 300,
            height: 54,
            child: ElevatedButton(
              onPressed: isSubmitting ? null : onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.accent.withOpacity(0.6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: isSubmitting
                    ? const SizedBox(
                  key: ValueKey('loading'),
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : Row(
                      mainAxisSize: MainAxisSize.min,
                                      key: const ValueKey('text'),
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                    Icon(Icons.send_rounded, size: 18),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Send Enrollment Request',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                       //   letterSpacing: 0.3,
                        ),
                      ),
                    ),
                                      ],
                                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;

  const _BookingField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 13),
        prefixIcon: Icon(icon, color: AppColors.accent.withOpacity(0.8), size: 20),
        filled: true,
        fillColor: Colors.white.withOpacity(0.07),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade400),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
        ),
        errorStyle: const TextStyle(color: Colors.redAccent),
      ),
    );
  }
}

class _PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final CountryCode selectedCode;
  final ValueChanged<CountryCode> onCodeChanged;

  const _PhoneField({
    required this.controller,
    required this.selectedCode,
    required this.onCodeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mobile Number',
          style: TextStyle(
            color: Colors.white.withOpacity(0.55),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Country code picker button
            _CountryCodeButton(
              selected: selectedCode,
              onTap: () => _openPicker(context),
            ),
            const SizedBox(width: 10),
            // Phone input
            Expanded(
              child: TextFormField(
                controller: controller,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Please enter your mobile number'
                    : null,
                decoration: InputDecoration(
                  hintText: 'Phone number',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.35),
                    fontSize: 13,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.07),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                    BorderSide(color: Colors.white.withOpacity(0.12)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                    const BorderSide(color: AppColors.accent, width: 1.5),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red.shade400),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                    BorderSide(color: Colors.red.shade400, width: 1.5),
                  ),
                  errorStyle: const TextStyle(color: Colors.redAccent),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _openPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CountryPickerSheetDark(
        selected: selectedCode,
        onSelect: onCodeChanged,
      ),
    );
  }
}

class _CountryCodeButton extends StatefulWidget {
  final CountryCode selected;
  final VoidCallback onTap;

  const _CountryCodeButton({required this.selected, required this.onTap});

  @override
  State<_CountryCodeButton> createState() => _CountryCodeButtonState();
}

class _CountryCodeButtonState extends State<_CountryCodeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_CountryCodeButton old) {
    super.didUpdateWidget(old);
    if (old.selected.code != widget.selected.code) {
      _ctrl.forward().then((_) => _ctrl.reverse());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.07),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.selected.flag, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 6),
              Text(
                widget.selected.dialCode,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.expand_more_rounded,
                color: Colors.white.withOpacity(0.6),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountryPickerSheetDark extends StatefulWidget {
  final CountryCode selected;
  final ValueChanged<CountryCode> onSelect;

  const _CountryPickerSheetDark({
    required this.selected,
    required this.onSelect,
  });

  @override
  State<_CountryPickerSheetDark> createState() =>
      _CountryPickerSheetDarkState();
}

class _CountryPickerSheetDarkState extends State<_CountryPickerSheetDark>
    with SingleTickerProviderStateMixin {
  late AnimationController _sheetAnim;
  late Animation<Offset> _slideAnim;
  List<CountryCode> _filtered = countryCodes;

  @override
  void initState() {
    super.initState();
    _sheetAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _sheetAnim, curve: Curves.easeOutCubic));
    _sheetAnim.forward();
  }

  @override
  void dispose() {
    _sheetAnim.dispose();
    super.dispose();
  }

  void _filter(String q) {
    setState(() {
      _filtered = q.isEmpty
          ? countryCodes
          : countryCodes
          .where((c) =>
      c.name.toLowerCase().contains(q.toLowerCase()) ||
          c.dialCode.contains(q))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnim,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.78,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Country Code',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    onChanged: _filter,
                    autofocus: true,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Search country or dial code...',
                      hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.4), fontSize: 13),
                      prefixIcon: Icon(Icons.search,
                          color: Colors.white.withOpacity(0.5), size: 20),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.08),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: Colors.white.withOpacity(0.08)),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _filtered.length,
                itemBuilder: (context, i) {
                  final item = _filtered[i];
                  final isSel = item.code == widget.selected.code;
                  return InkWell(
                    onTap: () {
                      widget.onSelect(item);
                      Navigator.of(context).pop();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      color: isSel
                          ? AppColors.accent.withOpacity(0.12)
                          : Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      child: Row(
                        children: [
                          Text(item.flag, style: const TextStyle(fontSize: 22)),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              item.name,
                              style: TextStyle(
                                color: isSel
                                    ? AppColors.accent
                                    : Colors.white.withOpacity(0.85),
                                fontWeight: isSel
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Text(
                            item.dialCode,
                            style: TextStyle(
                              color: isSel
                                  ? AppColors.accent
                                  : Colors.white.withOpacity(0.4),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (isSel) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.check_circle_rounded,
                                color: AppColors.accent, size: 18),
                          ],
                        ],
                      ),
                    ),
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

class _SuccessView extends StatelessWidget {
  final Animation<double> scaleAnim;
  final String courseName;

  const _SuccessView({required this.scaleAnim, required this.courseName});

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnim,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: AppColors.accent,
                size: 44,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Request Sent!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Thank you for your interest in $courseName.\nOur admissions team will contact you shortly.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: const Icon(Icons.location_on_rounded,
                      color: AppColors.accent, size: 16),
                ),
                const SizedBox(width: 6),
                Text(
                  'Cougar Aviation Academy · Florida, USA',
                  style: TextStyle(
                    color: AppColors.accent.withOpacity(0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}