import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_typography.dart';
import '../theme/onboarding_colors.dart';
import '../widgets/social_brand_icons.dart';

/// Sign in screen matching 19_Light_sign in blank form,
/// 20_Light_sign in filled form, and 21_Light_sign in loading.
class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  late final AnimationController _spinnerController;
  Timer? _loadingTimer;

  bool get _isFormReady =>
      _emailController.text.trim().isNotEmpty &&
      _passwordController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _spinnerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _emailController.addListener(_onFieldChanged);
    _passwordController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    setState(() {});
  }

  void _startSignIn() {
    if (_isLoading) return;
    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);
    _spinnerController.repeat();

    _loadingTimer = Timer(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      _spinnerController.stop();
      ref.read(onboardingCompletedProvider.notifier).complete();
      context.go('/home');
    });
  }

  @override
  void dispose() {
    _loadingTimer?.cancel();
    _spinnerController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: OnboardingColors.white,
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  // Top Bar with Back Arrow
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => context.go('/welcome'),
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: OnboardingColors.textDark,
                          size: 24,
                        ),
                      ),
                    ),
                  ),

                  // Scrollable Form Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome Back! 👋',
                            style: AppTypography.displayMedium.copyWith(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: OnboardingColors.textDark,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Continue tracking your moods and earning badges.',
                            style: AppTypography.bodyMedium.copyWith(
                              fontSize: 14.5,
                              height: 1.5,
                              color: OnboardingColors.textMuted,
                            ),
                          ),

                          const SizedBox(height: 28),

                          // Email Field
                          Text(
                            'Email',
                            style: AppTypography.titleMedium.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: OnboardingColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildInputField(
                            controller: _emailController,
                            hintText: 'Email',
                            prefixIcon: Icons.mail_outline_rounded,
                            keyboardType: TextInputType.emailAddress,
                          ),

                          const SizedBox(height: 18),

                          // Password Field
                          Text(
                            'Password',
                            style: AppTypography.titleMedium.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: OnboardingColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildInputField(
                            controller: _passwordController,
                            hintText: 'Password',
                            prefixIcon: Icons.lock_outline_rounded,
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(
                                    () => _obscurePassword = !_obscurePassword);
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 20,
                                color: OnboardingColors.textMuted,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Remember me & Forgot Password?
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() => _rememberMe = !_rememberMe);
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 180),
                                      width: 21,
                                      height: 21,
                                      decoration: BoxDecoration(
                                        color: _rememberMe
                                            ? OnboardingColors.primaryGreen
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: OnboardingColors.primaryGreen,
                                          width: 1.8,
                                        ),
                                      ),
                                      child: _rememberMe
                                          ? const Icon(
                                              Icons.check_rounded,
                                              size: 15,
                                              color: Colors.white,
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Remember me',
                                      style: AppTypography.bodyMedium.copyWith(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w500,
                                        color: OnboardingColors.textDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () => context.go('/forgot-password'),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  'Forgot Password?',
                                  style: AppTypography.bodyMedium.copyWith(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    color: OnboardingColors.primaryGreen,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 28),

                          // "or continue with" Divider
                          Row(
                            children: [
                              const Expanded(
                                child: Divider(
                                  color: OnboardingColors.borderLight,
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 14),
                                child: Text(
                                  'or continue with',
                                  style: AppTypography.bodyMedium.copyWith(
                                    fontSize: 13,
                                    color: OnboardingColors.textMuted,
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: Divider(
                                  color: OnboardingColors.borderLight,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 22),

                          // 4 Social Icon Pill Buttons
                          Row(
                            children: [
                              Expanded(
                                child: _SocialPillIconButton(
                                  icon: const GoogleLogoIcon(size: 20),
                                  onTap: _startSignIn,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _SocialPillIconButton(
                                  icon: const Icon(
                                    Icons.apple,
                                    size: 23,
                                    color: OnboardingColors.textDark,
                                  ),
                                  onTap: _startSignIn,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _SocialPillIconButton(
                                  icon: const FacebookLogoIcon(size: 22),
                                  onTap: _startSignIn,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _SocialPillIconButton(
                                  icon: const XLogoIcon(size: 18),
                                  onTap: _startSignIn,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Sign in Button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _startSignIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isFormReady
                              ? OnboardingColors.primaryGreen
                              : const Color(0xFF6B9345),
                          foregroundColor: OnboardingColors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: Text(
                          'Sign in',
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

            // Loading Overlay (21_Light_sign in loading)
            if (_isLoading)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.45),
                    alignment: Alignment.center,
                    child: Container(
                      width: 240,
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
                                painter: _SignInGreenSpinnerPainter(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Sign in...',
                            style: AppTypography.titleMedium.copyWith(
                              fontSize: 16,
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
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
          prefixIcon,
          size: 20,
          color: OnboardingColors.textDark.withValues(alpha: 0.7),
        ),
        suffixIcon: suffixIcon,
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

class _SocialPillIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onTap;

  const _SocialPillIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: OnboardingColors.white,
          side: const BorderSide(color: OnboardingColors.borderLight, width: 1.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Center(child: icon),
      ),
    );
  }
}

class _SignInGreenSpinnerPainter extends CustomPainter {
  const _SignInGreenSpinnerPainter();

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
