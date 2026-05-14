// lib/shared/widgets/country_code_picker.dart

import 'package:flutter/material.dart';

class CountryCode {
  final String name;
  final String code;
  final String dialCode;
  final String flag;

  const CountryCode({
    required this.name,
    required this.code,
    required this.dialCode,
    required this.flag,
  });
}

final List<CountryCode> countryCodes = [
  CountryCode(name: 'United States', code: 'US', dialCode: '+1', flag: '🇺🇸'),
  CountryCode(name: 'Egypt', code: 'EG', dialCode: '+20', flag: '🇪🇬'),
  CountryCode(name: 'United Kingdom', code: 'GB', dialCode: '+44', flag: '🇬🇧'),
  CountryCode(name: 'Saudi Arabia', code: 'SA', dialCode: '+966', flag: '🇸🇦'),
  CountryCode(name: 'UAE', code: 'AE', dialCode: '+971', flag: '🇦🇪'),
  CountryCode(name: 'Kuwait', code: 'KW', dialCode: '+965', flag: '🇰🇼'),
  CountryCode(name: 'Qatar', code: 'QA', dialCode: '+974', flag: '🇶🇦'),
  CountryCode(name: 'Bahrain', code: 'BH', dialCode: '+973', flag: '🇧🇭'),
  CountryCode(name: 'Oman', code: 'OM', dialCode: '+968', flag: '🇴🇲'),
  CountryCode(name: 'Jordan', code: 'JO', dialCode: '+962', flag: '🇯🇴'),
  CountryCode(name: 'Lebanon', code: 'LB', dialCode: '+961', flag: '🇱🇧'),
  CountryCode(name: 'Iraq', code: 'IQ', dialCode: '+964', flag: '🇮🇶'),
  CountryCode(name: 'Syria', code: 'SY', dialCode: '+963', flag: '🇸🇾'),
  CountryCode(name: 'Libya', code: 'LY', dialCode: '+218', flag: '🇱🇾'),
  CountryCode(name: 'Tunisia', code: 'TN', dialCode: '+216', flag: '🇹🇳'),
  CountryCode(name: 'Algeria', code: 'DZ', dialCode: '+213', flag: '🇩🇿'),
  CountryCode(name: 'Morocco', code: 'MA', dialCode: '+212', flag: '🇲🇦'),
  CountryCode(name: 'Sudan', code: 'SD', dialCode: '+249', flag: '🇸🇩'),
  CountryCode(name: 'Yemen', code: 'YE', dialCode: '+967', flag: '🇾🇪'),
  CountryCode(name: 'Germany', code: 'DE', dialCode: '+49', flag: '🇩🇪'),
  CountryCode(name: 'France', code: 'FR', dialCode: '+33', flag: '🇫🇷'),
  CountryCode(name: 'Italy', code: 'IT', dialCode: '+39', flag: '🇮🇹'),
  CountryCode(name: 'Spain', code: 'ES', dialCode: '+34', flag: '🇪🇸'),
  CountryCode(name: 'Turkey', code: 'TR', dialCode: '+90', flag: '🇹🇷'),
  CountryCode(name: 'Pakistan', code: 'PK', dialCode: '+92', flag: '🇵🇰'),
  CountryCode(name: 'India', code: 'IN', dialCode: '+91', flag: '🇮🇳'),
  CountryCode(name: 'Canada', code: 'CA', dialCode: '+1', flag: '🇨🇦'),
  CountryCode(name: 'Australia', code: 'AU', dialCode: '+61', flag: '🇦🇺'),
  CountryCode(name: 'South Africa', code: 'ZA', dialCode: '+27', flag: '🇿🇦'),
  CountryCode(name: 'Nigeria', code: 'NG', dialCode: '+234', flag: '🇳🇬'),
  CountryCode(name: 'Kenya', code: 'KE', dialCode: '+254', flag: '🇰🇪'),
  CountryCode(name: 'Ethiopia', code: 'ET', dialCode: '+251', flag: '🇪🇹'),
];

class CountryCodePicker extends StatefulWidget {
  final CountryCode? initialValue;
  final ValueChanged<CountryCode> onChanged;

  const CountryCodePicker({
    super.key,
    this.initialValue,
    required this.onChanged,
  });

  @override
  State<CountryCodePicker> createState() => _CountryCodePickerState();
}

class _CountryCodePickerState extends State<CountryCodePicker>
    with SingleTickerProviderStateMixin {
  late CountryCode _selected;
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue ??
        countryCodes.firstWhere((c) => c.code == 'EG',
            orElse: () => countryCodes.first);
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _openPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CountryPickerSheet(
        selected: _selected,
        onSelect: (code) {
          setState(() => _selected = code);
          widget.onChanged(code);
          _animController.reset();
          _animController.forward();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: FadeTransition(
        opacity: _fadeAnim,
        child: GestureDetector(
          onTap: _openPicker,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _selected.flag,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 6),
                Text(
                  _selected.dialCode,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 4),
                AnimatedRotation(
                  turns: 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
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

class _CountryPickerSheet extends StatefulWidget {
  final CountryCode selected;
  final ValueChanged<CountryCode> onSelect;

  const _CountryPickerSheet({
    required this.selected,
    required this.onSelect,
  });

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _sheetAnim;
  late Animation<Offset> _slideAnim;
  String _search = '';
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

  void _filterSearch(String q) {
    setState(() {
      _search = q;
      if (q.isEmpty) {
        _filtered = countryCodes;
      } else {
        _filtered = countryCodes
            .where((c) =>
        c.name.toLowerCase().contains(q.toLowerCase()) ||
            c.dialCode.contains(q))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SlideTransition(
      position: _slideAnim,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Country Code',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    onChanged: _filterSearch,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Search country or dial code...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      filled: true,
                      fillColor: theme.colorScheme.surface,
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
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _filtered.length,
                itemBuilder: (context, i) {
                  final item = _filtered[i];
                  final isSelected = item.code == widget.selected.code;
                  return _CountryTile(
                    item: item,
                    isSelected: isSelected,
                    index: i,
                    onTap: () {
                      widget.onSelect(item);
                      Navigator.of(context).pop();
                    },
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

class _CountryTile extends StatefulWidget {
  final CountryCode item;
  final bool isSelected;
  final int index;
  final VoidCallback onTap;

  const _CountryTile({
    required this.item,
    required this.isSelected,
    required this.index,
    required this.onTap,
  });

  @override
  State<_CountryTile> createState() => _CountryTileState();
}

class _CountryTileState extends State<_CountryTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300 + (widget.index % 8) * 30),
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0.05, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    Future.delayed(Duration(milliseconds: widget.index % 8 * 20), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;

    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: InkWell(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            color: widget.isSelected
                ? accent.withOpacity(0.08)
                : Colors.transparent,
            padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                Text(widget.item.flag,
                    style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    widget.item.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: widget.isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: widget.isSelected ? accent : null,
                    ),
                  ),
                ),
                Text(
                  widget.item.dialCode,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: widget.isSelected
                        ? accent
                        : theme.colorScheme.onSurface.withOpacity(0.5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (widget.isSelected) ...[
                  const SizedBox(width: 10),
                  Icon(Icons.check_circle_rounded,
                      color: accent, size: 18),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}