import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_typography.dart';
import '../theme/onboarding_colors.dart';

/// Finalizing personalized page screen matching 18_Light_account setup.
/// Animates a circular green progress ring from 0% to 100% and navigates to /home.
class SetupLoadingScreen extends ConsumerStatefulWidget {
  const SetupLoadingScreen({super.key});

  @override
  ConsumerState<SetupLoadingScreen> createState() => _SetupLoadingScreenState();
}

class _SetupLoadingScreenState extends ConsumerState<SetupLoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _progressAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        ref.read(onboardingCompletedProvider.notifier).complete();
        context.go('/home');
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: OnboardingColors.white,
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
              child: Column(
                children: [
                  const SizedBox(height: 36),

                  // Title
                  Text(
                    'Setting up your\npersonalized page...',
                    textAlign: TextAlign.center,
                    style: AppTypography.displayMedium.copyWith(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: OnboardingColors.textDark,
                      height: 1.28,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Subtitle
                  Text(
                    'Almost ready!',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMedium.copyWith(
                      fontSize: 15,
                      color: OnboardingColors.textMuted,
                    ),
                  ),

                  const Spacer(),

                  // Animated Circular Progress Ring + Percentage
                  AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (context, _) {
                      final pct = (_progressAnimation.value * 100).round();
                      return SizedBox(
                        width: 210,
                        height: 210,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomPaint(
                              size: const Size(210, 210),
                              painter: _SetupProgressRingPainter(
                                progress: _progressAnimation.value,
                              ),
                            ),
                            Text(
                              '$pct%',
                              style: AppTypography.displayLarge.copyWith(
                                fontSize: 44,
                                fontWeight: FontWeight.w700,
                                color: OnboardingColors.textDark,
                                letterSpacing: -1.0,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const Spacer(),

                  // Footer Text
                  Text(
                    'We are customizing MoodCanvas just for you.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMedium.copyWith(
                      fontSize: 14,
                      color: OnboardingColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SetupProgressRingPainter extends CustomPainter {
  final double progress;

  _SetupProgressRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 16.0;
    final rect = (Offset.zero & size).deflate(strokeWidth / 2);

    // Light gray background track
    final trackPaint = Paint()
      ..color = const Color(0xFFEEEEEE)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true;
    canvas.drawOval(rect, trackPaint);

    // Green progress arc starting from 12 o'clock
    final progressPaint = Paint()
      ..color = OnboardingColors.primaryGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * progress.clamp(0.0, 1.0),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _SetupProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
