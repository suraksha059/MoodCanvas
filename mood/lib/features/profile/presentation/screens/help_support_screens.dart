import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../onboarding/presentation/theme/onboarding_colors.dart';

class _HelpAppBar extends StatelessWidget {
  final String title;

  const _HelpAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_rounded,
              size: 24,
              color: OnboardingColors.textDark,
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.titleLarge.copyWith(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: OnboardingColors.textDark,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

// =============================================================================
// 105_Light_settings - Help & Support Menu
// =============================================================================
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rows = [
      (
        title: 'FAQ',
        onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const FaqScreen()),
            ),
      ),
      (
        title: 'Contact Support',
        onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                  builder: (_) => const ContactSupportScreen()),
            ),
      ),
      (
        title: 'Privacy Policy',
        onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                  builder: (_) => const PrivacyPolicyScreen()),
            ),
      ),
      (
        title: 'Terms of Service',
        onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                  builder: (_) => const TermsOfServiceScreen()),
            ),
      ),
      (title: 'Partner', onTap: () {}),
      (title: 'Job Vacancy', onTap: () {}),
      (title: 'Accessibility', onTap: () {}),
      (title: 'Feedback', onTap: () {}),
      (title: 'About us', onTap: () {}),
      (title: 'Rate us', onTap: () {}),
      (title: 'Visit Our Website', onTap: () {}),
      (title: 'Follow us on Social Media', onTap: () {}),
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7F8),
        body: SafeArea(
          child: Column(
            children: [
              const _HelpAppBar(title: 'Help & Support'),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                  child: Container(
                    decoration: BoxDecoration(
                      color: OnboardingColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: OnboardingColors.borderLight
                            .withValues(alpha: 0.7),
                      ),
                    ),
                    child: Column(
                      children: rows.map((row) {
                        return InkWell(
                          onTap: row.onTap,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 15,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    row.title,
                                    style: AppTypography.titleMedium.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: OnboardingColors.textDark,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right_rounded,
                                  size: 20,
                                  color: OnboardingColors.textDark,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// 106_Light_settings - FAQ
// =============================================================================
class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  int _selectedCategory = 0;
  int? _expandedIndex = 0;
  String _query = '';

  static const _categories = ['General', 'Account', 'Services', 'Mood'];

  static const _faqs = [
    (
      q: 'What is MoodCanvas?',
      a: 'MoodCanvas is a mood tracking app that helps you monitor your emotions, log activities, and gain insights into your mental well-being.',
    ),
    (
      q: 'How does MoodCanvas work?',
      a: 'Pick your mood each day, tag activities or reflections, and explore trends across your Insights and Calendar tabs.',
    ),
    (
      q: 'Is MoodCanvas free to use?',
      a: 'Yes! Core daily mood logging, calendar history, and basic insights are completely free. You can upgrade to Premium anytime for advanced charts and themes.',
    ),
    (
      q: 'Can I use MoodCanvas offline?',
      a: 'Yes, all your mood entries and journal reflections are stored locally on your device so you can log anytime without an internet connection.',
    ),
    (
      q: 'Is my data secure with MoodCanvas?',
      a: 'Your emotional entries are kept privately on your device, and you can enable Biometric ID or Face ID in Account & Security for extra privacy.',
    ),
    (
      q: 'Can I export my MoodCanvas data?',
      a: 'Yes, you can export your mood logs and summaries anytime from Account > Export Data.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _query.isEmpty
        ? _faqs
        : _faqs
            .where((f) =>
                f.q.toLowerCase().contains(_query.toLowerCase()) ||
                f.a.toLowerCase().contains(_query.toLowerCase()))
            .toList();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7F8),
        body: SafeArea(
          child: Column(
            children: [
              const _HelpAppBar(title: 'FAQ'),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
                child: TextField(
                  onChanged: (v) => setState(() => _query = v.trim()),
                  style: AppTypography.bodyMedium.copyWith(
                    color: OnboardingColors.textDark,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: AppTypography.bodyMedium.copyWith(
                      color: OnboardingColors.textLight,
                    ),
                    filled: true,
                    fillColor: OnboardingColors.white,
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      size: 20,
                      color: OnboardingColors.textLight,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // Category Pills
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _categories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final selected = _selectedCategory == index;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? OnboardingColors.primaryGreen
                              : OnboardingColors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: selected
                                ? OnboardingColors.primaryGreen
                                : OnboardingColors.borderLight,
                          ),
                        ),
                        child: Text(
                          _categories[index],
                          style: AppTypography.label.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: selected
                                ? Colors.white
                                : OnboardingColors.textDark,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Accordion FAQ Cards
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    final isExpanded = _expandedIndex == index;

                    return Container(
                      decoration: BoxDecoration(
                        color: OnboardingColors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: OnboardingColors.borderLight
                              .withValues(alpha: 0.7),
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          setState(() {
                            _expandedIndex = isExpanded ? null : index;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.q,
                                      style: AppTypography.titleMedium.copyWith(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w700,
                                        color: OnboardingColors.textDark,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    isExpanded
                                        ? Icons.keyboard_arrow_up_rounded
                                        : Icons.keyboard_arrow_down_rounded,
                                    color: OnboardingColors.textDark,
                                  ),
                                ],
                              ),
                              if (isExpanded) ...[
                                const SizedBox(height: 10),
                                const Divider(
                                    color: Color(0xFFEEEEEE), height: 1),
                                const SizedBox(height: 10),
                                Text(
                                  item.a,
                                  style: AppTypography.bodyMedium.copyWith(
                                    fontSize: 13.5,
                                    height: 1.55,
                                    color: OnboardingColors.textMuted,
                                  ),
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
        ),
      ),
    );
  }
}

// =============================================================================
// 107_Light_settings - Contact Support
// =============================================================================
class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const channels = [
      (icon: Icons.headset_mic_outlined, label: 'Customer Support'),
      (icon: Icons.language_rounded, label: 'Website'),
      (icon: Icons.chat_bubble_outline_rounded, label: 'WhatsApp'),
      (icon: Icons.facebook_rounded, label: 'Facebook'),
      (icon: Icons.alternate_email_rounded, label: 'X (Formerly Twitter)'),
      (icon: Icons.camera_alt_outlined, label: 'Instagram'),
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7F8),
        body: SafeArea(
          child: Column(
            children: [
              const _HelpAppBar(title: 'Contact Support'),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  itemCount: channels.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final ch = channels[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: OnboardingColors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: OnboardingColors.borderLight
                              .withValues(alpha: 0.7),
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Opening ${ch.label}...'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                ch.icon,
                                size: 22,
                                color: OnboardingColors.primaryGreen,
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  ch.label,
                                  style: AppTypography.titleMedium.copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: OnboardingColors.textDark,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right_rounded,
                                size: 20,
                                color: OnboardingColors.textDark,
                              ),
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
        ),
      ),
    );
  }
}

// =============================================================================
// 108_Light_settings - Privacy Policy
// =============================================================================
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: OnboardingColors.white,
        body: SafeArea(
          child: Column(
            children: [
              const _HelpAppBar(title: 'Privacy Policy'),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _policyHeading('Effective Date: December 19, 2024'),
                      const SizedBox(height: 10),
                      _policyBody(
                        'MoodCanvas ("we," "our," or "us") respects the privacy of its users ("you" or "your"). This Privacy Policy describes how we collect, use, disclose, and store your information when you use our mobile application, MoodCanvas (the "App").',
                      ),
                      const SizedBox(height: 20),
                      _policyHeading('1. Information We Collect:'),
                      const SizedBox(height: 8),
                      _policyBullet(
                        'Account Information: When you create an account, we collect your email address and a nickname you choose to use within the app.',
                      ),
                      _policyBullet(
                        'Optional Information: You may optionally provide additional information such as your age and gender (demographic data).',
                      ),
                      _policyBullet(
                        'Usage Data: We collect information about your use of the App, such as your mood selections, activities tracked, and any notes you add.',
                      ),
                      const SizedBox(height: 20),
                      _policyHeading('2. How We Use Your Information:'),
                      const SizedBox(height: 8),
                      _policyBullet(
                        'We use your information to provide, operate, and maintain the App.',
                      ),
                      _policyBullet(
                        'We use your information to personalize your experience and provide you with relevant insights.',
                      ),
                      _policyBullet(
                        'Your personal journal entries stay securely stored on your device.',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// 109_Light_settings - Terms of Service
// =============================================================================
class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: OnboardingColors.white,
        body: SafeArea(
          child: Column(
            children: [
              const _HelpAppBar(title: 'Terms of Service'),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _policyHeading('Effective Date: December 20, 2024'),
                      const SizedBox(height: 10),
                      _policyBody(
                        'These Terms of Service ("Terms") govern your use of the MoodCanvas mobile application (the "App") developed and operated by MoodCanvas ("we," "our," or "us"). By accessing or using the App, you agree to be bound by these Terms.',
                      ),
                      const SizedBox(height: 20),
                      _policyHeading('1. Use of the App:'),
                      const SizedBox(height: 8),
                      _policyBullet(
                        'You must be at least 13 years old to use the App.',
                      ),
                      _policyBullet(
                        'You are responsible for maintaining the confidentiality of your account information and password.',
                      ),
                      _policyBullet(
                        'You are responsible for all activity that occurs under your account.',
                      ),
                      _policyBullet(
                        'You agree not to use the App for any illegal or unauthorized purpose.',
                      ),
                      const SizedBox(height: 20),
                      _policyHeading('2. Intellectual Property:'),
                      const SizedBox(height: 8),
                      _policyBody(
                        'The App and all content contained therein, including trademarks, copyrights, and other intellectual property rights, are the property of MoodCanvas or its licensors.',
                      ),
                      const SizedBox(height: 20),
                      _policyHeading('3. Termination:'),
                      const SizedBox(height: 8),
                      _policyBody(
                        'We may terminate your access to the App for any reason, with or without notice.',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _policyHeading(String text) {
  return Text(
    text,
    style: AppTypography.titleMedium.copyWith(
      fontSize: 15.5,
      fontWeight: FontWeight.w700,
      color: OnboardingColors.textDark,
    ),
  );
}

Widget _policyBody(String text) {
  return Text(
    text,
    style: AppTypography.bodyMedium.copyWith(
      fontSize: 14,
      height: 1.6,
      color: OnboardingColors.textMuted,
    ),
  );
}

Widget _policyBullet(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '•  ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: OnboardingColors.textMuted,
          ),
        ),
        Expanded(child: _policyBody(text)),
      ],
    ),
  );
}
