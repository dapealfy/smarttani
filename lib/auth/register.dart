import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:smarttani/main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarttani/settings.dart' as setting;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String msg = '';
  bool _obscureText = true;
  bool _condition = true;
  bool agree = false;

  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController controllerNama = TextEditingController();
  TextEditingController controllerUserName = TextEditingController();
  TextEditingController controllerTelp = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerAlamat = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  //Data Register
  late Map<String, dynamic> dataRegister;

  SharedPref sharedPref = SharedPref();

  void _onLoading() {
    _register();
    new Future.delayed(new Duration(seconds: 5), () {
      if (dataRegister['status'] == 'ERR') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: Text("Gagal"),
              content: new Text("Nomor / Password salah!"),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new TextButton(
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

  _register() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = setting.url_api + "api/register";
    var no_telepon;
    no_telepon = controllerTelp.text;
    final response = await http.post(Uri.parse(url), headers: {
      'Accept': 'application/json',
    }, body: {
      "name": controllerNama.text.toString(),
      "username": controllerUserName.text.toString(),
      "phone": controllerTelp.text.toString(),
      "address": controllerAlamat.text.toString(),
      "email": controllerEmail.text.toString(),
      "password": controllerPassword.text.toString(),
      "role": 'user',
    });
    dataRegister = json.decode(response.body);
    print(dataRegister);
    setState(() {
      prefs.setString('token', dataRegister['token'].toString());
      prefs.setString('isLoggedIn', 'true');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          "Registrasi",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black.withOpacity(0.8),
          ),
        ),
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
      body: Container(
        margin: EdgeInsets.only(left: 30, right: 30, top: 20),
        child: Form(
          key: _formKey,
          child: Stack(
            children: [
              ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: controllerNama,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Feather.user),
                        border: InputBorder.none,
                        labelText: 'Nama',
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
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
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: controllerTelp,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone_outlined),
                        border: InputBorder.none,
                        labelText: 'Telp',
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: controllerAlamat,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.home_outlined),
                        border: InputBorder.none,
                        labelText: 'Alamat',
                      ),
                    ),
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
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(TablerIcons.mail),
                        border: InputBorder.none,
                        labelText: 'Email',
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
                  SizedBox(height: 20),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            agree = !agree;
                          });
                        },
                        child: AnimatedContainer(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                            color: agree
                                ? Colors.green
                                : Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          duration: Duration(milliseconds: 100),
                          curve: Curves.easeIn,
                          child: agree
                              ? Icon(
                                  Icons.check,
                                  color: Colors.white,
                                )
                              : Container(),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          child: Text(
                              'Saya menyetujui ketentuan layanan dan kebijakan privasi'),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 30),
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
                              'Register',
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
                  SizedBox(height: 50),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
