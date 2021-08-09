import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:smarttani/settings.dart' as setting;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StepFourFP extends StatefulWidget {
  final user_id;
  StepFourFP(this.user_id);
  @override
  _StepFourFPState createState() => _StepFourFPState();
}

class _StepFourFPState extends State<StepFourFP> {
  bool _obscureText = true;
  bool _condition = true;

  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerPasswordConfirm = TextEditingController();

  late Map<String, dynamic> datareset;
  _reset() async {
    print(widget.user_id);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = setting.url_api + "api/customer/forgot-password/reset";
    final response = await http.post(Uri.parse(url), headers: {
      'Accept': 'application/json',
    }, body: {
      "user_id": widget.user_id,
      "password": controllerPassword.text.toString(),
      "password_confirm": controllerPasswordConfirm.text.toString(),
    });
    datareset = json.decode(response.body);
    print(datareset);
    setState(() => _condition = true);
    if (datareset['status'] == 'OK') {
      Navigator.pushReplacementNamed(context, "/home");
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
                  "Buat Password Baru",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  child: Text(
                      'Password baru anda harus berbeda dari password sebelumnya.'),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          controller: controllerPassword,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock_outline),
                            border: InputBorder.none,
                            labelText: 'Password',
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: AnimatedContainer(
                        padding:
                            EdgeInsets.symmetric(horizontal: 17, vertical: 17),
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          color: _obscureText ? Colors.grey : Color(0xffFFA601),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        duration: Duration(milliseconds: 300),
                        curve: Curves.fastOutSlowIn,
                        child: Icon(
                          _obscureText ? TablerIcons.eye_off : TablerIcons.eye,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: controllerPasswordConfirm,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline),
                      border: InputBorder.none,
                      labelText: 'Konfirmasi Password',
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
                            'Reset Password',
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
