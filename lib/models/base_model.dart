
import 'package:hive/hive.dart';

abstract class IBaseModel<T> {
  Map<String, dynamic> toJson();
  T fromJson(Map<String, dynamic> json);
  bool _selected=false;
  bool get selected => _selected;
  setSelected(bool selected) async {
    _selected = selected;
  }
}

abstract class IHiveBaseModel<T> extends HiveObject {
  Map<String, dynamic> toJson();
  T fromJson(Map<String, dynamic> json);
  bool _selected=false;
  bool get selected => _selected;
  setSelected(bool selected) async {
    _selected = selected;
  }
}