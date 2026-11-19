import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/mood_error_view.dart';
import '../../features/calendar/presentation/screens/calendar_screen.dart';
import '../../features/canvas/presentation/screens/monthly_canvas_screen.dart';
import '../../features/capture/presentation/screens/daily_capture_flow_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/insights/presentation/screens/insights_screen.dart';
import '../../features/memories/presentation/screens/memories_screen.dart';
import '../../features/memories/presentation/screens/memory_detail_screen.dart';
import '../../features/navigation/presentation/screens/main_shell_screen.dart';
import '../../features/onboarding/presentation/screens/account_setup_screen.dart';
import '../../features/onboarding/presentation/screens/create_password_screen.dart';
import '../../features/onboarding/presentation/screens/forgot_password_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/onboarding/presentation/screens/otp_verification_screen.dart';
import '../../features/onboarding/presentation/screens/reset_success_screen.dart';
import '../../features/onboarding/presentation/screens/setup_loading_screen.dart';
import '../../features/onboarding/presentation/screens/sign_in_screen.dart';
import '../../features/onboarding/presentation/screens/sign_up_screen.dart';
import '../../features/onboarding/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/welcome_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/subscription/presentation/screens/choose_payment_screen.dart';
import '../../features/subscription/presentation/screens/review_summary_screen.dart';
import '../../features/subscription/presentation/screens/upgrade_plan_screen.dart';
import '../../features/subscription/presentation/screens/upgrade_success_screen.dart';

/// Notifier tracking onboarding completion state.
class OnboardingCompletedNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void complete() => state = true;
  void reset() => state = false;
}

/// Provider managing onboarding completion status in memory.
final onboardingCompletedProvider =
    NotifierProvider<OnboardingCompletedNotifier, bool>(
  OnboardingCompletedNotifier.new,
);

/// Central GoRouter configuration for MoodCanvas.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: MoodErrorView(
        title: 'Page Not Found',
        message: 'The screen you are looking for does not exist in your memory canvas.',
        retryLabel: 'Return Home',
        onRetry: () => context.go('/home'),
      ),
    ),
    routes: [
      // 0. Splash Screen
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // 1. Onboarding Walkthrough Screen
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // 1b. Welcome / Get Started Screen
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),

      // 1c. Sign Up Screen
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),

      // 1d. 8-Step Account Setup Flow
      GoRoute(
        path: '/account-setup',
        builder: (context, state) => const AccountSetupScreen(),
      ),

      // 1e. Account Setup Loading Screen
      GoRoute(
        path: '/setup-loading',
        builder: (context, state) => const SetupLoadingScreen(),
      ),

      // 1f. Sign In & Password Reset Flow
      GoRoute(
        path: '/signin',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/otp-verification',
        builder: (context, state) => const OtpVerificationScreen(),
      ),
      GoRoute(
        path: '/create-password',
        builder: (context, state) => const CreatePasswordScreen(),
      ),
      GoRoute(
        path: '/reset-success',
        builder: (context, state) => const ResetSuccessScreen(),
      ),

      // 2. Main Navigation Shell (Persistent Floating Bottom Dock)
      ShellRoute(
        builder: (context, state, child) => MainShellScreen(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/memories',
            builder: (context, state) => const MemoriesScreen(),
          ),
          GoRoute(
            path: '/insights',
            builder: (context, state) => const InsightsScreen(),
          ),
          GoRoute(
            path: '/calendar',
            builder: (context, state) => const CalendarScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // 3. Memory Detail Screen
      GoRoute(
        path: '/memories/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return MemoryDetailScreen(entryId: id);
        },
      ),

      // 4. Monthly Canvas Screen
      GoRoute(
        path: '/monthly-canvas',
        builder: (context, state) => const MonthlyCanvasScreen(),
      ),

      // 5. Quick Mood & Canvas Capture Flow
      GoRoute(
        path: '/capture',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return DailyCaptureFlowScreen(
            initialMood: (extra?['initialMood'] as int?) ?? 3,
            initialDate: extra?['initialDate'] as DateTime?,
          );
        },
      ),

      // 6. Subscription & Upgrade Flow
      GoRoute(
        path: '/upgrade-plan',
        builder: (context, state) => const UpgradePlanScreen(),
      ),
      GoRoute(
        path: '/choose-payment',
        builder: (context, state) => const ChoosePaymentScreen(),
      ),
      GoRoute(
        path: '/review-summary',
        builder: (context, state) => const ReviewSummaryScreen(),
      ),
      GoRoute(
        path: '/upgrade-success',
        builder: (context, state) => const UpgradeSuccessScreen(),
      ),
    ],
  );
});
