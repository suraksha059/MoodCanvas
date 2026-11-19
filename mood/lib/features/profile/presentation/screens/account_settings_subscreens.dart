import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../onboarding/presentation/providers/account_setup_provider.dart';
import '../../../onboarding/presentation/theme/onboarding_colors.dart';
import '../../../onboarding/presentation/widgets/social_brand_icons.dart';
import '../../../subscription/presentation/providers/subscription_provider.dart';

/// Shared light top bar for Settings sub-screens.
class _SettingsAppBar extends StatelessWidget {
  final String title;

  const _SettingsAppBar({required this.title});

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
// 95_Light_settings - Personal Info
// =============================================================================
class PersonalInfoScreen extends ConsumerStatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  ConsumerState<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends ConsumerState<PersonalInfoScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late String _gender;
  DateTime _dob = DateTime(1995, 12, 27);

  @override
  void initState() {
    super.initState();
    final setup = ref.read(accountSetupProvider);
    _nameController = TextEditingController(
      text: setup.nickname.trim().isNotEmpty
          ? setup.nickname.trim()
          : 'Andrew Ainsley',
    );
    _emailController = TextEditingController(
      text: setup.email.trim().isNotEmpty
          ? setup.email.trim()
          : 'andrew.ainsley@yourdomain.com',
    );
    _phoneController = TextEditingController(text: '+1 111 467 378 399');
    _gender = setup.gender;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob,
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _dob = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dobStr =
        '${_dob.month.toString().padLeft(2, '0')}-${_dob.day.toString().padLeft(2, '0')}-${_dob.year}';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: OnboardingColors.white,
        body: SafeArea(
          child: Column(
            children: [
              const _SettingsAppBar(title: 'Personal Info'),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Centered Avatar with Green Edit Badge
                      Center(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 92,
                              height: 92,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF9CCC65),
                                    Color(0xFF7CB342),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                _nameController.text.isNotEmpty
                                    ? _nameController.text[0].toUpperCase()
                                    : 'A',
                                style: AppTypography.displayLarge.copyWith(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 2,
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: OnboardingColors.primaryGreen,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.edit_rounded,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      _buildLabel('Full Name'),
                      _buildTextField(
                        controller: _nameController,
                        onChanged: (v) => ref
                            .read(accountSetupProvider.notifier)
                            .setNickname(v),
                      ),
                      const SizedBox(height: 18),

                      _buildLabel('Email'),
                      _buildTextField(
                        controller: _emailController,
                        prefixIcon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (v) =>
                            ref.read(accountSetupProvider.notifier).setEmail(v),
                      ),
                      const SizedBox(height: 18),

                      _buildLabel('Phone Number'),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: OnboardingColors.backgroundLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Text('🇺🇸', style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 18,
                              color: OnboardingColors.textMuted,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                style: AppTypography.bodyLarge.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: OnboardingColors.textDark,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      _buildLabel('Gender'),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: OnboardingColors.backgroundLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _gender,
                            isExpanded: true,
                            dropdownColor: OnboardingColors.white,
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: OnboardingColors.textDark,
                            ),
                            style: AppTypography.bodyLarge.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: OnboardingColors.textDark,
                            ),
                            items: const [
                              DropdownMenuItem(
                                  value: 'Male', child: Text('Male')),
                              DropdownMenuItem(
                                  value: 'Female', child: Text('Female')),
                              DropdownMenuItem(
                                value: 'Prefer not to say',
                                child: Text('Prefer not to say'),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _gender = val);
                                ref
                                    .read(accountSetupProvider.notifier)
                                    .setGender(val);
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      _buildLabel('Date of Birth'),
                      GestureDetector(
                        onTap: _pickDob,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: OnboardingColors.backgroundLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                dobStr,
                                style: AppTypography.bodyLarge.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: OnboardingColors.textDark,
                                ),
                              ),
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 19,
                                color: OnboardingColors.textDark,
                              ),
                            ],
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
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: AppTypography.titleMedium.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: OnboardingColors.textDark,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    IconData? prefixIcon,
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: AppTypography.bodyLarge.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: OnboardingColors.textDark,
      ),
      cursorColor: OnboardingColors.primaryGreen,
      decoration: InputDecoration(
        filled: true,
        fillColor: OnboardingColors.backgroundLight,
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                size: 20,
                color: OnboardingColors.textDark.withValues(alpha: 0.7),
              )
            : null,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: OnboardingColors.primaryGreen,
            width: 1.4,
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// 96_Light_settings - Account & Security
// =============================================================================
class AccountSecurityScreen extends StatefulWidget {
  const AccountSecurityScreen({super.key});

  @override
  State<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> {
  bool _biometricId = false;
  bool _faceId = false;
  bool _smsAuth = false;
  bool _googleAuth = false;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7F8),
        body: SafeArea(
          child: Column(
            children: [
              const _SettingsAppBar(title: 'Account & Security'),
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
                      children: [
                        _buildSwitchRow(
                          'Biometric ID',
                          _biometricId,
                          (v) => setState(() => _biometricId = v),
                        ),
                        _buildSwitchRow(
                          'Face ID',
                          _faceId,
                          (v) => setState(() => _faceId = v),
                        ),
                        _buildSwitchRow(
                          'SMS Authenticator',
                          _smsAuth,
                          (v) => setState(() => _smsAuth = v),
                        ),
                        _buildSwitchRow(
                          'Google Authenticator',
                          _googleAuth,
                          (v) => setState(() => _googleAuth = v),
                        ),
                        _buildActionRow(
                          title: 'Change Password',
                          onTap: () => context.push('/create-password'),
                        ),
                        _buildActionRow(
                          title: 'Device Management',
                          subtitle:
                              'Manage your account on the various devices you own.',
                          onTap: () {},
                        ),
                        _buildActionRow(
                          title: 'Deactivate Account',
                          subtitle:
                              "Temporarily deactivate your account. Easily reactivate when you're ready.",
                          onTap: () {},
                        ),
                        _buildActionRow(
                          title: 'Delete Account',
                          subtitle:
                              'Permanently remove your account and data. Proceed with caution.',
                          isDestructive: true,
                          onTap: () {},
                        ),
                      ],
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

  Widget _buildSwitchRow(
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTypography.titleMedium.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: OnboardingColors.textDark,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: OnboardingColors.primaryGreen,
            activeThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFE5E7EB),
            inactiveThumbColor: Colors.white,
            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow({
    required String title,
    String? subtitle,
    bool isDestructive = false,
    required VoidCallback onTap,
  }) {
    final titleColor =
        isDestructive ? OnboardingColors.moodRed : OnboardingColors.textDark;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleMedium.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: titleColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTypography.bodyMedium.copyWith(
                        fontSize: 12.5,
                        height: 1.4,
                        color: OnboardingColors.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: OnboardingColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// 97_Light_settings - Linked Accounts
// =============================================================================
class LinkedAccountsScreen extends StatefulWidget {
  const LinkedAccountsScreen({super.key});

  @override
  State<LinkedAccountsScreen> createState() => _LinkedAccountsScreenState();
}

class _LinkedAccountsScreenState extends State<LinkedAccountsScreen> {
  final Map<String, bool> _linked = {
    'Google': true,
    'Apple': true,
    'Facebook': false,
    'Twitter': false,
  };

  @override
  Widget build(BuildContext context) {
    final items = [
      (name: 'Google', icon: const GoogleLogoIcon(size: 26)),
      (
        name: 'Apple',
        icon: const Icon(Icons.apple, size: 28, color: OnboardingColors.textDark)
      ),
      (name: 'Facebook', icon: const FacebookLogoIcon(size: 26)),
      (
        name: 'Twitter',
        icon: Container(
          width: 26,
          height: 26,
          decoration: const BoxDecoration(
            color: Color(0xFF1DA1F2),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.flutter_dash, size: 16, color: Colors.white),
        )
      ),
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7F8),
        body: SafeArea(
          child: Column(
            children: [
              const _SettingsAppBar(title: 'Linked Accounts'),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isLinked = _linked[item.name] ?? false;

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: OnboardingColors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: OnboardingColors.borderLight
                              .withValues(alpha: 0.7),
                        ),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 32,
                            height: 32,
                            child: Center(child: item.icon),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              item.name,
                              style: AppTypography.titleMedium.copyWith(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w600,
                                color: OnboardingColors.textDark,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() => _linked[item.name] = !isLinked);
                            },
                            child: Text(
                              isLinked ? 'Linked' : 'Link',
                              style: AppTypography.titleMedium.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isLinked
                                    ? OnboardingColors.textMuted
                                    : OnboardingColors.primaryGreen,
                              ),
                            ),
                          ),
                        ],
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
// 98_Light_settings - Billing & Subscriptions
// =============================================================================
class BillingSubscriptionsScreen extends ConsumerWidget {
  const BillingSubscriptionsScreen({super.key});

  static const _benefits = [
    'Ad-free experience.',
    'Unlock and unlimited access to all premium contents.',
    'Advanced insights and mood chart.',
    'Sync data across multiple devices.',
    'Early access to new features and beta tests.',
    'Priority customer support.',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sub = ref.watch(subscriptionProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7F8),
        body: SafeArea(
          child: Column(
            children: [
              const _SettingsAppBar(title: 'Billing & Subscriptions'),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: OnboardingColors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: OnboardingColors.borderLight
                                .withValues(alpha: 0.7),
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: const BoxDecoration(
                                  color: OnboardingColors.primaryGreen,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Save 17%',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(22, 26, 22, 22),
                              child: Column(
                                children: [
                                  Text(
                                    'MoodCanvas Premium',
                                    style: AppTypography.titleMedium.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: OnboardingColors.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        sub.priceLabel,
                                        style:
                                            AppTypography.displayLarge.copyWith(
                                          fontSize: 38,
                                          fontWeight: FontWeight.w700,
                                          color: OnboardingColors.textDark,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        sub.periodLabel,
                                        style:
                                            AppTypography.bodyMedium.copyWith(
                                          fontSize: 14,
                                          color: OnboardingColors.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  const Divider(
                                      color: Color(0xFFEEEEEE), height: 1),
                                  const SizedBox(height: 18),
                                  ..._benefits.map((b) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 13),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(top: 2),
                                            child: Icon(
                                              Icons.check_rounded,
                                              size: 18,
                                              color: OnboardingColors.textDark,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              b,
                                              style: AppTypography.bodyMedium
                                                  .copyWith(
                                                fontSize: 14,
                                                height: 1.4,
                                                color:
                                                    OnboardingColors.textDark,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                  const SizedBox(height: 10),
                                  const Divider(
                                      color: Color(0xFFEEEEEE), height: 1),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Your current plan',
                                    style: AppTypography.bodyMedium.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: OnboardingColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => context.push('/upgrade-plan'),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: AppTypography.bodyMedium.copyWith(
                              fontSize: 12.5,
                              height: 1.6,
                              color: OnboardingColors.textMuted,
                            ),
                            children: const [
                              TextSpan(
                                text:
                                    'Your subscription will expire on Dec 22, 2025.\nRenew or cancel your subscription ',
                              ),
                              TextSpan(
                                text: 'here.',
                                style: TextStyle(
                                  color: OnboardingColors.primaryGreen,
                                  fontWeight: FontWeight.w600,
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
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// 102_Light & 103_Light_settings - App Appearance & Choose Theme Sheet
// =============================================================================
class AppAppearanceScreen extends StatefulWidget {
  const AppAppearanceScreen({super.key});

  @override
  State<AppAppearanceScreen> createState() => _AppAppearanceScreenState();
}

class _AppAppearanceScreenState extends State<AppAppearanceScreen> {
  String _selectedTheme = 'Light';
  String _selectedLanguage = 'English';

  Future<void> _showChooseThemeSheet() async {
    String tempTheme = _selectedTheme;

    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                decoration: const BoxDecoration(
                  color: OnboardingColors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Choose Theme',
                        style: AppTypography.titleLarge.copyWith(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: OnboardingColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: Color(0xFFEEEEEE), height: 1),
                      const SizedBox(height: 8),
                      for (final option in ['System Default', 'Light', 'Dark'])
                        InkWell(
                          onTap: () => setModalState(() => tempTheme = option),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              children: [
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: OnboardingColors.primaryGreen,
                                      width: 2,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(3.5),
                                  child: tempTheme == option
                                      ? Container(
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                OnboardingColors.primaryGreen,
                                          ),
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 14),
                                Text(
                                  option,
                                  style: AppTypography.titleMedium.copyWith(
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w500,
                                    color: OnboardingColors.textDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 12),
                      const Divider(color: Color(0xFFEEEEEE), height: 1),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: TextButton(
                                onPressed: () => Navigator.of(ctx).pop(),
                                style: TextButton.styleFrom(
                                  backgroundColor: OnboardingColors.softGreenBg,
                                  foregroundColor:
                                      OnboardingColors.primaryGreen,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(26),
                                  ),
                                ),
                                child: Text(
                                  'Cancel',
                                  style: AppTypography.button.copyWith(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w600,
                                    color: OnboardingColors.primaryGreen,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () =>
                                    Navigator.of(ctx).pop(tempTheme),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      OnboardingColors.primaryGreen,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(26),
                                  ),
                                ),
                                child: Text(
                                  'OK',
                                  style: AppTypography.button.copyWith(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null && mounted) {
      setState(() => _selectedTheme = result);
    }
  }

  Future<void> _showLanguageSheet() async {
    const languages = ['English', 'Spanish', 'French', 'German', 'Japanese'];
    final chosen = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: OnboardingColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'App Language',
                  style: AppTypography.titleLarge.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: OnboardingColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                ...languages.map((lang) {
                  final selected = lang == _selectedLanguage;
                  return ListTile(
                    title: Text(
                      lang,
                      style: AppTypography.titleMedium.copyWith(
                        fontSize: 15,
                        color: OnboardingColors.textDark,
                      ),
                    ),
                    trailing: selected
                        ? const Icon(
                            Icons.check_rounded,
                            color: OnboardingColors.primaryGreen,
                          )
                        : null,
                    onTap: () => Navigator.of(ctx).pop(lang),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );

    if (chosen != null && mounted) {
      setState(() => _selectedLanguage = chosen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7F8),
        body: SafeArea(
          child: Column(
            children: [
              const _SettingsAppBar(title: 'App Appearance'),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: OnboardingColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color:
                          OnboardingColors.borderLight.withValues(alpha: 0.7),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildRow('Theme', _selectedTheme, _showChooseThemeSheet),
                      _buildRow(
                          'App Language', _selectedLanguage, _showLanguageSheet),
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

  Widget _buildRow(String title, String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTypography.titleMedium.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: OnboardingColors.textDark,
                ),
              ),
            ),
            Text(
              value,
              style: AppTypography.bodyMedium.copyWith(
                fontSize: 14,
                color: OnboardingColors.textMuted,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: OnboardingColors.textDark,
            ),
          ],
        ),
      ),
    );
  }
}
