import 'package:flutter/material.dart';
import '../../../../core/theme/app_typography.dart';
import '../theme/onboarding_colors.dart';
import 'walkthrough_phone_mockup.dart';

/// Content layout for a single walkthrough onboarding page:
/// - Top ~56%: Leaf-green curved header containing the iPhone preview mockup,
///   cleanly clipped along a gentle convex bottom arch.
/// - Bottom: Bold dark title and soft muted subtitle on pure white.
class OnboardingPageContent extends StatelessWidget {
  final int pageIndex;
  final String title;
  final String description;

  const OnboardingPageContent({
    super.key,
    required this.pageIndex,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return Column(
      children: [
        // Top green curved hero containing the phone mockup
        Expanded(
          flex: 12,
          child: ClipPath(
            clipper: _BottomArchClipper(),
            child: Container(
              width: double.infinity,
              color: OnboardingColors.primaryGreen,
              padding: EdgeInsets.only(top: topPadding + 16),
              child: Align(
                alignment: Alignment.topCenter,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.topCenter,
                  child: WalkthroughPhoneMockup(pageIndex: pageIndex),
                ),
              ),
            ),
          ),
        ),

        // Bottom white text section
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 22, 28, 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTypography.displayMedium.copyWith(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    height: 1.28,
                    letterSpacing: -0.3,
                    color: OnboardingColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    fontSize: 14,
                    height: 1.55,
                    color: OnboardingColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Clips the bottom edge of the green header into a smooth gentle convex arch,
/// creating the curved white overlap effect from the design.
class _BottomArchClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const curveDepth = 36.0;
    final path = Path()
      ..lineTo(0, size.height - curveDepth)
      ..quadraticBezierTo(
        size.width / 2,
        size.height + curveDepth,
        size.width,
        size.height - curveDepth,
      )
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
