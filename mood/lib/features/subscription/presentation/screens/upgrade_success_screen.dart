import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../onboarding/presentation/theme/onboarding_colors.dart';

/// Upgrade Success / Congratulations screen matching 64_Light_upgrade success.
class UpgradeSuccessScreen extends StatelessWidget {
  const UpgradeSuccessScreen({super.key});

  static const _unlockedBenefits = [
    'Ad-free experience',
    'Unlimited access to all premium contents',
    'Advanced insights and mood chart',
    'Sync data across multiple devices',
    'Early access to new features',
    'Priority customer support',
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: OnboardingColors.white,
        body: Stack(
          children: [
            // Decorative Confetti Layer at the top
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 220,
              child: IgnorePointer(
                child: CustomPaint(painter: _ConfettiPainter()),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 52, 24, 24),
                      child: Column(
                        children: [
                          // Orange/Gold Crown Badge
                          Container(
                            width: 82,
                            height: 82,
                            decoration: BoxDecoration(
                              color: OnboardingColors.badgeOrange,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: OnboardingColors.badgeOrange
                                      .withValues(alpha: 0.30),
                                  blurRadius: 18,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.workspace_premium_rounded,
                              color: Colors.white,
                              size: 42,
                            ),
                          ),
                          const SizedBox(height: 22),

                          Text(
                            'Congratulations!',
                            textAlign: TextAlign.center,
                            style: AppTypography.displayMedium.copyWith(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: OnboardingColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "You're Now a MoodCanvas Premium Member!",
                            textAlign: TextAlign.center,
                            style: AppTypography.bodyMedium.copyWith(
                              fontSize: 14,
                              color: OnboardingColors.textMuted,
                            ),
                          ),

                          const SizedBox(height: 24),
                          const Divider(color: Color(0xFFEEEEEE), height: 1),
                          const SizedBox(height: 22),

                          Text(
                            'Benefits Unlocked:',
                            style: AppTypography.titleMedium.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: OnboardingColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 16),

                          ..._unlockedBenefits.map((benefit) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.check_rounded,
                                    size: 18,
                                    color: OnboardingColors.textDark,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      benefit,
                                      style: AppTypography.bodyMedium.copyWith(
                                        fontSize: 14,
                                        color: OnboardingColors.textDark,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),

                          const SizedBox(height: 18),
                          const Divider(color: Color(0xFFEEEEEE), height: 1),
                          const SizedBox(height: 18),

                          Text(
                            'Your subscription will automatically renew annually unless canceled. Manage your subscription in your account settings.',
                            textAlign: TextAlign.center,
                            style: AppTypography.bodyMedium.copyWith(
                              fontSize: 12.5,
                              height: 1.5,
                              color: OnboardingColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom CTA
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () => context.go('/home'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: OnboardingColors.primaryGreen,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: Text(
                          'Start Exploring Premium Features',
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
          ],
        ),
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  const _ConfettiPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final pieces = [
      (x: 0.12, y: 0.18, w: 10.0, h: 5.0, rot: 0.4, color: const Color(0xFF42A5F5)),
      (x: 0.25, y: 0.12, w: 8.0, h: 8.0, rot: 0.8, color: const Color(0xFFFFCA28)),
      (x: 0.36, y: 0.28, w: 11.0, h: 4.5, rot: -0.5, color: const Color(0xFFEF5350)),
      (x: 0.48, y: 0.15, w: 9.0, h: 5.0, rot: 0.2, color: const Color(0xFF66BB6A)),
      (x: 0.62, y: 0.22, w: 12.0, h: 5.0, rot: -0.6, color: const Color(0xFFAB47BC)),
      (x: 0.74, y: 0.14, w: 8.0, h: 8.0, rot: 0.3, color: const Color(0xFFFF7043)),
      (x: 0.86, y: 0.24, w: 10.0, h: 4.5, rot: 0.7, color: const Color(0xFF26C6DA)),
      (x: 0.18, y: 0.54, w: 9.0, h: 4.5, rot: -0.4, color: const Color(0xFF66BB6A)),
      (x: 0.80, y: 0.58, w: 9.0, h: 5.0, rot: 0.5, color: const Color(0xFFEF5350)),
      (x: 0.08, y: 0.42, w: 7.0, h: 7.0, rot: 0.2, color: const Color(0xFFFFA726)),
      (x: 0.90, y: 0.44, w: 8.0, h: 4.5, rot: -0.3, color: const Color(0xFF42A5F5)),
      (x: 0.30, y: 0.68, w: 7.0, h: 4.0, rot: 0.6, color: const Color(0xFFEC407A)),
      (x: 0.70, y: 0.72, w: 8.0, h: 4.0, rot: -0.5, color: const Color(0xFFFFCA28)),
    ];

    for (final p in pieces) {
      canvas.save();
      canvas.translate(size.width * p.x, size.height * p.y);
      canvas.rotate(p.rot);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: p.w, height: p.h),
          const Radius.circular(2),
        ),
        Paint()..color = p.color,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
