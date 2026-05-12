import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/widgets/aviation_cards.dart';
import '../../../../shared/widgets/aviation_elements.dart';
import '../../../../shared/widgets/aviation_indicators.dart';

class FleetPage extends StatelessWidget {
  const FleetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OUR FLEET')),
      body: PageView.builder(
        controller: PageController(viewportFraction: 0.85),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.xl, horizontal: AppSpacing.sm),
            child: _AircraftCard(
              onTap: () => context.push('/fleet/$index'),
            ),
          );
        },
      ),
    );
  }
}

class _AircraftCard extends StatelessWidget {
  final VoidCallback? onTap;
  const _AircraftCard({this.onTap});

  @override
  Widget build(BuildContext context) {
    return AviationCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      showGoldBorder: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              color: AppColors.surface,
              child: const Center(child: Icon(Icons.airplanemode_active, size: 100, color: AppColors.accent)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cessna 172S', style: Theme.of(context).textTheme.displaySmall),
                  const Text('Single Engine Piston', style: TextStyle(color: AppColors.accent)),
                  const Spacer(),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _SpecItem(label: 'Range', value: '640 nm'),
                      _SpecItem(label: 'Altitude', value: '14,000 ft'),
                      _SpecItem(label: 'Speed', value: '124 kts'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecItem extends StatelessWidget {
  final String label;
  final String value;
  const _SpecItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'JetBrainsMono')),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
      ],
    );
  }
}

class AircraftDetailPage extends StatelessWidget {
  final String id;
  const AircraftDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('AIRCRAFT SPECS')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AviationCard(
              height: 250,
              child: Center(child: Icon(Icons.airplanemode_active, size: 150, color: Colors.white10)),
            ),
            AppSpacing.verticalXl,
            Text('Cessna 172S Skyhawk', style: Theme.of(context).textTheme.displayMedium),
            const Text('The backbone of flight training.', style: TextStyle(color: AppColors.accent)),
            AppSpacing.verticalLg,
            const Text(
              'The Cessna 172S Skyhawk is the ultimate training aircraft. With its stable flight characteristics and modern G1000 avionics, it provides the perfect platform for student pilots to learn the art of flying.',
              style: TextStyle(height: 1.6),
            ),
            AppSpacing.verticalXl,
            Text('Technical Specifications', style: Theme.of(context).textTheme.headlineMedium),
            AppSpacing.verticalMd,
            const AviationCard(
              child: Column(
                children: [
                  FlightDataRow(icon: Icons.settings, label: 'Engine', value: 'Lycoming IO-360-L2A'),
                  FlightDataRow(icon: Icons.speed, label: 'Cruise Speed', value: '124 kts'),
                  FlightDataRow(icon: Icons.height, label: 'Service Ceiling', value: '14,000 ft'),
                  FlightDataRow(icon: Icons.straighten, label: 'Wingspan', value: '36 ft 1 in'),
                  FlightDataRow(icon: Icons.gas_meter, label: 'Fuel Capacity', value: '53 Gallons'),
                ],
              ),
            ),
            AppSpacing.verticalXxl,
            const RadarWidget(),
            AppSpacing.verticalXxl,
          ],
        ),
      ),
    );
  }
}
