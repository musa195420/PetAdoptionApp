class Payment {
  final String? paymentId;
  final int? amount;
  final String? userId;
  final String? meetupId;

  Payment({
    this.paymentId,
    this.amount,
    this.userId,
    this.meetupId,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      paymentId: json['payment_id'],
      amount: json['amount'],
      userId: json['user_id'],
      meetupId: json['meetup_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (paymentId != null) data['payment_id'] = paymentId;
    if (amount != null) data['amount'] = amount;
    if (userId != null) data['user_id'] = userId;
    if (meetupId != null) data['meetup_id'] = meetupId;

    return data;
  }
}
