import 'package:aurae_app/app/app_controller.dart';
import 'package:aurae_app/app/aurae_app.dart';
import 'package:aurae_app/app/aurae_theme.dart';
import 'package:aurae_app/core/payment/payment_gateway.dart';
import 'package:aurae_app/core/payment/payment_models.dart';
import 'package:aurae_app/features/payment/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formats Indonesian premium plan pricing', () {
    final plan = premiumPlans.firstWhere(
      (candidate) => candidate.id == 'premier_monthly',
    );

    expect(plan.formattedPrice, 'Rp 129.000');
    expect(plan.periodLabel(true), '/bulan');
    expect(plan.periodLabel(false), '/month');
  });

  test('demo gateway returns a paid transaction', () async {
    final result = await const DemoPaymentGateway().createPayment(
      PaymentRequest(
        plan: premiumPlans.first,
        method: PaymentMethodType.qris,
        userId: 'test-user',
        email: 'test@aurae.app',
      ),
    );

    expect(result.status, PaymentStatus.paid);
    expect(result.transactionId, startsWith('DEMO-'));
  });

  testWidgets('checkout activates Premium after a successful demo payment', (
    tester,
  ) async {
    final controller = AppController()
      ..authenticationReady = true
      ..locale = const Locale('id');

    await tester.pumpWidget(
      AppScope(
        controller: controller,
        child: MaterialApp(
          theme: AuraeTheme.light(),
          home: PaymentScreen(plan: premiumPlans[1]),
        ),
      ),
    );

    expect(find.text('Ringkasan pesanan'), findsOneWidget);
    expect(find.text('Rp 129.000'), findsWidgets);

    await tester.scrollUntilVisible(
      find.textContaining('Saya menyetujui'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pump();
    await tester.tap(find.text('Bayar Rp 129.000'));
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Pembayaran berhasil'), findsOneWidget);
    expect(controller.isPremium, isTrue);
    expect(controller.premiumPlanId, 'premier_monthly');
  });
}
