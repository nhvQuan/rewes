import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:rewes/constants/app_colors.dart';
import 'package:rewes/screens/Detail_station.dart';
import 'package:rewes/screens/home_screen.dart';
import 'package:rewes/widgets/StationItem.dart';
import 'widgets/mongoose.dart';
import 'package:rewes/screens/Detail_station.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:rewes/json/station.dart';
import 'package:rewes/json/geolocation.dart';
import 'package:rewes/DBcollect/mongodb.dart';
import 'package:rewes/DBcollect/constant.dart';
import 'package:mongo_dart/mongo_dart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Mongodatabase.connect();
  runApp(MyApp());
}

IO.Socket socket = IO.io('https://rewes1.glitch.me',
    IO.OptionBuilder().setTransports(['websocket']).build());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _laugnchurl() async {
      const url =
          'https://sites.google.com/hcmus.edu.vn/rewes/trang-ch%E1%BB%A7?authuser=0';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw "can't lauch the url";
      }
    }

    _urlHCMUS() async {
      const url = 'https://www.hcmus.edu.vn/';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw "can't lauch the url";
      }
    }

    return MaterialApp(
      initialRoute: '/',
      routes: {
        Detail_Station.nameRoute: (context) => Detail_Station(),
        MongoDB.nameRoute: (context) => MongoDB(),
        // // tạo route để nagivator
      },
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: AppColors.primaryWhiteColor,
          accentColor: const Color(0xFFCADCF8),
          backgroundColor: AppColors.primaryWhiteColor,
          textTheme: TextTheme(
              headline1: TextStyle(
                  color: AppColors.headerTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                  fontFamily: 'Shizuru'),
              headline2:
                  TextStyle(color: AppColors.headerTextColor, fontSize: 24),
              headline3: TextStyle(
                  color: AppColors.darkModeBackground,
                  fontSize: 28,
                  fontWeight: FontWeight.bold)),
          appBarTheme: AppBarTheme(
              backgroundColor: const Color(0xFFCADCF8), elevation: 0)),
      darkTheme: ThemeData(
          primaryColor: AppColors.darkModeBackground,
          accentColor: AppColors.darkModeBackground,
          backgroundColor: Colors.grey[800],
          textTheme: TextTheme(
              headline1: TextStyle(
                  color: AppColors.primaryWhiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                  fontFamily: 'Shizuru'),
              headline2:
                  TextStyle(color: AppColors.primaryWhiteColor, fontSize: 24),
              headline3: TextStyle(
                  color: AppColors.primaryWhiteColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold)),
          appBarTheme: AppBarTheme(
              backgroundColor: AppColors.darkModeBackground, elevation: 0)),
      home: Scaffold(
        appBar: AppBar(
          title: Container(
            child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                        child:
                            Image.asset('rewes.png', height: 100, width: 100),
                        onTap: _laugnchurl),
                    Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'HỆ THỐNG QUAN TRẮC ',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.secondaryAccent,
                                    fontWeight: FontWeight.w800),
                              ),
                              Text(
                                'THỜI GIAN THỰC TRỰC TUYẾN',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.secondaryAccent,
                                    fontWeight: FontWeight.w800),
                              ),
                            ])),
                    InkWell(
                        child:
                            Image.asset('logo_KHTN.png', height: 65, width: 58),
                        onTap: _urlHCMUS),
                  ],
                )),
          ),
          centerTitle: false,
        ),
        body: Stack(
          children: [
            Homepage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.list,
                  size: 28,
                ),
                label: 'Information',
                backgroundColor: Colors.red),
            BottomNavigationBarItem(
                icon: Icon(Icons.person, size: 28), label: 'da')
          ],
        ),
      ),
    );
  }
}
