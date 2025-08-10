import 'package:petadoption/models/request_models/application_model.dart';
import 'package:petadoption/models/response_models/meetup_verification.dart';
import 'package:petadoption/models/response_models/payment.dart';
import 'package:petadoption/models/response_models/user_verification.dart';

class Meetup {
  String? userId;

  String? location;
  String? latitude;
  String? longitude;
  String? receiverId;
  String? meetupId;
  String? petId;
  String? donorId;
  String? adopterId;
  String? time;
  bool? isAcceptedByDonor;
  bool? isAcceptedByAdopter;
  String? createdAt;
  String? adopterName;
  String? donorName;
  String? petName;
  String? addVerification;
  String? rejectionReason;
  String? adopterEmail; // new
  String? donorEmail; // new
  MeetupVerification? verificationmeetup;
  UserVerification? userVerification;

  ApplicationModel? application;
  Payment? paymentInfo;

  Meetup({
    this.userId,
    this.meetupId,
    this.petId,
    this.donorId,
    this.adopterId,
    this.location,
    this.latitude,
    this.longitude,
    this.time,
    this.isAcceptedByDonor,
    this.isAcceptedByAdopter,
    this.createdAt,
    this.adopterName,
    this.donorName,
    this.petName,
    this.addVerification,
    this.rejectionReason,
    this.receiverId,
    this.adopterEmail, // new
    this.donorEmail, // new
  });

  factory Meetup.fromJson(Map<String, dynamic> json) {
    return Meetup(
      userId: json['user_id'] as String?,
      meetupId: json['meetup_id'] as String?,
      petId: json['pet_id'] as String?,
      donorId: json['donor_id'] as String?,
      adopterId: json['adopter_id'] as String?,
      location: json['location'] as String?,
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
      time: json['time'] as String?,
      isAcceptedByDonor: json['is_accepted_by_donor'] as bool?,
      isAcceptedByAdopter: json['is_accepted_by_adopter'] as bool?,
      createdAt: json['created_at'] as String?,
      adopterName: json['adopter_name'] as String?,
      donorName: json['donor_name'] as String?,
      petName: json['pet_name'] as String?,
      addVerification: json['add_verification'] as String?,
      rejectionReason: json['rejection_reason'] as String?,
      receiverId: json['receiver_id'] as String?,
      adopterEmail: json['adopter_email'] as String?, // new
      donorEmail: json['donor_email'] as String?, // new
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (userId != null) data['user_id'] = userId;
    if (meetupId != null) data['meetup_id'] = meetupId;
    if (petId != null) data['pet_id'] = petId;
    if (donorId != null) data['donor_id'] = donorId;
    if (adopterId != null) data['adopter_id'] = adopterId;
    if (location != null) data['location'] = location;
    if (latitude != null) data['latitude'] = latitude;
    if (longitude != null) data['longitude'] = longitude;
    if (time != null) data['time'] = time;
    if (isAcceptedByDonor != null) {
      data['is_accepted_by_donor'] = isAcceptedByDonor;
    }
    if (isAcceptedByAdopter != null) {
      data['is_accepted_by_adopter'] = isAcceptedByAdopter;
    }
    if (createdAt != null) data['created_at'] = createdAt;
    if (adopterName != null) data['adopter_name'] = adopterName;
    if (donorName != null) data['donor_name'] = donorName;
    if (petName != null) data['pet_name'] = petName;
    if (addVerification != null) data['add_verification'] = addVerification;
    if (rejectionReason != null) data['rejection_reason'] = rejectionReason;
    if (receiverId != null) data['receiver_id'] = receiverId;
    if (adopterEmail != null) data['adopter_email'] = adopterEmail; // new
    if (donorEmail != null) data['donor_email'] = donorEmail; // new
    return data;
  }
}
