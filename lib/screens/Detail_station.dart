import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:rewes/screens/MongoDBModel.dart';
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
import 'package:rewes/screens/home_screen.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

///////////////////////
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'dart:async';
import 'dart:math' as math;

double? data1;
late StationData _stationData;
String? Y_name;
int check = 1;
double codeDialog = 0.61;
var valueText;

class Detail_Station extends StatefulWidget {
  const Detail_Station({Key? key}) : super(key: key);
  static const nameRoute = '/Detail';
  @override
  _Detail_StationState createState() => _Detail_StationState();
}

bool _lightIsOn = true;

class _Detail_StationState extends State<Detail_Station> {
  bool isLoaded = false;
  void initState() {
    super.initState();
    connectAndListen();
    chartData = getChartData();
    Timer.periodic(const Duration(seconds: 1), updateDataSource);
  }

  List<LiveData>? chartData;
  late ChartSeriesController _chartSeriesController;
  void connectAndListen() {
    print('Call func connectAndListen');
    socket.onConnect((_) {
      print('connect');
    });
    socket.on('temp2web', (data) {
      print('from server $data');
      var station = StationData.fromJson(data);
      if (mounted) {
        setState(() {
          isLoaded = true;
          _stationData = station;
          if (check == 1) {
            data1 = double.parse(_stationData.uSv);
            Y_name = 'Suất liều (µSv/h)';
          } else {
            data1 = _stationData.cps.toDouble();
            Y_name = 'Số đếm/s (cps)';
          }
        });
        print('${_stationData}');
      }
    });
    socket.onDisconnect((_) {
      Navigator.pop(context);
      if (mounted) {
        print('disconnect');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final item = ModalRoute.of(context)!.settings.arguments as Station;

    if (!isLoaded) {
      return Center(child: CircularProgressIndicator());
    } else {
      return WillPopScope(
        onWillPop: () async {
          socket.off("temp2web");
          print('socket off');
          return true;
        },
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Column(
            children: [
              Container(
                height: 150,
                child: Stack(children: [
                  Container(
                    color: Theme.of(context).accentColor,
                    height: 120,
                    padding: EdgeInsets.only(left: 36, top: 12),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: size.height * 0.02),
                        Text('Station: ${_stationData.statusStation}',
                            style: Theme.of(context).textTheme.headline3),
                        Text(
                          'Address: ${item.address}',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                              color: AppColors.secondaryAccent,
                            ),
                            child: Material(
                              borderRadius: BorderRadius.circular(32),
                              type: MaterialType.transparency,
                              clipBehavior: Clip.hardEdge,
                              child: IconButton(
                                padding: EdgeInsets.all(16),
                                color: AppColors.primaryWhiteColor,
                                iconSize: 22,
                                icon: Icon(Icons.menu),
                                onPressed: () {
                                  print('Clicked ${item.name}');
                                  Navigator.pushNamed(
                                      context, MongoDB.nameRoute,
                                      arguments: _stationData);
                                },
                              ),
                            ),
                          ),
                        ]),
                  )
                ]),
              ),
              Expanded(
                  child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 05,
                    childAspectRatio:
                        (size.width * 0.45) / (size.height * 0.08)),
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                children: [
                  Container(
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            print("click button");
                            setState(() {
                              data1 = double.parse(_stationData.uSv);
                              Y_name = 'Suất liều (µSv/h)';
                              check = 1;
                              _lightIsOn = !_lightIsOn;
                            });
                          },
                          child: Container(
                            width: size.width * 0.45,
                            height: size.height * 0.08,
                            margin: EdgeInsets.only(top: 12),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 2.5,
                                    color: Color.fromARGB(255, 21, 32, 192)),
                                color: _lightIsOn
                                    ? Color.fromARGB(255, 202, 227, 247)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(16)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // nơi hiển thị data
                                Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        '${_stationData.uSv}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ])
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 120,
                          height: 20,
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(left: 10),
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 24),
                          decoration: BoxDecoration(
                            color: categoryColor1,
                            borderRadius: BorderRadius.circular(36),
                          ),
                          child: Text(
                            'Suất liều',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            print("click button");
                            setState(() {
                              data1 = _stationData.cps.toDouble();
                              Y_name = 'Số đếm/s (cps)';
                              check = 0;
                              _lightIsOn = !_lightIsOn;
                            });
                          },
                          child: Container(
                            width: size.width * 0.45,
                            height: size.height * 0.08,
                            margin: EdgeInsets.only(top: 12),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 2.5,
                                    color: Color.fromARGB(255, 21, 32, 192)),
                                color: _lightIsOn
                                    ? Colors.white
                                    : Color.fromARGB(255, 202, 227, 247),
                                borderRadius: BorderRadius.circular(16)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // nơi hiển thị data
                                Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        '${_stationData.cps}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ])
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 120,
                          height: 20,
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(left: 10),
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 24),
                          decoration: BoxDecoration(
                            color: categoryColor1,
                            borderRadius: BorderRadius.circular(36),
                          ),
                          child: Text(
                            'Số đếm/s',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Data_show(
                      name: "Nhiệt độ", data_show: "${_stationData.tempC}"),
                  Data_show(name: "Độ ẩm", data_show: "${_stationData.humi}"),
                  Data_show(
                    name: 'Số đếm tổng',
                    data_show: '${_stationData.counts} ',
                  ),
                  Data_show_1(name: 'Ngày', data_show: '${_stationData.date}'),
                ],
              )),
              Container(
                height: size.height * 0.5,
                width: size.width * 0.9,
                child: Scaffold(
                    body: SfCartesianChart(
                        enableAxisAnimation: true,
                        zoomPanBehavior: ZoomPanBehavior(
                          enablePanning: true,
                        ),
                        series: <AreaSeries<LiveData, int>>[
                          AreaSeries<LiveData, int>(
                            onRendererCreated:
                                (ChartSeriesController controller) {
                              _chartSeriesController = controller;
                            },
                            dataSource: chartData!,
                            borderWidth: 2,
                            borderColor: Color.fromARGB(255, 7, 20, 138),
                            color: Color.fromARGB(255, 202, 227, 247),
                            xValueMapper: (LiveData sales, _) => sales.time,
                            yValueMapper: (LiveData sales, _) => sales.speed,
                            markerSettings: MarkerSettings(
                                height: 5,
                                width: 5,
                                isVisible: true,
                                shape: DataMarkerType.circle,
                                color: Color.fromARGB(255, 8, 3, 78),
                                borderColor: Color.fromARGB(255, 8, 3, 78)),
                            dataLabelSettings: DataLabelSettings(
                                isVisible: true,
                                labelAlignment: ChartDataLabelAlignment.top),
                          )
                        ],
                        primaryXAxis: NumericAxis(
                            majorGridLines: MajorGridLines(
                                width: 1,
                                color: Color.fromARGB(255, 158, 158, 158),
                                dashArray: <double>[3, 3]),
                            edgeLabelPlacement: EdgeLabelPlacement.shift,
                            interval: 3,
                            title: AxisTitle(text: 'Thời gian (giây)')),
                        primaryYAxis: NumericAxis(
                            axisLine: AxisLine(
                              width: 1,
                            ),
                            majorGridLines: MajorGridLines(
                              width: 1,
                            ),
                            title: AxisTitle(text: Y_name)))),
              )
            ],
          ),
        ),
      );
    }
  }

  int time = 21;
  void updateDataSource(Timer timer) {
    chartData!.add(LiveData(time++, data1!));
    chartData!.removeAt(0);
    _chartSeriesController.updateDataSource(
        addedDataIndex: chartData!.length - 1, removedDataIndex: 0);
  }

  List<LiveData> getChartData() {
    return <LiveData>[
      LiveData(0, 0),
      LiveData(1, 0),
      LiveData(2, 0),
      LiveData(3, 0),
      LiveData(4, 0),
      LiveData(5, 0),
      LiveData(6, 0),
      LiveData(7, 0),
      LiveData(8, 0),
      LiveData(9, 0),
      LiveData(10, 0),
      LiveData(11, 0),
      LiveData(12, 0),
      LiveData(13, 0),
      LiveData(14, 0),
      LiveData(15, 0),
      LiveData(16, 0),
      LiveData(17, 0),
      LiveData(18, 0),
      LiveData(19, 0),
      LiveData(20, 0),
      // LiveData(22, 0),
      // LiveData(23, 2),
      // LiveData(24, 0),
      // LiveData(25, 0),
      // LiveData(26, 0),
      // LiveData(27, 1),
      // LiveData(28, 1),
    ];
  }
}

