import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../onboarding/presentation/theme/onboarding_colors.dart';
import '../providers/subscription_provider.dart';
import 'choose_payment_screen.dart';

/// Review Summary & Processing Payment screen matching 62_Light & 63_Light.
class ReviewSummaryScreen extends ConsumerStatefulWidget {
  const ReviewSummaryScreen({super.key});

  @override
  ConsumerState<ReviewSummaryScreen> createState() =>
      _ReviewSummaryScreenState();
}

class _ReviewSummaryScreenState extends ConsumerState<ReviewSummaryScreen>
    with SingleTickerProviderStateMixin {
  bool _isProcessing = false;
  late final AnimationController _spinnerController;
  Timer? _paymentTimer;

  static const _benefits = [
    'Ad-free experience.',
    'Unlock and unlimited access to all premium contents.',
    'Advanced insights and mood chart.',
    'Sync data across multiple devices.',
    'Early access to new features and beta tests.',
    'Priority customer support.',
  ];

  @override
  void initState() {
    super.initState();
    _spinnerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _paymentTimer?.cancel();
    _spinnerController.dispose();
    super.dispose();
  }

  void _confirmPayment() {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);
    _spinnerController.repeat();

    _paymentTimer = Timer(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      _spinnerController.stop();
      ref.read(subscriptionProvider.notifier).activatePremium();
      context.go('/upgrade-success');
    });
  }

  @override
  Widget build(BuildContext context) {
    final sub = ref.watch(subscriptionProvider);
    final selectedMethod = sub.selectedPayment;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7F8),
        body: Stack(
          children: [
            SafeArea(
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
                              context.go('/choose-payment');
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
                            'Review Summary',
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Plan Summary Card
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
                                  padding:
                                      const EdgeInsets.fromLTRB(22, 24, 22, 20),
                                  child: Column(
                                    children: [
                                      Text(
                                        'MoodCanvas Premium',
                                        style:
                                            AppTypography.titleMedium.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: OnboardingColors.textDark,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.baseline,
                                        textBaseline: TextBaseline.alphabetic,
                                        children: [
                                          Text(
                                            sub.priceLabel,
                                            style: AppTypography.displayLarge
                                                .copyWith(
                                              fontSize: 36,
                                              fontWeight: FontWeight.w700,
                                              color: OnboardingColors.textDark,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            sub.periodLabel,
                                            style: AppTypography.bodyMedium
                                                .copyWith(
                                              fontSize: 14,
                                              color: OnboardingColors.textMuted,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 18),
                                      const Divider(
                                        color: Color(0xFFEEEEEE),
                                        height: 1,
                                      ),
                                      const SizedBox(height: 16),
                                      ..._benefits.map((b) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 12),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(top: 2),
                                                child: Icon(
                                                  Icons.check_rounded,
                                                  size: 18,
                                                  color:
                                                      OnboardingColors.textDark,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  b,
                                                  style: AppTypography
                                                      .bodyMedium
                                                      .copyWith(
                                                    fontSize: 13.5,
                                                    height: 1.4,
                                                    color: OnboardingColors
                                                        .textDark,
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

                          const SizedBox(height: 22),

                          // Selected Payment Method Section
                          Text(
                            'Selected Payment Method',
                            style: AppTypography.titleMedium.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: OnboardingColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
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
                                PaymentMethodBadge(methodId: selectedMethod.id),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        selectedMethod.name,
                                        style:
                                            AppTypography.titleMedium.copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: OnboardingColors.textDark,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        selectedMethod.subtitle,
                                        style: AppTypography.label.copyWith(
                                          fontSize: 12,
                                          color: OnboardingColors.textMuted,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    if (context.canPop()) {
                                      context.pop();
                                    } else {
                                      context.go('/choose-payment');
                                    }
                                  },
                                  child: Text(
                                    'Change',
                                    style: AppTypography.titleMedium.copyWith(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w700,
                                      color: OnboardingColors.primaryGreen,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Confirm Payment CTA
                  Container(
                    color: OnboardingColors.white,
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _confirmPayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: OnboardingColors.primaryGreen,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: Text(
                          'Confirm Payment - ${sub.priceLabel}',
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

            // Processing Payment Overlay (63_Light_processing payment)
            if (_isProcessing)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.45),
                    alignment: Alignment.center,
                    child: Container(
                      width: 248,
                      padding: const EdgeInsets.symmetric(
                        vertical: 32,
                        horizontal: 24,
                      ),
                      decoration: BoxDecoration(
                        color: OnboardingColors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.14),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedBuilder(
                            animation: _spinnerController,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: _spinnerController.value * 2 * math.pi,
                                child: child,
                              );
                            },
                            child: const SizedBox(
                              width: 52,
                              height: 52,
                              child: CustomPaint(
                                painter: _PaymentGreenSpinnerPainter(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Processing Payment...',
                            style: AppTypography.titleMedium.copyWith(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w600,
                              color: OnboardingColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PaymentGreenSpinnerPainter extends CustomPainter {
  const _PaymentGreenSpinnerPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    const strokeWidth = 5.5;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: 2 * math.pi,
        colors: [
          OnboardingColors.primaryGreen.withValues(alpha: 0.0),
          OnboardingColors.primaryGreen.withValues(alpha: 0.35),
          OnboardingColors.primaryGreen,
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
