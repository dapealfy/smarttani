import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smarttani/auth/reset_password/step2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarttani/settings.dart' as setting;
import 'package:http/http.dart' as http;

class StepOneFP extends StatefulWidget {
  @override
  _StepOneFPState createState() => _StepOneFPState();
}

class _StepOneFPState extends State<StepOneFP> {
  bool _condition = true;

  TextEditingController controllerEmail = TextEditingController();

  late Map<String, dynamic> datareset;
  _reset() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = setting.url_api + "api/customer/forgot-password/send-mail";
    final response = await http.post(Uri.parse(url), headers: {
      'Accept': 'application/json',
    }, body: {
      "email": controllerEmail.text.toString(),
    });
    datareset = json.decode(response.body);
    print(datareset);
    setState(() => _condition = true);
    if (datareset['status'] == 'OK') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StepTwoFP(
              datareset['verification_code'], datareset['user']['id']),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Gagal"),
            content: Text(datareset['message'].toString()),
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
                  "Reset Password",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  child: Text(
                      'Masukkan alamat email yang terhubung dengan akun anda dan kami akan mengirimkan email dengan instruksi untuk me-reset password anda.'),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      border: InputBorder.none,
                      labelText: 'Email',
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: _condition == true
                      ? () async {
                          Timer(Duration(seconds: 1),
                              () => setState(() => _condition = false));
                          await Future.delayed(Duration(milliseconds: 5000));
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
                            'Kirim Instruksi',
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
