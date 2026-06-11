import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/app_controller.dart';
import '../../app/aurae_app.dart';
import '../../app/aurae_theme.dart';
import '../../core/payment/payment_gateway.dart';
import '../../core/payment/payment_models.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    super.key,
    required this.plan,
    this.gateway = const DemoPaymentGateway(),
  });

  final PremiumPlan plan;
  final PaymentGateway gateway;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentMethodType selectedMethod = PaymentMethodType.googlePlay;
  bool acceptedTerms = false;
  bool processing = false;

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final Indonesian = controller.isIndonesian;

    return Scaffold(
      appBar: AppBar(
        title: Text(Indonesian ? 'Pembayaran' : 'Payment'),
        titleTextStyle: Theme.of(context).textTheme.titleLarge,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 150),
        children: [
          const _DemoNotice(),
          const SizedBox(height: 24),
          Text(
            Indonesian ? 'Ringkasan pesanan' : 'Order summary',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 14),
          _OrderSummary(plan: widget.plan, Indonesian: Indonesian),
          const SizedBox(height: 30),
          Text(
            Indonesian ? 'Pilih metode pembayaran' : 'Choose payment method',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            Indonesian
                ? 'Data pembayaran sensitif akan diproses oleh halaman aman milik penyedia pembayaran.'
                : 'Sensitive payment details will be processed by the provider secure checkout.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AuraeColors.muted),
          ),
          const SizedBox(height: 14),
          ...PaymentMethodType.values.map(
            (method) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _PaymentMethodCard(
                method: method,
                selected: selectedMethod == method,
                Indonesian: Indonesian,
                onTap: () => setState(() => selectedMethod = method),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AuraeColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AuraeColors.outline),
            ),
            child: Row(
              children: [
                const Icon(Icons.person_outline),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Indonesian ? 'Akun Aurae' : 'Aurae account',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        controller.email,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AuraeColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: acceptedTerms,
            onChanged: processing
                ? null
                : (value) => setState(() => acceptedTerms = value ?? false),
            title: Text(
              Indonesian
                  ? 'Saya menyetujui syarat langganan dan kebijakan pembatalan.'
                  : 'I agree to the subscription terms and cancellation policy.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock_outline,
                size: 16,
                color: AuraeColors.muted,
              ),
              const SizedBox(width: 6),
              Text(
                Indonesian
                    ? 'Checkout terenkripsi dan aman'
                    : 'Secure and encrypted checkout',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AuraeColors.muted),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
          decoration: const BoxDecoration(
            color: AuraeColors.surface,
            border: Border(top: BorderSide(color: AuraeColors.outline)),
          ),
          child: FilledButton(
            onPressed: processing ? null : () => _pay(controller, Indonesian),
            child: processing
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    Indonesian
                        ? 'Bayar ${widget.plan.formattedPrice}'
                        : 'Pay ${widget.plan.formattedPrice}',
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _pay(AppController controller, bool Indonesian) async {
    if (!acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            Indonesian
                ? 'Setujui syarat langganan untuk melanjutkan.'
                : 'Accept the subscription terms to continue.',
          ),
        ),
      );
      return;
    }

    setState(() => processing = true);
    try {
      final result = await widget.gateway.createPayment(
        PaymentRequest(
          plan: widget.plan,
          method: selectedMethod,
          userId: controller.currentUser?.id ?? '',
          email: controller.email,
        ),
      );
      if (!mounted) return;

      if (result.status == PaymentStatus.paid) {
        controller.activatePremium(
          planId: widget.plan.id,
          transactionId: result.transactionId,
        );
        HapticFeedback.mediumImpact();
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) =>
                PaymentSuccessScreen(plan: widget.plan, result: result),
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            Indonesian
                ? 'Pembayaran belum dapat diproses. Coba lagi.'
                : 'The payment could not be processed. Try again.',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => processing = false);
    }
  }
}

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({
    super.key,
    required this.plan,
    required this.result,
  });

  final PremiumPlan plan;
  final PaymentResult result;

  @override
  Widget build(BuildContext context) {
    final Indonesian = AppScope.of(context).isIndonesian;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 92,
                height: 92,
                decoration: const BoxDecoration(
                  color: AuraeColors.sage,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 50),
              ),
              const SizedBox(height: 28),
              Text(
                Indonesian ? 'Pembayaran berhasil' : 'Payment successful',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 12),
              Text(
                Indonesian
                    ? 'Paket ${plan.name} sudah aktif. Selamat menikmati pengalaman Aurae Premium.'
                    : 'Your ${plan.name} plan is active. Enjoy the Aurae Premium experience.',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AuraeColors.muted),
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AuraeColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    _DetailRow(
                      label: Indonesian ? 'Paket' : 'Plan',
                      value: plan.name,
                    ),
                    const SizedBox(height: 10),
                    _DetailRow(
                      label: Indonesian ? 'Total' : 'Total',
                      value: plan.formattedPrice,
                    ),
                    const SizedBox(height: 10),
                    _DetailRow(
                      label: 'Transaction ID',
                      value: result.transactionId,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
                child: Text(
                  Indonesian ? 'Mulai gunakan Premium' : 'Start using Premium',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DemoNotice extends StatelessWidget {
  const _DemoNotice();

  @override
  Widget build(BuildContext context) {
    final Indonesian = AppScope.of(context).isIndonesian;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AuraeColors.sage,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.science_outlined),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              Indonesian
                  ? 'Mode demo: tidak ada uang yang ditagihkan.'
                  : 'Demo mode: no money will be charged.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({required this.plan, required this.Indonesian});

  final PremiumPlan plan;
  final bool Indonesian;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AuraeColors.rose,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_awesome),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(plan.name, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(plan.description(Indonesian)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                plan.formattedPrice,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(
                plan.periodLabel(Indonesian),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AuraeColors.muted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({
    required this.method,
    required this.selected,
    required this.Indonesian,
    required this.onTap,
  });

  final PaymentMethodType method;
  final bool selected;
  final bool Indonesian;
  final VoidCallback onTap;

  IconData get icon {
    return switch (method) {
      PaymentMethodType.googlePlay => Icons.play_circle_outline,
      PaymentMethodType.qris => Icons.qr_code_2,
      PaymentMethodType.eWallet => Icons.account_balance_wallet_outlined,
      PaymentMethodType.virtualAccount => Icons.account_balance_outlined,
      PaymentMethodType.card => Icons.credit_card,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      label: method.title(Indonesian),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected ? AuraeColors.rose : AuraeColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? AuraeColors.ink : AuraeColors.outline,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(icon),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method.title(Indonesian),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      method.subtitle(Indonesian),
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AuraeColors.muted),
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? AuraeColors.ink : Colors.transparent,
                  border: Border.all(
                    color: selected ? AuraeColors.ink : AuraeColors.outline,
                    width: 1.5,
                  ),
                ),
                child: selected
                    ? const Icon(Icons.check, size: 15, color: Colors.white)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(label)),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ],
    );
  }
}
