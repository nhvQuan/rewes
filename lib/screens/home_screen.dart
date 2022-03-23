import 'package:flutter/material.dart';
import 'package:rewes/constants/app_colors.dart';
import 'package:rewes/models/spending_category_model.dart';
import 'package:rewes/widgets/current_time.dart';

import 'package:rewes/widgets/StationItem.dart';
import 'package:rewes/screens/mongoose.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:rewes/json/geolocation.dart';
import 'package:rewes/json/station.dart';
import 'package:rewes/json/stationdata.dart';
import 'package:rewes/main.dart';
import 'package:intl/intl.dart';
import 'package:rewes/main.dart';

late String now;

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HompageState createState() => _HompageState();
}

late StationData station_data;

List<Station> stations = [];
// lưu dữ liệu vào trong 1 mảng
StationData stationTemp = StationData.empty();
List<StationData> stationDataList = [];

class _HompageState extends State<Homepage> {
  List<Station> stations = [];
  void initState() {
    super.initState();
    connectAndListen();
  }

  void connectAndListen() {
    print('Call func connectAndListen');
    socket.onConnect((_) {
      print('connect');
    });
    socket.on('stations', (data) {
      // hứng sự kiện 'station' từ sv
      print('from server $data');
      List<dynamic> _stations = data;
      setState(() {
        stations =
            _stations.map<Station>((json) => Station.fromJson(json)).toList();
        // datetime = DateFormat('dd-MM-yyyy KK:mm:ss').format(DateTime.now());
      });
      print(stations);
    });
    socket.on('temp2app', (data) {
      StationData station_data = StationData.fromJson(data);
      var index = stationDataList
          .indexWhere((element) => station_data.id == element.id);
      if (index > -1) {
        stationDataList[index] = station_data;
      } else {
        stationDataList.add(station_data);
      } // kiểm trang mảng có dữ liệu mới chưa

      setState(() {
        stationTemp = station_data;
      });
    });
    socket.onDisconnect((_) => print('disconnect'));
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEE, dd/MM/yyyy ').format(now);
    // String formattedDay = DateFormat('EEE').format(now);
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: size.height * 0.095,
            child: Stack(children: [
              Container(
                // color: Theme.of(context).accentColor,
                height: size.height * 0.08,
                // padding: EdgeInsets.only(left: 36, top: 12),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32)),
                    color: Theme.of(context).accentColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                ),
              ),
              Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: size.width * 0.95,
                        height: 32,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '${formattedDate}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Current_time(
                              color: Colors.white,
                            ),
                          ],
                        ),
                        // padding:
                        //     EdgeInsets.symmetric(horizontal: 32, vertical: 4),
                        decoration: BoxDecoration(
                            color: AppColors.secondaryAccent,
                            borderRadius: BorderRadius.circular(32)),
                      ),
                    ]),
              )
              // SizedBox(height: size.height*0.01,),
            ]),
          ),
          Expanded(
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 1.0,
                    mainAxisSpacing: 1.0,
                    childAspectRatio:
                        (size.width * 0.45) / (size.height * 0.2)),
                padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: stations.length,
                itemBuilder: (context, index) {
                  return StationItem(
                      item: stations[index],
                      updatedItem: stationTemp,
                      itemList: stationDataList);
                }),
          ),
        ],
      ),
    );
  }
}
