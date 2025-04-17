class ErrorResponse {
  bool? success;
  int? status;
  String? message;
  String? error;
  String? errorCode;

  ErrorResponse({
    this.success,
    this.status,
    this.message,
    this.error,
    this.errorCode,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      success: json['success'] as bool?,
      status: json['status'] as int?,
      message: json['message'] as String?,
      error: json['error'] as String?,
      errorCode: json['errorCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'status': status,
      'message': message,
      'error': error,
      'errorCode':errorCode,
    };
  }
}