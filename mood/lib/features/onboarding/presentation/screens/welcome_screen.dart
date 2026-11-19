import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_typography.dart';
import '../theme/onboarding_colors.dart';
import '../widgets/mood_sticker_logo.dart';
import '../widgets/social_brand_icons.dart';

/// Welcome / Get Started screen matching 5_Light_welcome screen.
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  void _signIn(BuildContext context) {
    context.go('/signin');
  }

  void _startSignUp(BuildContext context) {
    context.go('/signup');
  }

  void _continueWithSocial(BuildContext context) {
    context.go('/account-setup');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: OnboardingColors.white,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 40,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const SizedBox(height: 24),

                        // Green peeling-sticker smiley logo
                        const MoodStickerLogo(size: 76, inverted: false),
                        const SizedBox(height: 28),

                        // Headline
                        Text(
                          "Let's Get Started!",
                          textAlign: TextAlign.center,
                          style: AppTypography.displayLarge.copyWith(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: OnboardingColors.textDark,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Subtitle
                        Text(
                          "Let's dive into your account",
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyMedium.copyWith(
                            fontSize: 15,
                            color: OnboardingColors.textMuted,
                          ),
                        ),

                        const SizedBox(height: 36),

                        // Social Auth Buttons
                        _SocialAuthButton(
                          label: 'Continue with Google',
                          icon: const GoogleLogoIcon(),
                          onTap: () => _continueWithSocial(context),
                        ),
                        const SizedBox(height: 14),
                        _SocialAuthButton(
                          label: 'Continue with Apple',
                          icon: const Icon(
                            Icons.apple,
                            size: 23,
                            color: OnboardingColors.textDark,
                          ),
                          onTap: () => _continueWithSocial(context),
                        ),
                        const SizedBox(height: 14),
                        _SocialAuthButton(
                          label: 'Continue with Facebook',
                          icon: const FacebookLogoIcon(),
                          onTap: () => _continueWithSocial(context),
                        ),
                        const SizedBox(height: 14),
                        _SocialAuthButton(
                          label: 'Continue with X',
                          icon: const XLogoIcon(),
                          onTap: () => _continueWithSocial(context),
                        ),

                        const SizedBox(height: 28),

                        // Primary Green "Sign up" Button
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: () => _startSignUp(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: OnboardingColors.primaryGreen,
                              foregroundColor: OnboardingColors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: Text(
                              'Sign up',
                              style: AppTypography.button.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: OnboardingColors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Secondary Soft Green "Sign in" Button
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: TextButton(
                            onPressed: () => _signIn(context),
                            style: TextButton.styleFrom(
                              backgroundColor: OnboardingColors.softGreenBg,
                              foregroundColor: OnboardingColors.primaryGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: Text(
                              'Sign in',
                              style: AppTypography.button.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: OnboardingColors.primaryGreen,
                              ),
                            ),
                          ),
                        ),

                        const Spacer(),
                        const SizedBox(height: 24),

                        // Footer Links: Privacy Policy · Terms of Service
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              'Privacy Policy',
                              style: AppTypography.label.copyWith(
                                fontSize: 12,
                                color: OnboardingColors.textMuted,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                '·',
                                style: AppTypography.label.copyWith(
                                  fontSize: 14,
                                  color: OnboardingColors.textLight,
                                ),
                              ),
                            ),
                            Text(
                              'Terms of Service',
                              style: AppTypography.label.copyWith(
                                fontSize: 12,
                                color: OnboardingColors.textMuted,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Outlined pill button with a leading brand icon and centered label.
class _SocialAuthButton extends StatelessWidget {
  final String label;
  final Widget icon;
  final VoidCallback onTap;

  const _SocialAuthButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: OnboardingColors.white,
          foregroundColor: OnboardingColors.textDark,
          side: const BorderSide(color: OnboardingColors.borderLight, width: 1.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 24,
                height: 24,
                child: Center(child: icon),
              ),
            ),
            Text(
              label,
              style: AppTypography.button.copyWith(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: OnboardingColors.textDark,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
