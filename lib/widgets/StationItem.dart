import 'package:flutter/material.dart';
import 'package:rewes/constants/app_colors.dart';
import 'package:rewes/models/spending_category_model.dart';
import 'package:rewes/screens/Detail_station.dart';
import 'package:rewes/widgets/icon_button_information.dart';
import 'package:rewes/widgets/current_time.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:rewes/json/geolocation.dart';
import 'package:rewes/json/station.dart';
import 'package:rewes/main.dart';
import 'package:rewes/json/stationdata.dart';
import 'package:rewes/constants/app_colors.dart';
import 'package:rewes/screens/home_screen.dart';

class SpendingCategory extends StatelessWidget {
  final SpendingCategoryModel data;

  SpendingCategory(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: Stack(
        children: [
          Container(
            height: 100,
            margin: EdgeInsets.only(top: 12),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [],
            ),
          ),
          Container(
            width: 132,
            height: 24,
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 16),
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 24),
            decoration: BoxDecoration(
              color: data.color,
              borderRadius: BorderRadius.circular(36),
            ),
            child: Text(
              data.label,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class StationItem extends StatefulWidget {
  const StationItem(
      {Key? key,
      required this.item,
      required this.itemList,
      required this.updatedItem})
      : super(key: key);
  final Station item;
  final StationData updatedItem;
  final List<StationData> itemList;

  @override
  State<StationItem> createState() => _StationItemState();
}

class _StationItemState extends State<StationItem> {
  TextEditingController _textFieldController = TextEditingController();
  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('ĐẶT NGƯỠNG BÁO ĐỘNG (µSv/h)',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 15,
                )),
            content: TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "(µSv/h)"),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              // FlatButton(
              //   color: Colors.red,
              //   textColor: Colors.white,
              //   child: Text('CANCEL'),
              //   onPressed: () {
              //     setState(() {
              //       Navigator.pop(context);
              //     });
              //   },
              // ),
              FlatButton(
                color: AppColors.categoryColor1,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    try {
                      codeDialog = double.parse(valueText);
                      //print(uSv);
                    } on FormatException {
                      print('Format error!');
                    }
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final index =
        widget.itemList.indexWhere((element) => element.id == widget.item.id);
    final StationData station_data;
    if (index > -1) {
      station_data = widget.updatedItem.id == widget.item.id
          ? widget.updatedItem
          : widget.itemList[index];
    } else {
      station_data = StationData.empty();
    }
    Size size = MediaQuery.of(context).size;

    double uSv = 0;
    //uSv = double.parse(station_data.uSv);
    try {
      uSv = double.parse(station_data.uSv);
      //print(uSv);
    } on FormatException {
      print('Format error!');
    }
    var _colorwarning = AppColors.categoryColor1;
    print("${uSv}");
    if (uSv > codeDialog) {
      _colorwarning = Colors.red;
    } else {
      if (uSv >= 0.6) {
        _colorwarning = Colors.yellow;
      } else {
        _colorwarning = AppColors.categoryColor1;
      }
    }

    return InkWell(
      onTap: () {
        print('Clicked ${widget.item.name}');
        socket.emit('join-room', widget.item.id);
        Navigator.pushNamed(context, Detail_Station.nameRoute,
            arguments: widget.item);
      },
      onLongPress: () {
        print("open set station");
        _displayTextInputDialog(context);
      },
      child: Container(
        child: Stack(
          children: [
            Container(
              height: size.height * 0.2,
              width: size.width * 0.43,
              margin: EdgeInsets.only(top: 12),
              //padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: _colorwarning),
                  color: MediaQuery.of(context).platformBrightness ==
                          Brightness.light
                      ? Colors.white
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // nơi hiển thị data
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(height: 5),
                        Text(
                          'counts: ${station_data.counts} ',
                          style: TextStyle(
                              color: _colorwarning,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'cps: ${station_data.cps}',
                          style: TextStyle(
                              color: _colorwarning,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '${station_data.uSv} uSv/h',
                          style: TextStyle(
                              color: _colorwarning,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      ])
                  // ])
                ],
              ),
            ),
            Container(
              width: 132,
              height: 28,
              alignment: Alignment.center,
              // margin: EdgeInsets.only(bottom: 5),
              // padding: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
              decoration: BoxDecoration(
                border: Border.all(width: 2.5, color: _colorwarning),
                color: _colorwarning,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
              ),
              child: Text(
                widget.item.name,
                style: TextStyle(
                    color: MediaQuery.of(context).platformBrightness ==
                            Brightness.light
                        ? Colors.white
                        : Color.fromARGB(166, 0, 0, 0),
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
