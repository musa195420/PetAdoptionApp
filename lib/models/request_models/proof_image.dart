class ProofImages {
  final String meetupId;
  final String? proofPicPath;
  final String? adopterIdFrontPath;
  final String? adopterIdBackPath;

  ProofImages({
    required this.meetupId,
    this.proofPicPath,
    this.adopterIdFrontPath,
    this.adopterIdBackPath,
  });

  factory ProofImages.fromJson(Map<String, dynamic> json) {
    return ProofImages(
      meetupId: json['meetup_id'],
      proofPicPath: json['proof_pic'],
      adopterIdFrontPath: json['adopter_id_front'],
      adopterIdBackPath: json['adopter_id_back'],
    );
  }
  Map<String, String> toImageJson() {
    final map = <String, String>{};

    if (proofPicPath?.isNotEmpty ?? false) map['proof_pic'] = proofPicPath!;
    if (adopterIdFrontPath?.isNotEmpty ?? false)
      map['adopter_id_front'] = adopterIdFrontPath!;
    if (adopterIdBackPath?.isNotEmpty ?? false)
      map['adopter_id_back'] = adopterIdBackPath!;

    return map;
  }
}
