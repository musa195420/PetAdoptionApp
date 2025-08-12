// secure_meetup.dart

import 'package:petadoption/models/response_models/meetup.dart';

class SecureMeetup {
  String? secureMeetupId;
  String? meetupId;
  String? proofPicUrl;
  String? adopterIdFrontUrl;
  String? adopterIdBackUrl;
  String? phoneNumber;
  String? currentAddress;
  String? time;
  String? submittedBy;
  String? approval;
  String? rejectionReason;

  Meetup? meetupinfo;

  SecureMeetup(
      {this.secureMeetupId,
      this.meetupId,
      this.proofPicUrl,
      this.adopterIdFrontUrl,
      this.adopterIdBackUrl,
      this.phoneNumber,
      this.currentAddress,
      this.time,
      this.submittedBy,
      this.approval,
      this.rejectionReason});

  factory SecureMeetup.fromJson(Map<String, dynamic> json) {
    return SecureMeetup(
      secureMeetupId: json['secure_meetup_id'],
      meetupId: json['meetup_id'],
      proofPicUrl: json['proof_pic_url'],
      adopterIdFrontUrl: json['adopter_id_front_url'],
      adopterIdBackUrl: json['adopter_id_back_url'],
      phoneNumber: json['phone_number'],
      currentAddress: json['current_address'],
      time: json['time'],
      submittedBy: json['submitted_by'],
      approval: json['approval'],
      rejectionReason: json['rejection_reason'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    if (secureMeetupId != null) data['secure_meetup_id'] = secureMeetupId;
    if (meetupId != null) data['meetup_id'] = meetupId;
    if (proofPicUrl != null) data['proof_pic_url'] = proofPicUrl;
    if (adopterIdFrontUrl != null)
      data['adopter_id_front_url'] = adopterIdFrontUrl;
    if (adopterIdBackUrl != null)
      data['adopter_id_back_url'] = adopterIdBackUrl;
    if (phoneNumber != null) data['phone_number'] = phoneNumber;
    if (currentAddress != null) data['current_address'] = currentAddress;
    if (time != null) data['time'] = time;
    if (submittedBy != null) data['submitted_by'] = submittedBy;
    if (approval != null) data['approval'] = approval;
    if (rejectionReason != null) data['rejection_reason'] = rejectionReason;

    return data;
  }
}
