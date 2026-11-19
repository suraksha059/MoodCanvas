import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentMethodOption {
  final String id;
  final String name;
  final String subtitle;

  const PaymentMethodOption({
    required this.id,
    required this.name,
    required this.subtitle,
  });
}

const List<PaymentMethodOption> availablePaymentMethods = [
  PaymentMethodOption(
    id: 'paypal',
    name: 'PayPal',
    subtitle: 'andrew.ainsley@yourdomain.com',
  ),
  PaymentMethodOption(
    id: 'google_pay',
    name: 'Google Pay',
    subtitle: 'andrew.ainsley@yourdomain.com',
  ),
  PaymentMethodOption(
    id: 'apple_pay',
    name: 'Apple Pay',
    subtitle: 'andrew.ainsley@yourdomain.com',
  ),
  PaymentMethodOption(
    id: 'mastercard',
    name: 'Mastercard',
    subtitle: '•••• •••• •••• 4679',
  ),
  PaymentMethodOption(
    id: 'visa',
    name: 'Visa',
    subtitle: '•••• •••• •••• 5567',
  ),
  PaymentMethodOption(
    id: 'amex',
    name: 'American Express',
    subtitle: '•••• •••• •••• 8456',
  ),
];

class SubscriptionState {
  final bool isYearly;
  final String selectedPaymentId;
  final bool isPremium;

  const SubscriptionState({
    this.isYearly = true,
    this.selectedPaymentId = 'mastercard',
    this.isPremium = false,
  });

  String get priceLabel => isYearly ? '\$49.99' : '\$4.99';
  String get periodLabel => isYearly ? '/ year' : '/ month';

  PaymentMethodOption get selectedPayment => availablePaymentMethods.firstWhere(
        (m) => m.id == selectedPaymentId,
        orElse: () => availablePaymentMethods[3],
      );

  SubscriptionState copyWith({
    bool? isYearly,
    String? selectedPaymentId,
    bool? isPremium,
  }) {
    return SubscriptionState(
      isYearly: isYearly ?? this.isYearly,
      selectedPaymentId: selectedPaymentId ?? this.selectedPaymentId,
      isPremium: isPremium ?? this.isPremium,
    );
  }
}

class SubscriptionNotifier extends Notifier<SubscriptionState> {
  @override
  SubscriptionState build() => const SubscriptionState();

  void setYearly(bool yearly) => state = state.copyWith(isYearly: yearly);
  void selectPayment(String id) =>
      state = state.copyWith(selectedPaymentId: id);
  void activatePremium() => state = state.copyWith(isPremium: true);
}

final subscriptionProvider =
    NotifierProvider<SubscriptionNotifier, SubscriptionState>(
  SubscriptionNotifier.new,
);
