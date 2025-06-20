class MeetupVerification {
  final String? meetupId;
  final String? adopterVerificationStatus;
  final String? paymentStatus;
  final String? applicationId;
  final String? paymentId;
  final String? verificationId;

  MeetupVerification({
    this.meetupId,
    this.adopterVerificationStatus,
    this.paymentStatus,
    this.applicationId,
    this.paymentId,
    this.verificationId,
  });

  factory MeetupVerification.fromJson(Map<String, dynamic> json) {
    return MeetupVerification(
      meetupId: json['meetup_id'],
      adopterVerificationStatus: json['adopter_verification_status'],
      paymentStatus: json['payment_status'],
      applicationId: json['application_id'],
      paymentId: json['payment_id'],
      verificationId: json['verification_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (meetupId != null) data['meetup_id'] = meetupId;
    if (adopterVerificationStatus != null) {
      data['adopter_verification_status'] = adopterVerificationStatus;
    }
    if (paymentStatus != null) data['payment_status'] = paymentStatus;
    if (applicationId != null) data['application_id'] = applicationId;
    if (paymentId != null) data['payment_id'] = paymentId;
    if (verificationId != null) data['verification_id'] = verificationId;
    return data;
  }
}
