
import 'dart:ui';

class Message {
  String okText="Ok";
  String cancelText="Cancel";
  String title;
  
  String description;
  List<String?>? items;
  List<Item?>? bottomSheetItems;


  Message({this.bottomSheetItems, this.items, this.okText="Ok", this.cancelText="Cancel", this.title="Alert", required this.description});

}

class Item {
  String? text1;
  String? icon;
  String? text2;
  Color? iconcolor;
  num? functionButtonActionType;
  String param;

  Item({this.functionButtonActionType,this.text1,this.icon, this.text2, this.iconcolor, this.param=""});

}