import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_typography.dart';
import '../theme/onboarding_colors.dart';

/// Enter OTP Code screen matching 23_Light_enter OTP code,
/// complete with 4 OTP boxes, live resend countdown, and custom numeric keypad.
class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<String> _digits = [];
  int _secondsRemaining = 56;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    setState(() => _secondsRemaining = 56);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
      }
    });
  }

  void _onKeyPressed(String key) {
    if (key == 'backspace') {
      if (_digits.isNotEmpty) {
        setState(() => _digits.removeLast());
      }
      return;
    }

    if (key == '*') return;

    if (_digits.length < 4) {
      setState(() => _digits.add(key));
      if (_digits.length == 4) {
        Future.delayed(const Duration(milliseconds: 220), () {
          if (mounted) {
            context.go('/create-password');
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeIndex = _digits.length < 4 ? _digits.length : 3;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: OnboardingColors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Back Arrow
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => context.go('/forgot-password'),
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: OnboardingColors.textDark,
                      size: 24,
                    ),
                  ),
                ),
              ),

              // Header & OTP Boxes
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter OTP Code 🔐',
                        style: AppTypography.displayMedium.copyWith(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: OnboardingColors.textDark,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Check your email inbox for a message from MoodCanvas. Enter the one-time verification code below to proceed with resetting your password.',
                        style: AppTypography.bodyMedium.copyWith(
                          fontSize: 14.5,
                          height: 1.55,
                          color: OnboardingColors.textMuted,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // 4 OTP Boxes
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(4, (index) {
                          final hasValue = index < _digits.length;
                          final isFocused = index == activeIndex;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 160),
                            width: 68,
                            height: 64,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isFocused
                                  ? OnboardingColors.softGreenBg
                                  : OnboardingColors.backgroundLight,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isFocused
                                    ? OnboardingColors.primaryGreen
                                    : Colors.transparent,
                                width: 1.6,
                              ),
                            ),
                            child: Text(
                              hasValue ? _digits[index] : '',
                              style: AppTypography.displayMedium.copyWith(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: OnboardingColors.textDark,
                              ),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 28),

                      // Countdown & Resend Code
                      Center(
                        child: Column(
                          children: [
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: AppTypography.bodyMedium.copyWith(
                                  fontSize: 14,
                                  color: OnboardingColors.textMuted,
                                ),
                                children: [
                                  const TextSpan(
                                    text: 'You can resend the code in ',
                                  ),
                                  TextSpan(
                                    text: '$_secondsRemaining',
                                    style: const TextStyle(
                                      color: OnboardingColors.primaryGreen,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const TextSpan(text: ' seconds'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: _secondsRemaining == 0
                                  ? _startCountdown
                                  : null,
                              child: Text(
                                'Resend code',
                                style: AppTypography.bodyMedium.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _secondsRemaining == 0
                                      ? OnboardingColors.primaryGreen
                                      : OnboardingColors.textLight,
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

              // Custom Numeric Keypad matching 23_Light_enter OTP code
              Container(
                color: OnboardingColors.backgroundLight,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildKeypadRow(['1', '2', '3']),
                    const SizedBox(height: 8),
                    _buildKeypadRow(['4', '5', '6']),
                    const SizedBox(height: 8),
                    _buildKeypadRow(['7', '8', '9']),
                    const SizedBox(height: 8),
                    _buildKeypadRow(['*', '0', 'backspace']),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeypadRow(List<String> keys) {
    return Row(
      children: keys.map((key) {
        return Expanded(
          child: SizedBox(
            height: 54,
            child: InkWell(
              onTap: () => _onKeyPressed(key),
              borderRadius: BorderRadius.circular(12),
              child: Center(
                child: key == 'backspace'
                    ? const Icon(
                        Icons.backspace_outlined,
                        size: 22,
                        color: OnboardingColors.textDark,
                      )
                    : Text(
                        key,
                        style: AppTypography.displayMedium.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: OnboardingColors.textDark,
                        ),
                      ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
