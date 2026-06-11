enum BillingPeriod { monthly, yearly }

class PremiumPlan {
  const PremiumPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.period,
    required this.descriptionId,
    required this.descriptionEn,
  });

  final String id;
  final String name;
  final int price;
  final BillingPeriod period;
  final String descriptionId;
  final String descriptionEn;

  String description(bool Indonesian) =>
      Indonesian ? descriptionId : descriptionEn;

  String periodLabel(bool Indonesian) {
    return switch (period) {
      BillingPeriod.monthly => Indonesian ? '/bulan' : '/month',
      BillingPeriod.yearly => Indonesian ? '/tahun' : '/year',
    };
  }

  String get formattedPrice {
    final digits = price.toString();
    final buffer = StringBuffer();
    for (var index = 0; index < digits.length; index++) {
      if (index > 0 && (digits.length - index) % 3 == 0) buffer.write('.');
      buffer.write(digits[index]);
    }
    return 'Rp $buffer';
  }
}

const premiumPlans = [
  PremiumPlan(
    id: 'essential_monthly',
    name: 'Essential',
    price: 49000,
    period: BillingPeriod.monthly,
    descriptionId: 'Fitur styling dasar untuk memulai.',
    descriptionEn: 'Core styling features to get started.',
  ),
  PremiumPlan(
    id: 'premier_monthly',
    name: 'Premier',
    price: 129000,
    period: BillingPeriod.monthly,
    descriptionId: 'Pengalaman Aurae lengkap tanpa batas.',
    descriptionEn: 'The complete, limitless Aurae experience.',
  ),
  PremiumPlan(
    id: 'premier_annual',
    name: 'Annual',
    price: 990000,
    period: BillingPeriod.yearly,
    descriptionId: 'Premier setahun dengan harga terbaik.',
    descriptionEn: 'A full year of Premier at the best value.',
  ),
];

enum PaymentMethodType { googlePlay, qris, eWallet, virtualAccount, card }

extension PaymentMethodTypeLabel on PaymentMethodType {
  String title(bool Indonesian) {
    return switch (this) {
      PaymentMethodType.googlePlay => 'Google Play',
      PaymentMethodType.qris => 'QRIS',
      PaymentMethodType.eWallet => 'E-Wallet',
      PaymentMethodType.virtualAccount =>
        Indonesian ? 'Virtual Account' : 'Virtual Account',
      PaymentMethodType.card => Indonesian ? 'Kartu' : 'Card',
    };
  }

  String subtitle(bool Indonesian) {
    return switch (this) {
      PaymentMethodType.googlePlay =>
        Indonesian
            ? 'Pembayaran langganan resmi Android'
            : 'Official Android subscription payment',
      PaymentMethodType.qris =>
        Indonesian
            ? 'Bayar melalui aplikasi bank atau dompet digital'
            : 'Pay with a banking or wallet application',
      PaymentMethodType.eWallet =>
        Indonesian
            ? 'GoPay, DANA, OVO, dan penyedia lain'
            : 'GoPay, DANA, OVO, and other providers',
      PaymentMethodType.virtualAccount =>
        Indonesian
            ? 'Transfer melalui nomor virtual account'
            : 'Transfer through a virtual account number',
      PaymentMethodType.card =>
        Indonesian
            ? 'Diproses pada halaman aman milik gateway'
            : 'Processed on the gateway secure checkout',
    };
  }
}

enum PaymentStatus { paid, pending, failed }

class PaymentRequest {
  const PaymentRequest({
    required this.plan,
    required this.method,
    required this.userId,
    required this.email,
  });

  final PremiumPlan plan;
  final PaymentMethodType method;
  final String userId;
  final String email;
}

class PaymentResult {
  const PaymentResult({
    required this.transactionId,
    required this.status,
    this.checkoutUrl,
  });

  final String transactionId;
  final PaymentStatus status;
  final Uri? checkoutUrl;
}
