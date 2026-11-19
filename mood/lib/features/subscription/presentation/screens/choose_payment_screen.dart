import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../onboarding/presentation/theme/onboarding_colors.dart';
import '../../../onboarding/presentation/widgets/social_brand_icons.dart';
import '../providers/subscription_provider.dart';

/// Choose Payment Methods screen matching 61_Light_choose payment methods.
class ChoosePaymentScreen extends ConsumerWidget {
  const ChoosePaymentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sub = ref.watch(subscriptionProvider);
    final notifier = ref.read(subscriptionProvider.notifier);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7F8),
        body: SafeArea(
          child: Column(
            children: [
              // Top Bar: Back | "Choose Payment Methods" | +
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/upgrade-plan');
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
                        'Choose Payment Methods',
                        textAlign: TextAlign.center,
                        style: AppTypography.titleLarge.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: OnboardingColors.textDark,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Add new payment method coming soon!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.add_rounded,
                        size: 26,
                        color: OnboardingColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),

              // Payment Method Cards
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  itemCount: availablePaymentMethods.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final method = availablePaymentMethods[index];
                    final isSelected = sub.selectedPaymentId == method.id;

                    return GestureDetector(
                      onTap: () => notifier.selectPayment(method.id),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: OnboardingColors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? OnboardingColors.primaryGreen
                                : OnboardingColors.borderLight
                                    .withValues(alpha: 0.7),
                            width: isSelected ? 1.6 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            PaymentMethodBadge(methodId: method.id),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    method.name,
                                    style: AppTypography.titleMedium.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: OnboardingColors.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    method.subtitle,
                                    style: AppTypography.label.copyWith(
                                      fontSize: 12,
                                      color: OnboardingColors.textMuted,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedOpacity(
                              opacity: isSelected ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 150),
                              child: const Icon(
                                Icons.check_rounded,
                                color: OnboardingColors.primaryGreen,
                                size: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Bottom Continue CTA
              Container(
                color: OnboardingColors.white,
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () => context.push('/review-summary'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: OnboardingColors.primaryGreen,
                      foregroundColor: Colors.white,
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
                        color: Colors.white,
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

/// Reusable circular brand icon badge for each payment method.
class PaymentMethodBadge extends StatelessWidget {
  final String methodId;

  const PaymentMethodBadge({super.key, required this.methodId});

  @override
  Widget build(BuildContext context) {
    switch (methodId) {
      case 'paypal':
        return Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            color: Color(0xFFF3F6FA),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Text(
            'P',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              color: Color(0xFF003087),
            ),
          ),
        );
      case 'google_pay':
        return Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            color: Color(0xFFF6F7F8),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const GoogleLogoIcon(size: 22),
        );
      case 'apple_pay':
        return Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            color: Color(0xFFF6F7F8),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.apple,
            size: 24,
            color: OnboardingColors.textDark,
          ),
        );
      case 'mastercard':
        return Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            color: Color(0xFF111827),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: SizedBox(
            width: 26,
            height: 16,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEB001B),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF79E1B).withValues(alpha: 0.92),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      case 'visa':
        return Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            color: Color(0xFF1A1F71),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Text(
            'VISA',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              color: Colors.white,
              letterSpacing: 0.4,
            ),
          ),
        );
      case 'amex':
      default:
        return Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            color: Color(0xFF006FCF),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Text(
            'AMEX',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
        );
    }
  }
}
