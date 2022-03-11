import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rewes/DBcollect/MongoDBModel.dart';
import 'package:rewes/constants/app_colors.dart';
import 'package:rewes/DBcollect/MongoDBModel.dart';
import 'package:rewes/models/spending_category_model.dart';
import 'package:rewes/widgets/current_time.dart';
import 'package:rewes/widgets/search_bar.dart';
import 'package:rewes/widgets/StationItem.dart';
import 'package:rewes/widgets/mongoose.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:rewes/json/geolocation.dart';
import 'package:rewes/json/station.dart';
import 'package:rewes/json/stationdata.dart';
import 'package:rewes/main.dart';
import 'package:rewes/screens/home_screen.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:rewes/DBcollect/mongodb.dart';

late String note = '';

class Detail_Station extends StatefulWidget {
  const Detail_Station({Key? key}) : super(key: key);
  static const nameRoute = '/Detail';
  @override
  _Detail_StationState createState() => _Detail_StationState();
}

class _Detail_StationState extends State<Detail_Station> {
  var _statusStation = '';
  var _tempC = "";
  var _humi = "";
  late var _cps;
  var _counts = "";
  // late int _realtime;
  var _uSv = '';
  var _date = "";
  var _id = "";
  late StationData _stationData;
  bool isLoaded = false;
  void initState() {
    super.initState();
    connectAndListen();

    // insertMongo();
  }

  // void insertMongo() {

  // }

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
        });
        print('$_stationData');
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
                height: 180,
                child: Stack(children: [
                  Container(
                    color: Theme.of(context).accentColor,
                    height: 150,
                    padding: EdgeInsets.only(left: 36, top: 12),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: size.height * 0.04),
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

                            // Wrap the IconButton in a Material widget for the
                            // IconButton's splash to render above the container.
                            child: Material(
                              borderRadius: BorderRadius.circular(32),
                              type: MaterialType.transparency,
                              // Hard Edge makes sure the splash is clipped at the border of this
                              // Material widget, which is circular due to the radius above.
                              clipBehavior: Clip.hardEdge,

                              /// icon navigaton thông tin các thứ
                              child: IconButton(
                                padding: EdgeInsets.all(16),
                                color: AppColors.primaryWhiteColor,
                                iconSize: 32,
                                icon: Icon(Icons.menu_open),
                                onPressed: () {
                                  print('Clicked ${item.name}');
                                  Navigator.pushNamed(
                                      context, MongoDB.nameRoute,
                                      arguments: item);
                                },
                              ),
                            ),
                          ),
                        ]),
                  )
                ]),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Expanded(
                  child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio:
                        (size.width * 0.45) / (size.height * 0.2)),
                padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                children: [
                  Data_show(
                    name: 'nhiệt độ',
                    data_show: '${_stationData.tempC} °C',
                  ),
                  Data_show(
                    name: 'độ ẩm',
                    data_show: "${_stationData.humi} %",
                  ),
                  Data_show_1(
                    name: 'số đếm',
                    data_show: '${_stationData.counts} ',
                  ),
                  Data_show(
                    name: 'số đếm/s',
                    data_show: '${_stationData.cps} cps',
                  ),
                  Data_show(
                    name: 'suất liều',
                    data_show: '${_stationData.uSv} µSv/h',
                  ),
                  Data_show_1(name: 'date', data_show: '${_stationData.date}')
                ],
              ))
            ],
          ),
        ),
      );
    }
  }

  Future<void> _insertData(String _statusStation, String _tempC, String _humi,
      var _counts, String _uSv, String _date) async {
    var id = M.ObjectId();
    final data = MongoDbModel(
        statusStation: _statusStation,
        date: _date,
        // realtime: _realtime,
        tempC: _tempC,
        humi: _humi,
        cps: _cps,
        uSv: _uSv,
        id: _id);
    var result = await Mongodatabase.insert(data);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Insert ID" + id.$oid)));
  }

  void _Datainsert() {
    setState(() {
      _statusStation = _stationData.statusStation;
      _counts = _stationData.counts;
      // _cps = _stationData.cps;
      _humi = _stationData.humi;
      _tempC = _stationData.tempC;
      _date = _stationData.date;
      // _realtime = _stationData.realtime;
      _uSv = _stationData.uSv;
    });
  }
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
            height: size.height * 0.2,
            margin: EdgeInsets.only(top: 12),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: MediaQuery.of(context).platformBrightness ==
                        Brightness.light
                    ? Colors.white
                    : AppColors.darkModeCardColor,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 32,
                      color: Colors.black45,
                      spreadRadius: -8,
                      offset: Offset(0.0, 0.75))
                ],
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
                  color: MediaQuery.of(context).platformBrightness ==
                          Brightness.light
                      ? AppColors.darkModeCategoryColor
                      : AppColors.darkModeCategoryColor,
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
            margin: EdgeInsets.only(top: 12),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: MediaQuery.of(context).platformBrightness ==
                        Brightness.light
                    ? Colors.white
                    : AppColors.darkModeCardColor,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 32,
                      color: Colors.black45,
                      spreadRadius: -8,
                      offset: Offset(0.0, 0.75))
                ],
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
                  color: MediaQuery.of(context).platformBrightness ==
                          Brightness.light
                      ? AppColors.darkModeCategoryColor
                      : AppColors.darkModeCategoryColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
