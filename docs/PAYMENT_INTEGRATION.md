# Payment Gateway Integration

The current checkout uses `DemoPaymentGateway`. It never sends money or payment
credentials and exists to validate the product flow.

## Production contract

Implement `PaymentGateway` with a trusted backend:

1. Flutter sends the authenticated user ID, plan ID, and payment method to a
   backend endpoint.
2. The backend validates the Firebase ID token and reads the authoritative plan
   price from server-side configuration.
3. The backend creates the payment with the selected provider using a secret
   server key.
4. The backend returns a hosted checkout URL, payment token, or platform billing
   session.
5. The provider calls a backend webhook after payment changes state.
6. The backend verifies the webhook signature and writes entitlement data to
   `users/{uid}`.
7. Flutter observes that entitlement and unlocks Premium.

Never place a payment gateway server key in the Flutter application. Never
activate Premium based only on a client callback.

## Suggested entitlement fields

```text
users/{uid}
  subscriptionTier: "premier"
  subscriptionStatus: "active"
  subscriptionPlanId: "premier_monthly"
  subscriptionProvider: "google_play" | "gateway"
  subscriptionTransactionId: "..."
  entitlementExpiresAt: Timestamp
  updatedAt: Timestamp
```

## Android distribution

Premium styling is a digital subscription. Confirm the current Google Play
billing and alternative-billing requirements for every distribution channel
before enabling external payment methods in a production Play Store build.
