import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_typography.dart';
import '../theme/onboarding_colors.dart';
import '../widgets/mood_sticker_logo.dart';

/// Light green splash screen matching 1_Light_splash screen.
/// Automatically transitions to the walkthrough onboarding after a brief pause.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spinnerController;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _spinnerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();

    _navigationTimer = Timer(const Duration(milliseconds: 1800), () {
      if (mounted) {
        context.go('/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _spinnerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: OnboardingColors.primaryGreen,
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                const Spacer(flex: 5),

                // White peeling-sticker smiley logo + brand name
                const MoodStickerLogo(size: 108, inverted: true),
                const SizedBox(height: 22),
                Text(
                  'MoodCanvas',
                  style: AppTypography.displayLarge.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: OnboardingColors.white,
                    letterSpacing: -0.4,
                  ),
                ),

                const Spacer(flex: 4),

                // Smooth white sweep-gradient circular spinner
                AnimatedBuilder(
                  animation: _spinnerController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _spinnerController.value * 2 * math.pi,
                      child: child,
                    );
                  },
                  child: const SizedBox(
                    width: 44,
                    height: 44,
                    child: CustomPaint(
                      painter: _WhiteArcSpinnerPainter(),
                    ),
                  ),
                ),

                const SizedBox(height: 52),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WhiteArcSpinnerPainter extends CustomPainter {
  const _WhiteArcSpinnerPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    const strokeWidth = 5.0;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: 2 * math.pi,
        colors: [
          Colors.white.withValues(alpha: 0.0),
          Colors.white.withValues(alpha: 0.25),
          Colors.white,
        ],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(rect);

    canvas.drawArc(
      rect.deflate(strokeWidth / 2),
      0.15 * math.pi,
      1.65 * math.pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
