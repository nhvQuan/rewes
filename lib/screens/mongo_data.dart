import 'package:mongo_dart/mongo_dart.dart';
import 'dart:developer';

const MONGO_CONN_URL =
    "mongodb+srv://Rewes_2022:Rewes_2022@rewes.hvpsx.mongodb.net/ESP?retryWrites=true&w=majority";

class Mongodatabase {
  static var db, userCollection;
  static connect() async {
    db = await Db.create(MONGO_CONN_URL);
    await db.open();
    inspect(db);
    userCollection = db.collection("Data");
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final arrData = await userCollection.find().toList();
    return arrData;
  }

  static Future<List<Map<String, dynamic>>> getDatacps() async {
    final arrData = await userCollection.find("cps").toList();
    return arrData;
  }
}
