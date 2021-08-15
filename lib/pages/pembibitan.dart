import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smarttani/settings.dart' as setting;
import 'package:http/http.dart' as http;

class Pembibitan extends StatefulWidget {
  const Pembibitan({Key? key}) : super(key: key);

  @override
  _PembibitanState createState() => _PembibitanState();
}

class _PembibitanState extends State<Pembibitan> {
  List pembibitan = [];
  Future _dataPembibitan() async {
    Uri url = Uri.parse(setting.url_api + "api/pembibitan");
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
    });
    Map<String, dynamic> _pembibitan;

    _pembibitan = json.decode(response.body);
    setState(() {
      pembibitan = _pembibitan['pembibitan'];
    });
  }

  void initState() {
    super.initState();
    _dataPembibitan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(CupertinoIcons.back),
                ),
                SizedBox(width: 20),
                Text(
                  'Pembibitan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container()
              ],
            ),
          ),
          GridView.builder(
            itemCount: pembibitan.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: (MediaQuery.of(context).size.width - 135) /
                  (MediaQuery.of(context).size.width),
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
                                pembibitan[index]['image'],
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
                                'Rp. ' + pembibitan[index]['harga'],
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
                                  pembibitan[index]['jenis'],
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Lama Tanam',
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6)),
                                ),
                                Text(
                                  pembibitan[index]['lama_tanam'],
                                  style: TextStyle(fontWeight: FontWeight.w500),
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
        ],
      ),
    );
  }
}
