import 'package:petadoption/models/base_model.dart';

class RefreshTokenResponse extends IBaseModel<RefreshTokenResponse> {
  int? success;
  String? message;
  String? accessToken;
  String? refreshToken;
  String? expiresIn; // New field

  RefreshTokenResponse({
    this.success,
    this.message,
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
  });

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      RefreshTokenResponse(
        success: json["success"],
        message: json["message"],
        accessToken: json["accessToken"],
        refreshToken: json["refreshToken"],
        expiresIn: json["expiresIn"], // Read from JSON
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
        "expiresIn": expiresIn, // Add to output JSON
      };
}
