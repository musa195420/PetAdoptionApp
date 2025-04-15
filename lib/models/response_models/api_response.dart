import 'package:petadoption/models/base_model.dart';

class ApiResponse extends IBaseModel<ApiResponse> {
  bool? success;
  String? message;
  num? responseStatusCode;
  dynamic data;
  String? exception;
  String? code;
  String? elapsedTime;
  num? totalRecords;

  ApiResponse({
    required this.success,
    required this.message,
    required this.responseStatusCode,
    required this.data,
    required this.exception,
    required this.code,
    required this.elapsedTime,
    required this.totalRecords,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
        success: json["success"],
        message: json["message"],
        responseStatusCode: json["responseStatusCode"],
        data: json["data"],
        exception: json["exception"],
        code: json["code"],
        elapsedTime: json["elapsedTime"],
        totalRecords: json["totalRecords"],
      );

  @override
  ApiResponse fromJson(Map<String, dynamic> json) => ApiResponse.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "responseStatusCode": responseStatusCode,
        "data": data,
        "exception": exception,
        "code": code,
        "elapsedTime": elapsedTime,
        "totalRecords": totalRecords,
      };
}
