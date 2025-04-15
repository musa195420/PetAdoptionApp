import 'package:hive/hive.dart';
import 'package:petadoption/models/base_model.dart';


part 'g/api_queue.g.dart';

@HiveType(typeId: 42)
class APIQueue extends IHiveBaseModel<APIQueue> {
  @HiveField(0)
  String id;
  @HiveField(1)
  dynamic data;
  @HiveField(2)
  num type;
  @HiveField(3)
  bool printed;
  @HiveField(4)
  dynamic param;

  dynamic keyId;

  APIQueue({ required this.printed, this.param='',
    required this.id,
    required this.data,
    required this.type, this.keyId,
  });

  factory APIQueue.fromJson(Map<String, dynamic> json) => APIQueue(
        id: json["id"],
        printed: json["printed"],
        data: json["data"],
        type: json["type"],
        keyId: json["keyId"],
        param: json["param"],
      );

  @override
  APIQueue fromJson(Map<String, dynamic> json) =>
      APIQueue.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "data": data,
        "type": type,
        "printed": printed,
        "keyId": keyId,
        "param": param,
      };
}