import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:smarttani/auth/reset_password/step4.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarttani/settings.dart' as setting;
import 'package:http/http.dart' as http;

class StepThreeFP extends StatefulWidget {
  final otp;
  final user_id;
  StepThreeFP(this.otp, this.user_id);
  @override
  _StepThreeFPState createState() => _StepThreeFPState();
}

class _StepThreeFPState extends State<StepThreeFP> {
  bool _obscureText = true;
  bool _condition = true;

  TextEditingController controllerOtp = TextEditingController();

  _reset() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (controllerOtp.text == widget.otp) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StepFourFP(widget.user_id),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Gagal"),
            content: Text('Otp yang kamu masukkan salah!'),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          _condition == false
              ? MaterialButton(
                  onPressed: () {},
                  child: Container(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(),
        ],
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Verifikasi Email",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  child: Text(
                      'Silahkan masukkan kode Verifikasi dari email anda.'),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: controllerOtp,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Feather.key),
                      border: InputBorder.none,
                      labelText: 'Kode Verifikasi',
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: _condition == true
                      ? () async {
                          // Timer(Duration(seconds: 1),
                          //     () => setState(() => _condition = false));
                          // await Future.delayed(Duration(milliseconds: 5000));
                          // setState(() => _condition = true);
                          _reset();
                        }
                      : null,
                  child: AnimatedContainer(
                    padding: EdgeInsets.symmetric(vertical: 17),
                    duration: Duration(milliseconds: 300),
                    curve: Curves.fastOutSlowIn,
                    decoration: BoxDecoration(
                      color: _condition ? Color(0xffFFA601) : Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Verifikasi',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
