import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_typography.dart';
import '../theme/onboarding_colors.dart';
import '../widgets/onboarding_page_content.dart';
import '../widgets/page_indicator.dart';

/// 3-page light-green walkthrough onboarding flow matching
/// 2_Light_walkthrough 2, 3_Light_walkthrough 3, and 4_Light_walkthrough 4.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const _pages = [
    (
      title: 'Welcome to MoodCanvas -\nTrack Your Daily Moods',
      description:
          'Easily log your emotions and activities every day to gain valuable insights into your mental wellbeing.',
    ),
    (
      title: 'Gain Valuable & Detailed\nMood Insights',
      description:
          'Monitor your progress with detailed mood charts, mood count, activity counts, etc to enhance your mood.',
    ),
    (
      title: 'Stay Motivated with\nAchievements',
      description:
          'Earn badges as you track your mood, making your journey to better mental health fun and engaging.',
    ),
  ];

  void _onContinue() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _goToWelcome();
    }
  }

  void _goToWelcome() {
    context.go('/welcome');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _pages.length - 1;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: OnboardingColors.white,
        body: Column(
          children: [
            // 3 Walkthrough Pages (Green curved mockup + Title/Subtitle)
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return OnboardingPageContent(
                    pageIndex: index,
                    title: page.title,
                    description: page.description,
                  );
                },
              ),
            ),

            // Page Indicator + Bottom Action Buttons
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 6, 24, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PageIndicator(
                      count: _pages.length,
                      currentIndex: _currentPage,
                    ),
                    const SizedBox(height: 24),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: isLastPage
                          ? _buildGetStartedButton()
                          : _buildSkipContinueRow(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Pages 1 & 2: Two side-by-side pill buttons ("Skip" and "Continue").
  Widget _buildSkipContinueRow() {
    return Row(
      key: const ValueKey('skip_continue_row'),
      children: [
        Expanded(
          child: SizedBox(
            height: 52,
            child: TextButton(
              onPressed: _goToWelcome,
              style: TextButton.styleFrom(
                backgroundColor: OnboardingColors.softGreenBg,
                foregroundColor: OnboardingColors.primaryGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: Text(
                'Skip',
                style: AppTypography.button.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: OnboardingColors.primaryGreen,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: OnboardingColors.primaryGreen,
                foregroundColor: OnboardingColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: Text(
                'Continue',
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
    );
  }

  /// Page 3: Single full-width green pill button ("Let's Get Started").
  Widget _buildGetStartedButton() {
    return SizedBox(
      key: const ValueKey('get_started_button'),
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _goToWelcome,
        style: ElevatedButton.styleFrom(
          backgroundColor: OnboardingColors.primaryGreen,
          foregroundColor: OnboardingColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Text(
          "Let's Get Started",
          style: AppTypography.button.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: OnboardingColors.white,
          ),
        ),
      ),
    );
  }
}
