import 'package:petadoption/models/base_model.dart';

class RefreshTokenResponse extends IBaseModel<RefreshTokenResponse> {
  int? success;
  String? message;
  String? accessToken;
  String? refreshToken;

  RefreshTokenResponse({
    this.success,
    this.message,
    this.accessToken,
    this.refreshToken,
  });

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      RefreshTokenResponse(
        success: json["success"],
        message: json["message"],
        accessToken: json["accessToken"],
        refreshToken: json["refreshToken"],
      );

  @override
  RefreshTokenResponse fromJson(Map<String, dynamic> json) =>
      RefreshTokenResponse.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "accessToken": accessToken,
        "refreshToken": refreshToken,
      };
}
