import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../onboarding/presentation/providers/account_setup_provider.dart';
import '../../../onboarding/presentation/theme/onboarding_colors.dart';
import '../../../onboarding/presentation/widgets/mood_sticker_logo.dart';
import '../../../subscription/presentation/providers/subscription_provider.dart';
import 'account_settings_subscreens.dart';
import 'achievements_favorites_screens.dart';
import 'edit_moods_colors_screen.dart';
import 'help_support_screens.dart';
import 'manage_activities_screen.dart';
import 'media_preferences_screens.dart';

/// Light-theme Account & Settings screen matching 58_Light_account & settings.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _showComingSoon(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title settings coming soon!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openScreen(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => screen),
    );
  }

  Future<void> _showLogoutSheet(BuildContext context) async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (ctx) {
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
                    'Logout',
                    style: AppTypography.titleLarge.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: OnboardingColors.moodRed,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFFEEEEEE), height: 1),
                  const SizedBox(height: 20),
                  Text(
                    'Sure you want to log out?',
                    textAlign: TextAlign.center,
                    style: AppTypography.titleMedium.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: OnboardingColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: TextButton(
                            onPressed: () => Navigator.of(ctx).pop(false),
                            style: TextButton.styleFrom(
                              backgroundColor: OnboardingColors.softGreenBg,
                              foregroundColor: OnboardingColors.primaryGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: AppTypography.button.copyWith(
                                fontSize: 15,
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
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(ctx).pop(true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: OnboardingColors.primaryGreen,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: Text(
                              'Yes, Logout',
                              style: AppTypography.button.copyWith(
                                fontSize: 15,
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

    if (confirmed == true && context.mounted) {
      context.go('/welcome');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setup = ref.watch(accountSetupProvider);
    final sub = ref.watch(subscriptionProvider);

    final displayName =
        setup.nickname.trim().isNotEmpty ? setup.nickname.trim() : 'Andrew Ainsley';
    final displayEmail = setup.email.trim().isNotEmpty
        ? setup.email.trim()
        : 'andrew.ainsley@yourdomain.com';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7F8),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Top App Bar: Sticker Logo | "Account" | More Menu
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 12, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const MoodStickerLogo(size: 28, inverted: false),
                    Text(
                      'Account',
                      style: AppTypography.titleLarge.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: OnboardingColors.textDark,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _showComingSoon(context, 'Account'),
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        size: 24,
                        color: OnboardingColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable Account Settings List
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 6, 20, 32),
                  children: [
                    // 1. Upgrade Plan Now! Green Banner
                    GestureDetector(
                      onTap: () => context.push('/upgrade-plan'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7CB342), Color(0xFF8BC34A)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: OnboardingColors.primaryGreen
                                  .withValues(alpha: 0.22),
                              blurRadius: 14,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.workspace_premium_rounded,
                                color: OnboardingColors.badgeOrange,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    sub.isPremium
                                        ? 'MoodCanvas Premium Active'
                                        : 'Upgrade Plan Now!',
                                    style: AppTypography.titleMedium.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    sub.isPremium
                                        ? 'All premium features are unlocked'
                                        : 'Enjoy all the benefits and explore more possibilities',
                                    style: AppTypography.label.copyWith(
                                      fontSize: 11.5,
                                      color: Colors.white.withValues(alpha: 0.92),
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 2. User Profile Card
                    _SettingsGroupCard(
                      children: [
                        InkWell(
                          onTap: () =>
                              _openScreen(context, const PersonalInfoScreen()),
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 52,
                                  height: 52,
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
                                    displayName.substring(0, 1).toUpperCase(),
                                    style: AppTypography.titleLarge.copyWith(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        displayName,
                                        style:
                                            AppTypography.titleMedium.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: OnboardingColors.textDark,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        displayEmail,
                                        style: AppTypography.bodyMedium
                                            .copyWith(
                                          fontSize: 12.5,
                                          color: OnboardingColors.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right_rounded,
                                  color: OnboardingColors.textDark,
                                  size: 22,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // 3. Group 1: Achievements, Favorites, Photo Gallery
                    _SettingsGroupCard(
                      children: [
                        _SettingsRow(
                          icon: Icons.military_tech_outlined,
                          title: 'Achievements',
                          onTap: () => _openScreen(
                              context, const AchievementsScreen()),
                        ),
                        _SettingsRow(
                          icon: Icons.star_outline_rounded,
                          title: 'Favorites',
                          onTap: () =>
                              _openScreen(context, const FavoritesScreen()),
                        ),
                        _SettingsRow(
                          icon: Icons.photo_library_outlined,
                          title: 'Photo Gallery',
                          onTap: () => _openScreen(
                              context, const PhotoGalleryScreen()),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // 4. Group 2: Daily Reminder, Edit Moods & Colors, Manage Activities, Export Data, Preferences
                    _SettingsGroupCard(
                      children: [
                        _SettingsRow(
                          icon: Icons.notifications_none_rounded,
                          title: 'Daily Reminder',
                          onTap: () => _openScreen(
                              context, const DailyReminderScreen()),
                        ),
                        _SettingsRow(
                          icon: Icons.sentiment_satisfied_alt_outlined,
                          title: 'Edit Moods & Colors',
                          onTap: () => _openScreen(
                              context, const EditMoodsColorsScreen()),
                        ),
                        _SettingsRow(
                          icon: Icons.grid_view_rounded,
                          title: 'Manage Activities',
                          onTap: () => _openScreen(
                              context, const ManageActivitiesScreen()),
                        ),
                        _SettingsRow(
                          icon: Icons.file_download_outlined,
                          title: 'Export Data',
                          onTap: () =>
                              _openScreen(context, const ExportDataScreen()),
                        ),
                        _SettingsRow(
                          icon: Icons.settings_outlined,
                          title: 'Preferences',
                          onTap: () =>
                              _openScreen(context, const PreferencesScreen()),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // 5. Group 3: Account & Security .. Logout
                    _SettingsGroupCard(
                      children: [
                        _SettingsRow(
                          icon: Icons.verified_user_outlined,
                          title: 'Account & Security',
                          onTap: () => _openScreen(
                              context, const AccountSecurityScreen()),
                        ),
                        _SettingsRow(
                          icon: Icons.credit_card_outlined,
                          title: 'Payment Methods',
                          onTap: () => context.push('/choose-payment'),
                        ),
                        _SettingsRow(
                          icon: Icons.confirmation_number_outlined,
                          title: 'Billing & Subscriptions',
                          onTap: () => _openScreen(
                              context, const BillingSubscriptionsScreen()),
                        ),
                        _SettingsRow(
                          icon: Icons.swap_vert_rounded,
                          title: 'Linked Accounts',
                          onTap: () => _openScreen(
                              context, const LinkedAccountsScreen()),
                        ),
                        _SettingsRow(
                          icon: Icons.visibility_outlined,
                          title: 'App Appearance',
                          onTap: () => _openScreen(
                              context, const AppAppearanceScreen()),
                        ),
                        _SettingsRow(
                          icon: Icons.description_outlined,
                          title: 'Help & Support',
                          onTap: () =>
                              _openScreen(context, const HelpSupportScreen()),
                        ),
                        _SettingsRow(
                          icon: Icons.group_add_outlined,
                          title: 'Invite Your Friends',
                          onTap: () =>
                              _showComingSoon(context, 'Invite Your Friends'),
                        ),
                        _SettingsRow(
                          icon: Icons.star_border_rounded,
                          title: 'Rate us',
                          onTap: () => _showComingSoon(context, 'Rate us'),
                        ),
                        _SettingsRow(
                          icon: Icons.logout_rounded,
                          title: 'Logout',
                          isDestructive: true,
                          showChevron: false,
                          onTap: () => _showLogoutSheet(context),
                        ),
                      ],
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

class _SettingsGroupCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsGroupCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: OnboardingColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: OnboardingColors.borderLight.withValues(alpha: 0.7),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;
  final bool showChevron;

  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    final fg =
        isDestructive ? OnboardingColors.moodRed : OnboardingColors.textDark;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: fg),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: AppTypography.titleMedium.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: fg,
                ),
              ),
            ),
            if (showChevron)
              const Icon(
                Icons.chevron_right_rounded,
                size: 21,
                color: OnboardingColors.textDark,
              ),
          ],
        ),
      ),
    );
  }
}
