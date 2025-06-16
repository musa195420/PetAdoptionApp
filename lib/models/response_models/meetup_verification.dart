class MeetupVerification {
  final String meetupId;
  final String? adopterVerificationStatus;
  final String? paymentStatus;
  final String? applicationId;
  final String? paymentId;

  MeetupVerification({
    required this.meetupId,
    this.adopterVerificationStatus,
    this.paymentStatus,
    this.applicationId,
    this.paymentId,
  });

  factory MeetupVerification.fromJson(Map<String, dynamic> json) {
    return MeetupVerification(
      meetupId: json['meetup_id'] as String,
      adopterVerificationStatus: json['adopter_verification_status'] as String?,
      paymentStatus: json['payment_status'] as String?,
      applicationId: json['application_id'] as String?,
      paymentId: json['payment_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'meetup_id': meetupId,
    };
    if (adopterVerificationStatus != null) {
      data['adopter_verification_status'] = adopterVerificationStatus;
    }
    if (paymentStatus != null) {
      data['payment_status'] = paymentStatus;
    }
    if (applicationId != null) {
      data['application_id'] = applicationId;
    }
    if (paymentId != null) {
      data['payment_id'] = paymentId;
    }
    return data;
  }
}
