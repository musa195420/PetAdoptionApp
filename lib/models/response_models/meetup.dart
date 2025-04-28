class Meetup {
  String? meetupId;
  String? petId;
  String? donorId;
  String? adopterId;
  String? location;
  String? time;
  bool? isAcceptedByDonor;
  bool? isAcceptedByAdopter;
  String? createdAt;
  String? adopterName;
  String? donorName;
  String? petName;

  Meetup({
    this.meetupId,
    this.petId,
    this.donorId,
    this.adopterId,
    this.location,
    this.time,
    this.isAcceptedByDonor,
    this.isAcceptedByAdopter,
    this.createdAt,
    this.adopterName,
    this.donorName,
    this.petName,
  });

  factory Meetup.fromJson(Map<String, dynamic> json) {
    return Meetup(
      meetupId: json['meetup_id'] as String?,
      petId: json['pet_id'] as String?,
      donorId: json['donor_id'] as String?,
      adopterId: json['adopter_id'] as String?,
      location: json['location'] as String?,
      time: json['time'] as String?,
      isAcceptedByDonor: json['is_accepted_by_donor'] as bool?,
      isAcceptedByAdopter: json['is_accepted_by_adopter'] as bool?,
      createdAt: json['created_at'] as String?,
      adopterName: json['adopter_name'] as String?,
      donorName: json['donor_name'] as String?,
      petName: json['pet_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (meetupId != null) data['meetup_id'] = meetupId;
    if (petId != null) data['pet_id'] = petId;
    if (donorId != null) data['donor_id'] = donorId;
    if (adopterId != null) data['adopter_id'] = adopterId;
    if (location != null) data['location'] = location;
    if (time != null) data['time'] = time;
    if (isAcceptedByDonor != null) data['is_accepted_by_donor'] = isAcceptedByDonor;
    if (isAcceptedByAdopter != null) data['is_accepted_by_adopter'] = isAcceptedByAdopter;
    if (createdAt != null) data['created_at'] = createdAt;
    if (adopterName != null) data['adopter_name'] = adopterName;
    if (donorName != null) data['donor_name'] = donorName;
    if (petName != null) data['pet_name'] = petName;
    return data;
  }
}
