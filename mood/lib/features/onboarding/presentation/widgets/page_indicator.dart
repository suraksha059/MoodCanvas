import 'package:flutter/material.dart';
import '../theme/onboarding_colors.dart';

/// Smooth animated pill indicator for onboarding walkthrough pages.
class PageIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const PageIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          height: 7.0,
          width: isActive ? 26.0 : 7.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: isActive
                ? OnboardingColors.primaryGreen
                : OnboardingColors.dotInactive,
          ),
        );
      }),
    );
  }
}
