import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smarttani/pages/details/detail_perawatan.dart';
import 'package:smarttani/settings.dart' as setting;
import 'package:http/http.dart' as http;

class Cari extends StatefulWidget {
  const Cari({Key? key}) : super(key: key);

  @override
  _CariState createState() => _CariState();
}

class _CariState extends State<Cari> {
  List pembibitan = [];
  List perawatan = [];
  List pembibitan_ = [];
  List perawatan_ = [];

  Future _dataPembibitan() async {
    Uri url = Uri.parse(setting.url_api + "api/pembibitan");
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
    });
    Map<String, dynamic> _pembibitan;

    _pembibitan = json.decode(response.body);
    setState(() {
      pembibitan = _pembibitan['pembibitan'];
      pembibitan_ = _pembibitan['pembibitan'];
    });
  }

  Future _dataPerawatan() async {
    Uri url = Uri.parse(setting.url_api + "api/perawatan");
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
    });
    Map<String, dynamic> _perawatan;

    _perawatan = json.decode(response.body);
    setState(() {
      perawatan = _perawatan['perawatan'];
      perawatan_ = _perawatan['perawatan'];
    });
  }

  void initState() {
    super.initState();
    _dataPembibitan();
    _dataPerawatan();
  }

  void pencarianFunction(String text) async {
    setState(() {
      print(pembibitan);
      pembibitan_ = [];
      perawatan_ = [];
      // print(pembibitan);
      print(pembibitan);
      pembibitan.forEach((data) {
        if (data['jenis'].toLowerCase().contains(text.toLowerCase()))
          pembibitan_.add(data);
      });
      perawatan.forEach((data) {
        if (data['jenis_hama'].toLowerCase().contains(text.toLowerCase()))
          perawatan_.add(data);
        if (data['pembibitan']['jenis']
            .toLowerCase()
            .contains(text.toLowerCase())) perawatan_.add(data);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              SizedBox(height: 70),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Pembibitan',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GridView.builder(
                itemCount: pembibitan_.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 200 / 280,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
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
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 130,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                  child: Image.network(
                                    pembibitan_[index]['image'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 10,
                                top: 10,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
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
                                  child: Text(
                                    'Rp. ' + pembibitan_[index]['harga'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Jenis',
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.6)),
                                    ),
                                    Text(
                                      pembibitan_[index]['jenis'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Lama Tanam',
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.6)),
                                    ),
                                    Text(
                                      pembibitan_[index]['lama_tanam'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Perawatan',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GridView.builder(
                itemCount: perawatan_.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 200 / 310,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
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
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 130,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                  child: Image.network(
                                    perawatan_[index]['pembibitan']['image'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Jenis',
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.6)),
                                    ),
                                    Text(
                                      perawatan_[index]['pembibitan']['jenis'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Lama Tanam',
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.6)),
                                    ),
                                    Text(
                                      perawatan_[index]['pembibitan']
                                          ['lama_tanam'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailPerawatan(
                                        perawatan: perawatan_[index]),
                                  ),
                                );
                              },
                              child: Text('Lihat Detail'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          Positioned(
            top: 40,
            left: 100,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              // margin: EdgeInsets.only(bottom: 15),
              child: TextField(
                cursorColor: Colors.black,
                onChanged: pencarianFunction,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Cari...",
                  hintStyle: TextStyle(color: Colors.black54),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
                style: TextStyle(color: Colors.black54, fontSize: 20.0),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(50)),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(CupertinoIcons.back, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
