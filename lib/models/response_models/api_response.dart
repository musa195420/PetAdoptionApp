import 'package:petadoption/models/base_model.dart';

class ApiResponse extends IBaseModel<ApiResponse> {
  bool? success;
  String? message;
  num? responseStatusCode;
  dynamic data;
  String? exception;
  String? error;
  String? elapsedTime;
  num? totalRecords;
  num? status;

  ApiResponse({
    required this.success,
    required this.message,
    required this.responseStatusCode,
    required this.data,
    required this.exception,
    required this.error,
    required this.elapsedTime,
    required this.totalRecords,
    this.status,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
        success: json["success"],
        message: json["message"],
        responseStatusCode: json["responseStatusCode"],
        data: json["data"],
        exception: json["exception"],
        error: json["error"],
        elapsedTime: json["elapsedTime"],
        totalRecords: json["totalRecords"],
        status: json["status"]
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
        "error": error,
        "elapsedTime": elapsedTime,
        "totalRecords": totalRecords,
        "status":status,
      };
}
