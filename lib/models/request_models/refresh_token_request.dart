

// ignore_for_file: non_constant_identifier_names

import 'package:petadoption/models/base_model.dart';

class RefreshTokenRequest extends IBaseModel<RefreshTokenRequest> {
  String? RefreshToken;

  RefreshTokenRequest({this.RefreshToken});

@override
RefreshTokenRequest fromJson(Map<String, dynamic> json) => RefreshTokenRequest.fromJson(json);

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) => RefreshTokenRequest(
        RefreshToken: json['RefreshToken'] as String?,
      );

  @override
  Map<String, dynamic> toJson() => {
        'RefreshToken': RefreshToken,
      };
}