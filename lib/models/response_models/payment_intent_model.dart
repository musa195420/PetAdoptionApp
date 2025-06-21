class PaymentIntentRequest {
  final int amount; // In rupees
  final String meetupId;

  PaymentIntentRequest({required this.amount, required this.meetupId});

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'meetup_id': meetupId,
      };
}

// lib/models/payment_intent_response.dart
class PaymentIntentResponse {
  final String clientSecret; // Stripe client‑secret
  final int amount; // Echo from server (in rupees)
  PaymentIntentResponse({required this.clientSecret, required this.amount});

  factory PaymentIntentResponse.fromJson(Map<String, dynamic> json) =>
      PaymentIntentResponse(
        clientSecret: json['client_secret'] as String,
        amount: json['amount'] as int,
      );
}
