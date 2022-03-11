import 'dart:developer';

import 'package:rewes/DBcollect/constant.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:rewes/DBcollect/MongoDBModel.dart';

class Mongodatabase {
  static var db, userCollection;
  static connect() async {
    db = await Db.create(MONGO_CONN_URL);
    await db.open();
    inspect(db);
    userCollection = db.collection(USER_COLLECTION);
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final arrData = await userCollection.find().toList();
    return arrData;
  }

  static Future<String> insert(MongoDbModel data) async {
    try {
      var result = await userCollection.insertOne(data.toJson());
      if (result.isSuccess) {
        return "Data Inserted";
      } else {
        return "Something wrong while inserting data";
      }
      // ignore: dead_code
      return result;
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }
}
