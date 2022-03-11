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
                color: MediaQuery.of(context).platformBrightness ==
                        Brightness.light
                    ? Colors.white
                    : AppColors.darkModeCardColor,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 32, color: Colors.black45, spreadRadius: -8)
                ],
                borderRadius: BorderRadius.circular(16)),
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
              style: TextStyle(
                  color: MediaQuery.of(context).platformBrightness ==
                          Brightness.light
                      ? Colors.white
                      : AppColors.darkModeCategoryColor,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class StationItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final index = itemList.indexWhere((element) => element.id == item.id);
    final StationData station_data;
    if (index > -1) {
      station_data = updatedItem.id == item.id ? updatedItem : itemList[index];
    } else {
      station_data = StationData.empty();
    }
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        print('Clicked ${item.name}');
        socket.emit('join-room', item.id);
        Navigator.pushNamed(context, Detail_Station.nameRoute, arguments: item);
      },
      child: Container(
        child: Stack(
          children: [
            Container(
              height: size.height * 0.2,
              width: size.width * 0.45,
              margin: EdgeInsets.only(top: 12),
              //padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: MediaQuery.of(context).platformBrightness ==
                          Brightness.light
                      ? Colors.white
                      : AppColors.darkModeCardColor,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 32, color: Colors.black45, spreadRadius: -8)
                  ],
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // nơi hiển thị data
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(height: 5),
                        Text('counts: ${station_data.counts} '),
                        Text('cps: ${station_data.cps}'),
                        Text('${station_data.uSv} uSv/h'),
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
                color: categoryColor1,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
              ),
              child: Text(
                item.name,
                style: TextStyle(
                    color: MediaQuery.of(context).platformBrightness ==
                            Brightness.light
                        ? Colors.white
                        : AppColors.darkModeCategoryColor,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
