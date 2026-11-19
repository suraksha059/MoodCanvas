import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_typography.dart';
import '../theme/onboarding_colors.dart';

/// Reset Password Success screen matching 25_Light_reset password.
class ResetSuccessScreen extends ConsumerWidget {
  const ResetSuccessScreen({super.key});

  void _goToHomepage(BuildContext context, WidgetRef ref) {
    ref.read(onboardingCompletedProvider.notifier).complete();
    context.go('/home');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: OnboardingColors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
            child: Column(
              children: [
                const Spacer(),

                // Green circular badge with mini smartphone + verified user icon
                Container(
                  width: 108,
                  height: 108,
                  decoration: const BoxDecoration(
                    color: OnboardingColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    width: 48,
                    height: 70,
                    decoration: BoxDecoration(
                      color: OnboardingColors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: OnboardingColors.deviceBezel,
                        width: 2.2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 14,
                          height: 2.5,
                          decoration: BoxDecoration(
                            color: OnboardingColors.deviceBezel,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: OnboardingColors.primaryGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            size: 16,
                            color: OnboardingColors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: 22,
                          height: 3,
                          decoration: BoxDecoration(
                            color: OnboardingColors.borderLight,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Title
                Text(
                  "You're All Set!",
                  textAlign: TextAlign.center,
                  style: AppTypography.displayMedium.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: OnboardingColors.textDark,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 10),

                // Subtitle
                Text(
                  'Your password has been successfully updated.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    fontSize: 14.5,
                    color: OnboardingColors.textMuted,
                  ),
                ),

                const Spacer(),

                // Bottom CTA
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () => _goToHomepage(context, ref),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: OnboardingColors.primaryGreen,
                      foregroundColor: OnboardingColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Text(
                      'Go to Homepage',
                      style: AppTypography.button.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: OnboardingColors.white,
                      ),
                    ),
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