class LiveData {
  LiveData(this.time, this.speed);
  final int time;
  final double speed;
}

class Data_show extends StatelessWidget {
  const Data_show({Key? key, required this.name, required this.data_show})
      : super(key: key);
  final String name;
  final String data_show;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Stack(
        children: [
          Container(
            width: size.width * 0.45,
            height: size.height * 0.08,
            margin: EdgeInsets.only(top: 12),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                border: Border.all(
                    width: 2.5, color: Color.fromARGB(255, 21, 32, 192)),
                color: Colors.white,
                borderRadius: BorderRadius.circular(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // nơi hiển thị data
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        data_show,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ])
                // ])
              ],
            ),
          ),
          Container(
            width: 120,
            height: 20,
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 10),
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 24),
            decoration: BoxDecoration(
              color: categoryColor1,
              borderRadius: BorderRadius.circular(36),
            ),
            child: Text(
              name,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

class Data_show_1 extends StatelessWidget {
  const Data_show_1({Key? key, required this.name, required this.data_show})
      : super(key: key);
  final String name;
  final String data_show;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Stack(
        children: [
          Container(
            width: size.width * 0.45,
            height: size.height * 0.08,
            margin: EdgeInsets.only(top: 12),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                border: Border.all(
                    width: 2.5, color: Color.fromARGB(255, 21, 32, 192)),
                color: Colors.white,
                borderRadius: BorderRadius.circular(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // nơi hiển thị data
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        data_show,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                        ),
                      ),
                    ])
                // ])
              ],
            ),
          ),
          Container(
            width: 120,
            height: 20,
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 10),
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 24),
            decoration: BoxDecoration(
              color: categoryColor1,
              borderRadius: BorderRadius.circular(36),
            ),
            child: Text(
              name,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
