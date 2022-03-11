import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rewes/DBcollect/MongoDBModel.dart';
import 'package:rewes/DBcollect/mongodb.dart';
import 'package:rewes/widgets/StationItem.dart';
import 'package:rewes/widgets/mongoose.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:rewes/json/geolocation.dart';
import 'package:rewes/json/station.dart';
import 'package:rewes/json/stationdata.dart';
import 'package:rewes/main.dart';
import 'package:rewes/screens/home_screen.dart';

class MongoDB extends StatefulWidget {
  const MongoDB({
    Key? key,
  }) : super(key: key);

  static const nameRoute = '/Infor';
  @override
  _MongoDBState createState() => _MongoDBState();
}

class _MongoDBState extends State<MongoDB> {
  @override
  Widget build(BuildContext context) {
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
                    child: Text("No Data Available"),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("${data.statusStation}"),
            SizedBox(
              height: 10,
            ),
            Text("${data.date}"),
            SizedBox(
              height: 10,
            ),
            Text("${data.cps} cps"),
            SizedBox(
              height: 10,
            ),
            Text("${data.uSv} µSv/h"),
            SizedBox(
              height: 10,
            ),
            Text("${data.tempC} °C"),
            SizedBox(
              height: 10,
            ),
            Text("${data.humi}"),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
