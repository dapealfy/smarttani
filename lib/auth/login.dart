import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:smarttani/auth/register.dart';
import 'package:smarttani/auth/reset_password/step1.dart';
import 'package:smarttani/main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarttani/settings.dart' as setting;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String msg = '';
  bool _obscureText = true;
  bool _condition = true;

  @override
  void initState() {
    super.initState();
  }

  void _onLoading() {
    _login();
    new Future.delayed(new Duration(seconds: 5), () {
      if (datalogin['error'] == 'Unauthorised') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: Text("Gagal"),
              content: new Text("Nomor / Password salah!"),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              child: Container(
                padding: EdgeInsets.all(25),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      width: 20,
                    ),
                    Text("Berhasil, mohon tunggu..."),
                  ],
                ),
              ),
            );
          },
        );
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
      }
    });
  }

  SharedPref sharedPref = SharedPref();

  Future _login() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = setting.url_api + "api/login";
    var username;
    username = controllerUserName.text;
    final response = await http.post(Uri.parse(url), headers: {
      'Accept': 'application/json',
    }, body: {
      "username": username,
      "password": controllerPassword.text.toString(),
    });
    datalogin = json.decode(response.body);
    print(datalogin);
    setState(() {
      prefs.setString('token', datalogin['token'].toString());
      prefs.setString('isLoggedIn', 'true');
      prefs.commit();
    });
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController controllerUserName = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  //Data Login
  late Map<String, dynamic> datalogin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0.0,
      //   actions: <Widget>[
      //     _condition == false
      //         ? MaterialButton(
      //             onPressed: () {},
      //             child: Container(
      //               height: 20,
      //               width: 20,
      //               child: CircularProgressIndicator(),
      //             ),
      //           )
      //         : Container(),
      //   ],
      // ),
      body: Stack(children: <Widget>[
        Positioned(
          top: 0,
          right: 0,
          child: _condition == false
              ? MaterialButton(
                  onPressed: () {},
                  child: Container(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(),
        ),
        Container(
          margin: EdgeInsets.only(left: 30, right: 30, top: 20),
          child: Form(
            key: _formKey,
            child: Stack(
              children: [
                ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    Center(
                      child: Image.asset(
                        'assets/logo.png',
                        width: 200,
                      ),
                    ),
                    SizedBox(height: 60),
                    Text(
                      "Selamat Datang!",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.8),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('Smart Tani'),
                    SizedBox(height: 40),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        controller: controllerUserName,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.alternate_email),
                          border: InputBorder.none,
                          labelText: 'Username',
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 17, vertical: 17),
                            margin: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              color: _obscureText ? Colors.grey : Colors.green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            duration: Duration(milliseconds: 300),
                            curve: Curves.fastOutSlowIn,
                            child: Icon(
                              _obscureText
                                  ? TablerIcons.eye_off
                                  : TablerIcons.eye,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    GestureDetector(
                      onTap: _condition == true
                          ? () async {
                              if (_formKey.currentState!.validate()) {
                                Timer(Duration(seconds: 1),
                                    () => setState(() => _condition = false));
                                _onLoading();
                                await Future.delayed(
                                    Duration(milliseconds: 5000));
                                setState(() => _condition = true);
                              }
                            }
                          : null,
                      child: AnimatedContainer(
                        padding: EdgeInsets.symmetric(vertical: 17),
                        duration: Duration(milliseconds: 300),
                        curve: Curves.fastOutSlowIn,
                        decoration: BoxDecoration(
                          color: _condition ? Colors.green : Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Login',
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
                    SizedBox(height: 20),
                    Center(
                      child: Column(
                        children: [
                          // GestureDetector(
                          //   onTap: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) => StepOneFP(),
                          //       ),
                          //     );
                          //   },
                          //   child: Text(
                          //     'Lupa Password?',
                          //     style: TextStyle(
                          //       color: Colors.green,
                          //       fontSize: 14,
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Tidak memiliki akun? '),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RegisterPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Register',
                                  style: TextStyle(color: Colors.green),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
