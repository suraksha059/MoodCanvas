import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../onboarding/presentation/theme/onboarding_colors.dart';
import '../providers/subscription_provider.dart';

/// Upgrade Plan screen matching 59_Light_upgrade (Monthly) and 60_Light_upgrade (Yearly).
class UpgradePlanScreen extends ConsumerWidget {
  const UpgradePlanScreen({super.key});

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
    final notifier = ref.read(subscriptionProvider.notifier);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7F8),
        body: SafeArea(
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/profile');
                        }
                      },
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        size: 24,
                        color: OnboardingColors.textDark,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Upgrade Plan',
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
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  child: Column(
                    children: [
                      // Monthly | Yearly Segmented Control
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: OnboardingColors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: OnboardingColors.borderLight
                                .withValues(alpha: 0.7),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _BillingTab(
                                label: 'Monthly',
                                selected: !sub.isYearly,
                                onTap: () => notifier.setYearly(false),
                              ),
                            ),
                            Expanded(
                              child: _BillingTab(
                                label: 'Yearly',
                                selected: sub.isYearly,
                                onTap: () => notifier.setYearly(true),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Pricing & Benefits Card
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: OnboardingColors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: OnboardingColors.borderLight
                                .withValues(alpha: 0.7),
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
                        child: Stack(
                          children: [
                            // "Save 17%" Corner Badge for Yearly
                            if (sub.isYearly)
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
                              padding: const EdgeInsets.fromLTRB(22, 26, 22, 24),
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
                                          letterSpacing: -0.8,
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
                                    color: Color(0xFFEEEEEE),
                                    height: 1,
                                  ),
                                  const SizedBox(height: 18),

                                  // 6 Premium Benefits List
                                  ..._benefits.map((benefit) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 14),
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
                                              benefit,
                                              style: AppTypography.bodyMedium
                                                  .copyWith(
                                                fontSize: 14,
                                                height: 1.45,
                                                color:
                                                    OnboardingColors.textDark,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom CTA Button
              Container(
                color: OnboardingColors.white,
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () => context.push('/choose-payment'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: OnboardingColors.primaryGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Text(
                      'Continue - ${sub.priceLabel}',
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
        ),
      ),
    );
  }
}

class _BillingTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _BillingTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color:
              selected ? OnboardingColors.primaryGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTypography.titleMedium.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : OnboardingColors.textDark,
          ),
        ),
      ),
    );
  }
}
