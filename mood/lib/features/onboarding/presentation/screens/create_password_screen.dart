import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_typography.dart';
import '../theme/onboarding_colors.dart';

/// Create New Password screen matching 24_Light_create new password.
class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _saveNewPassword() {
    FocusScope.of(context).unfocus();
    context.go('/reset-success');
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
                    onPressed: () => context.go('/otp-verification'),
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
                        'Secure Your Account 🔒',
                        style: AppTypography.displayMedium.copyWith(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: OnboardingColors.textDark,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Enter a new password for your MoodCanvas account below. Make sure it's secure and easy for you to remember.",
                        style: AppTypography.bodyMedium.copyWith(
                          fontSize: 14.5,
                          height: 1.55,
                          color: OnboardingColors.textMuted,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // New Password
                      Text(
                        'New Password',
                        style: AppTypography.titleMedium.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: OnboardingColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildPasswordField(
                        controller: _newPasswordController,
                        hintText: 'New Password',
                        obscure: _obscureNew,
                        onToggle: () =>
                            setState(() => _obscureNew = !_obscureNew),
                      ),

                      const SizedBox(height: 20),

                      // Confirm New Password
                      Text(
                        'Confirm New Password',
                        style: AppTypography.titleMedium.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: OnboardingColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildPasswordField(
                        controller: _confirmPasswordController,
                        hintText: 'Confirm New Password',
                        obscure: _obscureConfirm,
                        onToggle: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
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
                    onPressed: _saveNewPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: OnboardingColors.primaryGreen,
                      foregroundColor: OnboardingColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Text(
                      'Save New Password',
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

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: AppTypography.bodyLarge.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: OnboardingColors.textDark,
      ),
      cursorColor: OnboardingColors.primaryGreen,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTypography.bodyMedium.copyWith(
          fontSize: 14.5,
          color: OnboardingColors.textLight,
        ),
        filled: true,
        fillColor: OnboardingColors.backgroundLight,
        prefixIcon: Icon(
          Icons.lock_outline_rounded,
          size: 20,
          color: OnboardingColors.textDark.withValues(alpha: 0.7),
        ),
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            size: 20,
            color: OnboardingColors.textMuted,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
    );
  }
}
