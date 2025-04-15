import 'package:hive/hive.dart';
import 'package:petadoption/models/base_model.dart';

part 'user.g.dart';

@HiveType(typeId: 43)
class User extends IHiveBaseModel<User> {
  @HiveField(0)
  String userId;

  @HiveField(1)
  String email;

  @HiveField(2)
  String phoneNumber;

  @HiveField(3)
  String password;

  @HiveField(4)
  String role;

  @HiveField(5)
  String deviceId;

  User({
    required this.userId,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.role,
    required this.deviceId,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["user_id"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        password: json["password"],
        role: json["role"],
        deviceId: json["device_id"],
      );

  @override
  User fromJson(Map<String, dynamic> json) => User.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "email": email,
        "phone_number": phoneNumber,
        "password": password,
        "role": role,
        "device_id": deviceId,
      };
}
