class UserVerification {
  final String? cnicPic;
  final String? proofOfResidence;
  final String? verificationId;
  final String? userId;
  final String? address;

  UserVerification({
    this.verificationId,
    this.userId,
    this.cnicPic,
    this.address,
    this.proofOfResidence,
  });

  factory UserVerification.fromJson(Map<String, dynamic> json) {
    return UserVerification(
      verificationId: json['verification_id'],
      userId: json['user_id'],
      cnicPic: json['cnic_pic'],
      address: json['address'],
      proofOfResidence: json['proof_of_residence'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (verificationId != null) data['verification_id'] = verificationId;
    if (userId != null) data['user_id'] = userId;
    if (cnicPic != null) data['cnic_pic'] = cnicPic;
    if (address != null) data['address'] = address;
    if (proofOfResidence != null) {
      data['proof_of_residence'] = proofOfResidence;
    }

    return data;
  }

  UserVerification copyWithModel(UserVerification other) {
    return UserVerification(
      verificationId: other.verificationId ?? verificationId,
      userId: other.userId ?? userId,
      cnicPic: other.cnicPic ?? cnicPic,
      proofOfResidence: other.proofOfResidence ?? proofOfResidence,
      address: other.address ?? address,
    );
  }
}
