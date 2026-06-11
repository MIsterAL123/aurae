import 'payment_models.dart';

abstract interface class PaymentGateway {
  Future<PaymentResult> createPayment(PaymentRequest request);
}

class DemoPaymentGateway implements PaymentGateway {
  const DemoPaymentGateway();

  @override
  Future<PaymentResult> createPayment(PaymentRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    return PaymentResult(
      transactionId: 'DEMO-${DateTime.now().millisecondsSinceEpoch}',
      status: PaymentStatus.paid,
    );
  }
}
