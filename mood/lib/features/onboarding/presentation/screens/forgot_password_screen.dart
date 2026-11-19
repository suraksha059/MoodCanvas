import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_typography.dart';
import '../theme/onboarding_colors.dart';

/// Forgot Password screen matching 22_Light_forgot password.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    FocusScope.of(context).unfocus();
    context.go('/otp-verification');
  }

  @override
  Widget build(BuildContext context) {
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
                    onPressed: () => context.go('/signin'),
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: OnboardingColors.textDark,
                      size: 24,
                    ),
                  ),
                ),
              ),

              // Form Body
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Forgot Your Password? 🔑',
                        style: AppTypography.displayMedium.copyWith(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: OnboardingColors.textDark,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Enter the email associated with your MoodCanvas account below. We'll send you an OTP code to reset your password.",
                        style: AppTypography.bodyMedium.copyWith(
                          fontSize: 14.5,
                          height: 1.55,
                          color: OnboardingColors.textMuted,
                        ),
                      ),

                      const SizedBox(height: 30),

                      Text(
                        'Your Registered Email',
                        style: AppTypography.titleMedium.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: OnboardingColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 10),

                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: AppTypography.bodyLarge.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: OnboardingColors.textDark,
                        ),
                        cursorColor: OnboardingColors.primaryGreen,
                        decoration: InputDecoration(
                          hintText: 'andrew.ainsley@yourdomain.com',
                          hintStyle: AppTypography.bodyMedium.copyWith(
                            fontSize: 14.5,
                            color: OnboardingColors.textLight,
                          ),
                          filled: true,
                          fillColor: OnboardingColors.backgroundLight,
                          prefixIcon: Icon(
                            Icons.mail_outline_rounded,
                            size: 20,
                            color:
                                OnboardingColors.textDark.withValues(alpha: 0.7),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: OnboardingColors.primaryGreen,
                              width: 1.4,
                            ),
                          ),
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
                    onPressed: _sendOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: OnboardingColors.primaryGreen,
                      foregroundColor: OnboardingColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Text(
                      'Send OTP Code',
                      style: AppTypography.button.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: OnboardingColors.white,
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
