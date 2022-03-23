import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rewes/screens/MongoDBModel.dart';

import 'package:rewes/widgets/StationItem.dart';
import 'package:rewes/screens/mongoose.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:rewes/json/geolocation.dart';
import 'package:rewes/json/station.dart';
import 'package:rewes/json/stationdata.dart';
import 'package:rewes/main.dart';
import 'package:rewes/screens/home_screen.dart';
import 'package:rewes/screens/Detail_station.dart';

import 'package:rewes/screens/mongo_data.dart';
import 'package:rewes/screens/MongoDBModel.dart';

late var USER_COLLECTIONS;

class MongoDB extends StatefulWidget {
  const MongoDB({
    Key? key,
  }) : super(key: key);
  static const nameRoute = '/Infor';
  // User=_stationData.statusStation;
  @override
  _MongoDBState createState() => _MongoDBState();
}

class _MongoDBState extends State<MongoDB> {
  @override
  Widget build(BuildContext context) {
    final _stationData =
        ModalRoute.of(context)!.settings.arguments as StationData;
    USER_COLLECTIONS = _stationData.statusStation;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: FutureBuilder(
            future: Mongodatabase.getData(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.hasData) {
                  var totalData = snapshot.data.length;
                  print("Total Data" + totalData.toString());
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Displaycard(
                            MongoDbModel.fromJson(snapshot.data[index]));
                      });
                } else {
                  return Center(
                    child:
                        Text("No Data Available ${_stationData.statusStation}"),
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }

  Widget Displaycard(MongoDbModel data) {
    final _stationData =
        ModalRoute.of(context)!.settings.arguments as StationData;
    if (data.statusStation == _stationData.statusStation) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                  "${data.statusStation}, ${data.date}, ${data.cps} cps, ${data.uSv} µSv/h \n ${data.tempC} °C, ${data.humi} %"),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
