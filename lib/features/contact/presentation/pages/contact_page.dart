import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/widgets/aviation_cards.dart';
import '../../../../shared/widgets/aviation_buttons.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CONTACT US')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AviationCard(
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map, size: 48, color: AppColors.accent),
                    Text('Academy Location Map'),
                    Text('Google Maps Integrated Here', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ),
            AppSpacing.verticalLg,
            _buildContactInfo(),
            AppSpacing.verticalXl,
            Text('Send us a Message', style: Theme.of(context).textTheme.headlineMedium),
            AppSpacing.verticalMd,
            _buildContactForm(),
            AppSpacing.verticalXxl,
            _buildSocialLinks(),
            AppSpacing.verticalXxl,
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo() {
    return Column(
      children: [
        _buildInfoCard(Icons.phone, 'Call Us', '+1 (234) 567-8900', 'tel:+12345678900'),
        AppSpacing.verticalMd,
        _buildInfoCard(Icons.email, 'Email Us', 'info@cougaraviation.com', 'mailto:info@cougaraviation.com'),
        AppSpacing.verticalMd,
        _buildInfoCard(Icons.chat, 'WhatsApp', 'Chat with an advisor', 'https://wa.me/12345678900'),
      ],
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String value, String url) {
    return AviationCard(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) await launchUrl(uri);
      },
      child: Row(
        children: [
          Icon(icon, color: AppColors.accent),
          AppSpacing.horizontalMd,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(value, style: const TextStyle(color: AppColors.textSecondary)),
            ],
          ),
          const Spacer(),
          const Icon(Icons.open_in_new, size: 16, color: AppColors.textMuted),
        ],
      ),
    );
  }

  Widget _buildContactForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Full Name'),
            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
          ),
          AppSpacing.verticalMd,
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email Address'),
            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
          ),
          AppSpacing.verticalMd,
          TextFormField(
            controller: _messageController,
            decoration: const InputDecoration(labelText: 'Message'),
            maxLines: 4,
            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
          ),
          AppSpacing.verticalLg,
          PremiumButton(
            text: 'Submit Inquiry',
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Inquiry sent successfully!'), backgroundColor: AppColors.success),
                );
                _nameController.clear();
                _emailController.clear();
                _messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialIcon(Icons.facebook),
        AppSpacing.horizontalMd,
        _buildSocialIcon(Icons.camera_alt),
        AppSpacing.horizontalMd,
        _buildSocialIcon(Icons.link),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.card,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border),
      ),
      child: Icon(icon, color: AppColors.accent, size: 24),
    );
  }
}
