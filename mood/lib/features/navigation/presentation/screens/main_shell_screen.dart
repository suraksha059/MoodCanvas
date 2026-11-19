import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../onboarding/presentation/theme/onboarding_colors.dart';
import '../widgets/mood_bottom_nav_bar.dart';

/// Navigation shell hosting the persistent light bottom navigation bar and active tab child.
class MainShellScreen extends StatelessWidget {
  final Widget child;

  const MainShellScreen({
    super.key,
    required this.child,
  });

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/insights')) return 1;
    if (location.startsWith('/calendar') || location.startsWith('/memories')) {
      return 2;
    }
    if (location.startsWith('/profile')) return 3;
    return 0; // Default to Home
  }

  void _onTabSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/insights');
        break;
      case 2:
        context.go('/calendar');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _calculateSelectedIndex(context);

    return Scaffold(
      backgroundColor: OnboardingColors.white,
      body: child,
      bottomNavigationBar: MoodBottomNavBar(
        currentIndex: currentIndex,
        onTabSelected: (index) => _onTabSelected(context, index),
        onCapturePressed: () => context.push('/capture'),
      ),
    );
  }
}
