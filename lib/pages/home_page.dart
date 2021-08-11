import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarttani/pages/details/detail_kelompokTani.dart';
import 'package:smarttani/pages/hasilPanen.dart';
import 'package:smarttani/pages/kelompokTani.dart';
import 'package:smarttani/pages/pembibitan.dart';
import 'package:smarttani/pages/perawatan.dart';
import 'package:smarttani/pages/search.dart';
import 'package:smarttani/settings.dart' as setting;
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final LatLng _kMapCenter = LatLng(-1.2605708, 116.8057993);
  static final CameraPosition _kInitialPosition =
      CameraPosition(target: _kMapCenter, zoom: 13.0, tilt: 0, bearing: 0);
  late GoogleMapController _controller;

  final controller = Completer<GoogleMapController>();

  var cuacaData;
  Future _dataCuaca() async {
    Uri url = Uri.parse(
        "https://api.ambeedata.com/weather/latest/by-lat-lng?lat=-1.227181&lng=116.854837");
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      "x-api-key":
          "42c8460136361f402753ca8d5c890e957bb412df0ddf7c7ae3f29caa35595e4d",
    });
    Map<String, dynamic> cuaca;

    cuaca = json.decode(response.body);
    setState(() {
      cuacaData = cuaca['data'];
      print(cuacaData);
    });
  }

  List kelompokTani = [];
  List<Marker> markers = <Marker>[];
  Future _dataKelompokTani() async {
    Uri url = Uri.parse(setting.url_api + "api/kelompok-tani");
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
    });
    Map<String, dynamic> _kelompokTani;

    _kelompokTani = json.decode(response.body);
    setState(() {
      kelompokTani = _kelompokTani['kelompok_tani'] ?? [];
      var i = 0;
      while (i < kelompokTani.length) {
        setState(() {
          var lat = kelompokTani[i]['lat'];
          var lng = kelompokTani[i]['lng'];
          var nama = kelompokTani[i]['nama'];
          var dataKelompokTani = kelompokTani[i];
          markers.add(
            Marker(
              markerId: MarkerId('kelompokTani' + i.toString()),
              position: LatLng(lat, lng),
              infoWindow: InfoWindow(
                title: nama.toString(),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailKelompokTani(
                        kelompokTani: dataKelompokTani,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        });
        i++;
      }
    });
  }

  void initState() {
    _dataKelompokTani();
    _dataCuaca();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 155.0,
              child: DrawerHeader(
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white,
                          ),
                          width: 60,
                          height: 60,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset('assets/logo.png'),
                          )),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      // padding: EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Smart Tani",
                            style: TextStyle(color: Colors.white, fontSize: 25),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                ),
              ),
            ),
            // ListTile(
            //   title: Row(
            //     children: <Widget>[
            //       Icon(Feather.user),
            //       SizedBox(
            //         width: 10,
            //       ),
            //       Text('Layanan ')
            //     ],
            //   ),
            //   onTap: () {
            //     Navigator.pop(context);
            //     // Navigator.push(context,
            //     //     MaterialPageRoute(builder: (context) => ProfilePage()));
            //   },
            // ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.logout),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Logout')
                ],
              ),
              onTap: () async {
                Navigator.pop(context);
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                prefs.setString('isLoggedIn', 'false');
                Navigator.pushReplacementNamed(context, "/login");
              },
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    _scaffoldKey.currentState!.openDrawer();
                  },
                  icon: Icon(TablerIcons.menu),
                ),
                Text(
                  'Smart Tani',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Cari(),
                      ),
                    );
                  },
                  icon: Icon(TablerIcons.search),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 20.0,
                  spreadRadius: 2.0,
                  offset: Offset(
                    0.0,
                    10.0,
                  ),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding:
                      EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            cuacaData != null
                                ? (((cuacaData['temperature'] - 32) * 5 / 9)
                                        .toString()
                                        .substring(0, 2) +
                                    '°C')
                                : '...',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Balikpapan',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        DateTime.now().toString().substring(0, 10),
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                        ),
                      )
                    ],
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 5,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xff36CEB8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(TablerIcons.cloud_rain, size: 30),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Suhu Rendah',
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.6),
                                    ),
                                  ),
                                  Text(
                                    cuacaData != null
                                        ? (((cuacaData['temperature'] - 32) *
                                                    5 /
                                                    9)
                                                .toString()
                                                .substring(0, 2) +
                                            '°C')
                                        : '...',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(TablerIcons.sun, size: 30),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Suhu Tinggi',
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.6),
                                    ),
                                  ),
                                  Text(
                                    cuacaData != null
                                        ? (((cuacaData['apparentTemperature'] -
                                                        32) *
                                                    5 /
                                                    9)
                                                .toString()
                                                .substring(0, 2) +
                                            '°C')
                                        : '...',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                        top: 0,
                        right: 0,
                        left: 0,
                        child: Center(
                          child: Container(
                            height: 25,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(100),
                                bottomRight: Radius.circular(100),
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'Pilihan Menu',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 30),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Pembibitan(),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 20.0,
                            spreadRadius: 2.0,
                            offset: Offset(
                              0.0,
                              10.0,
                            ),
                          ),
                        ],
                      ),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/pembibitan.png',
                              width: 70,
                              height: 70,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Pembibitan',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Perawatan(),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 20.0,
                            spreadRadius: 2.0,
                            offset: Offset(
                              0.0,
                              10.0,
                            ),
                          ),
                        ],
                      ),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/perawatan.png',
                              width: 70,
                              height: 70,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Perawatan',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HasilPanen(),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 20.0,
                            spreadRadius: 2.0,
                            offset: Offset(
                              0.0,
                              10.0,
                            ),
                          ),
                        ],
                      ),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/hasil-panen.png',
                              width: 70,
                              height: 70,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Hasil Panen',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KelompokTani(),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 20.0,
                            spreadRadius: 2.0,
                            offset: Offset(
                              0.0,
                              10.0,
                            ),
                          ),
                        ],
                      ),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/kelompok-tani.png',
                              width: 70,
                              height: 70,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Kelompok Tani',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'Kelompok Tani',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 30),
          Container(
            height: 220,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _kInitialPosition,
                onMapCreated: (GoogleMapController controllera) async {
                  _controller = controllera;
                  controller.complete(_controller);
                },
                markers: Set<Marker>.of(markers),
              ),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
