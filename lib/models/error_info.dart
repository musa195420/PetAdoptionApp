


import 'package:petadoption/models/base_model.dart';
class ErrorInfo extends IBaseModel<ErrorInfo> {
    String errorCode;
    String shortError;
    String detail;
    int action;
    int titleResource;
    int messageResource;

    ErrorInfo({
        required this.errorCode,
        required this.shortError,
        required this.detail,
        required this.action,
        required this.titleResource,
        required this.messageResource,
    });

    factory ErrorInfo.fromJson(Map<String, dynamic> json) => ErrorInfo(
        errorCode: json["errorCode"],
        shortError: json["shortError"],
        detail: json["detail"],
        action: json["action"],
        titleResource: json["TitleResource"],
        messageResource: json["messageResource"],
    );

    @override
  ErrorInfo fromJson(Map<String, dynamic> json) => ErrorInfo.fromJson(json);

@override
    Map<String, dynamic> toJson() => {
        "errorCode": errorCode,
        "shortError": shortError,
        "detail": detail,
        "action": action,
        "TitleResource": titleResource,
        "messageResource": messageResource,
    };
}
