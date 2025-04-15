import 'package:petadoption/models/base_model.dart';

class LogData extends IBaseModel<LogData>  {
    String? fileName;
    String? data;
    String? date;

    LogData({
        this.fileName,
        this.data,
        this.date
    });

    factory LogData.fromJson(Map<String, dynamic> json) => LogData(
        fileName: json["fileName"],
        data: json["data"],
        date: json["date"],
    );

 @override
  LogData fromJson(Map<String, dynamic> json) => LogData.fromJson(json);

  @override
    Map<String, dynamic> toJson() => {
        "fileName": fileName,
        "data": data,
        "date": date,
    };
}
