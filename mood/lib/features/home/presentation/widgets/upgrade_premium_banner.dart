import 'package:flutter/material.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../onboarding/presentation/theme/onboarding_colors.dart';

/// Green "Upgrade Premium!" promotional banner card with a custom-painted
/// golden jeweled crown matching 26_Light_home.
class UpgradePremiumBanner extends StatelessWidget {
  final VoidCallback? onUpgradeTap;

  const UpgradePremiumBanner({
    super.key,
    this.onUpgradeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7CB342), Color(0xFF8BC34A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: OnboardingColors.primaryGreen.withValues(alpha: 0.22),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Subtle decorative soft circles in background
          Positioned(
            right: -14,
            top: -18,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            right: 52,
            bottom: -24,
            child: Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Upgrade Premium!',
                        style: AppTypography.titleLarge.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Enjoy all the benefits',
                        style: AppTypography.bodyMedium.copyWith(
                          fontSize: 12.5,
                          color: Colors.white.withValues(alpha: 0.92),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          onTap: onUpgradeTap ??
                              () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Premium features coming soon!'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 7,
                            ),
                            child: Text(
                              'Upgrade',
                              style: AppTypography.button.copyWith(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: OnboardingColors.primaryGreen,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Golden Jeweled Crown Illustration
                const SizedBox(
                  width: 86,
                  height: 76,
                  child: CustomPaint(painter: _GoldenCrownPainter()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GoldenCrownPainter extends CustomPainter {
  const _GoldenCrownPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.save();
    // Slight playful tilt matching 26_Light_home
    canvas.translate(w * 0.5, h * 0.52);
    canvas.rotate(-0.10);
    canvas.translate(-w * 0.5, -h * 0.52);

    // Back crown spikes (darker gold)
    final backPath = Path()
      ..moveTo(w * 0.14, h * 0.72)
      ..lineTo(w * 0.24, h * 0.28)
      ..lineTo(w * 0.42, h * 0.52)
      ..lineTo(w * 0.58, h * 0.52)
      ..lineTo(w * 0.76, h * 0.28)
      ..lineTo(w * 0.86, h * 0.72)
      ..close();
    canvas.drawPath(
      backPath,
      Paint()
        ..color = const Color(0xFFE59500)
        ..isAntiAlias = true,
    );

    // Main front crown body with rich gold gradient
    final bodyPath = Path()
      ..moveTo(w * 0.14, h * 0.74)
      ..lineTo(w * 0.08, h * 0.28)
      ..lineTo(w * 0.34, h * 0.52)
      ..lineTo(w * 0.50, h * 0.14)
      ..lineTo(w * 0.66, h * 0.52)
      ..lineTo(w * 0.92, h * 0.28)
      ..lineTo(w * 0.86, h * 0.74)
      ..quadraticBezierTo(w * 0.50, h * 0.86, w * 0.14, h * 0.74)
      ..close();

    final bodyRect = Rect.fromLTWH(0, 0, w, h);
    canvas.drawPath(
      bodyPath,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFFFD54F), Color(0xFFFFB300), Color(0xFFF57C00)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(bodyRect)
        ..isAntiAlias = true,
    );

    // Crown bottom band
    final bandPath = Path()
      ..moveTo(w * 0.14, h * 0.72)
      ..quadraticBezierTo(w * 0.50, h * 0.84, w * 0.86, h * 0.72)
      ..lineTo(w * 0.85, h * 0.82)
      ..quadraticBezierTo(w * 0.50, h * 0.94, w * 0.15, h * 0.82)
      ..close();
    canvas.drawPath(
      bandPath,
      Paint()
        ..color = const Color(0xFFFFA000)
        ..isAntiAlias = true,
    );

    // Crown tip pearls
    final pearlPaint = Paint()
      ..color = const Color(0xFFFFE082)
      ..isAntiAlias = true;
    canvas.drawCircle(Offset(w * 0.08, h * 0.26), 4.5, pearlPaint);
    canvas.drawCircle(Offset(w * 0.50, h * 0.13), 5.5, pearlPaint);
    canvas.drawCircle(Offset(w * 0.92, h * 0.26), 4.5, pearlPaint);

    // Center & side jewels
    // Center teal oval gem
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.50, h * 0.63), width: 11, height: 14),
      Paint()
        ..color = const Color(0xFF00ACC1)
        ..isAntiAlias = true,
    );
    // Left coral gem
    canvas.drawCircle(
      Offset(w * 0.26, h * 0.62),
      4.5,
      Paint()
        ..color = const Color(0xFFFF5252)
        ..isAntiAlias = true,
    );
    // Right coral gem
    canvas.drawCircle(
      Offset(w * 0.74, h * 0.62),
      4.5,
      Paint()
        ..color = const Color(0xFFFF5252)
        ..isAntiAlias = true,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
