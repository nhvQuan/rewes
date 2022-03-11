// To parse this JSON data, do
//
//     final mongoDbModel = mongoDbModelFromJson(jsonString);

import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

MongoDbModel mongoDbModelFromJson(String str) =>
    MongoDbModel.fromJson(json.decode(str));

String mongoDbModelToJson(MongoDbModel data) => json.encode(data.toJson());

class MongoDbModel {
  MongoDbModel({
    required this.statusStation,
    required this.date,
    // required this.realtime,
    required this.tempC,
    required this.humi,
    required this.cps,
    required this.uSv,
    required this.id,
  });
  String id;
  String statusStation;
  var date;
  // String realtime;
  var tempC;
  var humi;
  var cps;
  String uSv;

  factory MongoDbModel.fromJson(Map<String, dynamic> json) => MongoDbModel(
        statusStation: json["statusStation"],
        date: json["date"],
        // realtime: json["realtime"],
        tempC: json["tempC"],
        humi: json["humi"],
        cps: json["cps"],
        uSv: json["uSv"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "statusStation": statusStation,
        //"date": date,
        // "realtime": realtime,
        "tempC": tempC,
        "humi": humi,
        "cps": cps,
        "uSv": uSv,
        "id": id,
      };
}
