class VerificationMeetup {
  String? meetupId;
  String? donorVerificationStatus;
  String? adopterVerificationStatus;
  bool? adopterVerificationRequest;
  bool? donorVerificationRequest;

  VerificationMeetup({
    this.meetupId,
    this.donorVerificationStatus,
    this.adopterVerificationStatus,
    this.adopterVerificationRequest,
    this.donorVerificationRequest,
  });

  /// Construct from Supabase / JSON response
  factory VerificationMeetup.fromJson(Map<String, dynamic> json) {
    return VerificationMeetup(
      meetupId: json['meetup_id'] as String?,
      donorVerificationStatus: json['donor_verification_status'] as String?,
      adopterVerificationStatus: json['adopter_verification_status'] as String?,
      adopterVerificationRequest: json['adopter_verification_request'] as bool?,
      donorVerificationRequest: json['donor_verification_request'] as bool?,
    );
  }

  /// Serialize to JSON / map, omitting nulls (handy for `supabase.from().insert()`).
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (meetupId != null) data['meetup_id'] = meetupId;
    if (donorVerificationStatus != null) {
      data['donor_verification_status'] = donorVerificationStatus;
    }
    if (adopterVerificationStatus != null) {
      data['adopter_verification_status'] = adopterVerificationStatus;
    }
    if (adopterVerificationRequest != null) {
      data['adopter_verification_request'] = adopterVerificationRequest;
    }
    if (donorVerificationRequest != null) {
      data['donor_verification_request'] = donorVerificationRequest;
    }
    return data;
  }
}
