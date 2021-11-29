import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos/network_api/api.dart';
import 'package:pos/screen/sale.dart';
import 'package:pos/screen/sale_wholosale.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oktoast/oktoast.dart';
import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
// conntetivity
import 'package:connectivity/connectivity.dart';
import 'dart:async';
import 'package:rflutter_alert/rflutter_alert.dart';

var data = {'username': '', 'password': '', 'device_name': 'mobile'};

class Login extends StatefulWidget {
  static const RouteName = '/login';
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final scaffoldkey = GlobalKey<ScaffoldState>();

  GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();
  // conntetivity
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool CheckNet = true;

  bool hidePassword = true;
  bool _isButtonDisabled = false;
  bool isAuth = false;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool auth = false;
  // This widget is the root of your application.
  // Color selection = Colors.yellow[400]!;

  void initState() {
    super.initState();
    print('Login page');
    // conntetivity
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
      // checkAuth();
  }

  @override
  void dispose() {
    // conntetivity
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      // print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        setState(() => _connectionStatus = result.toString());
        // print(' Internet ${result.toString()}');
        setState(() {
          CheckNet = true;
        });
        break;
      case ConnectivityResult.mobile:
        setState(() => _connectionStatus = result.toString());
        // print(' Internet ${result.toString()}');
        setState(() {
          CheckNet = true;
        });
        break;
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        // print('โปรดเชื่อมต่อ Internet');
        _AlertNet(context);
        setState(() {
          CheckNet = false;
        });
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }

  _AlertNet(context) {
    Alert(
      context: context,
      title: "การเชื่อมต่ออินเตอร์เน็ตล้มเหลว",
      desc: "โปรเชื่อมต่อ อินเตอร์เน็ต",
    ).show();
  }

// dialog
  Future<void> _handleClickMe() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
              'Allow "Maps" to access your location while you use the app?'),
          content: Text(
              'Your current location will be displayed on the map and used for directions, nearby search results, and estimated travel times.'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Don\'t Allow'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('Allow'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  var pass = '';
// dialog
  @override
  Widget build(BuildContext context) {
    // chackAuth(context);
    // print(auth);
    return Scaffold(
      key: scaffoldkey,
      backgroundColor: Theme.of(context).accentColor,
      body: Center(
        
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 30, left: 100, right: 100),
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              vertical: 30, horizontal: 20),
                          margin: EdgeInsets.symmetric(
                              vertical: 30, horizontal: 30),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).primaryColor,
                              boxShadow: [
                                BoxShadow(
                                    color: Theme.of(context)
                                        .hintColor
                                        .withOpacity(0.2),
                                    offset: Offset(0, 10),
                                    blurRadius: 20)
                              ]),
                          child: Form(
                            key: globalFormKey,
                            child: Column(
                              children: <Widget>[
                                // SizedBox(
                                //   height: 25,
                                // ),

                                Image.asset(
                                  'assets/images/egg.png',
                                  width: 200,
                                ),
                                Text("ล็อกอิน",
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 100, right: 100),
                                  child: TextFormField(
                                    style: TextStyle(color: Colors.white),
                                    keyboardType: TextInputType.emailAddress,
                                    controller: _emailController,
                                    validator: (input) {
                                      if (!input!.contains('@')) {
                                        return "กรุนาใส่ อีเมล์ให้ถูกต้องด้วยครับ *-*";
                                      }
                                      if (input.isEmpty) {
                                        return "กรุนาใส่ อีเมล์ด้วยครับ *-*";
                                      }
                                      return null;
                                    },
                                    decoration: new InputDecoration(
                                      hintText: "Email",
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white)),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: Colors.white,
                                      )),
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                // password
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 100, right: 100),
                                  child: TextFormField(
                                    style: TextStyle(color: Colors.white),
                                    keyboardType: TextInputType.text,
                                    controller: _passwordController,
                                    validator: (input) => input!.isEmpty == true
                                        ? "กรุณาใส่รหัสผ่านให้ด้วยครับ -__-! "
                                        : null,
                                    obscureText: hidePassword,
                                    decoration: new InputDecoration(
                                      hintText: "Password",
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white)),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: Colors.white,
                                      )),
                                      prefixIcon: Icon(
                                        Icons.password,
                                        color: Colors.white,
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            hidePassword = !hidePassword;
                                          });
                                        },
                                        color: Colors.white,
                                        icon: Icon(hidePassword
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30),
                                FlatButton(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 80,
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      _isButtonDisabled = true;
                                    });
                                    bool pass =
                                        globalFormKey.currentState!.validate();
                                    // print(pass);
                                    if (pass == false) {
                                      setState(() {
                                        _isButtonDisabled = false;
                                      });
                                    }
                                    if (pass) {
                                      setState(() {
                                        data['username'] =
                                            _emailController.text;
                                        data['password'] =
                                            _passwordController.text;
                                      });
                                      // print(data);
                                      if (CheckNet &&
                                          _isButtonDisabled == true) {
                                        var res = await Network()
                                            .authData(data, '/login');
                                        // print(res.statusCode);
                                        // print(res.body);
                                        var body = json.decode(res.body);
                                        print(data);

                                        // CircularProgressIndicator();
                                        if (res.statusCode == 200) {
                                          if (body['sucess'] != null) {
                                            SharedPreferences localStorage =
                                                await SharedPreferences
                                                    .getInstance();
                                            localStorage.setString('token',
                                                json.encode(body['token']));
                                            localStorage.setString('user',
                                                json.encode(body['user']));
                                            localStorage.setString('branch',
                                                json.encode(body['branch']));
                                                  print("body['branch']");
                                                  print(body['branch']);
                                            print('exit page login ');
                                            Navigator.of(context)
                                                .pushNamedAndRemoveUntil(
                                                    SaleWholosale.RouteName,
                                                    (route) => false);
                                          } else if (body['error'] != null) {
                                            setState(() {
                                              _isButtonDisabled = false;
                                            });
                                            print(body);
                                            showToast(
                                                'email หรือ password ไม่ถูกต้องนะครับ');
                                            // print("body['sucess']");
                                            // print(body['sucess']);
                                          }
                                        } else {
                                          print(res.statusCode);
                                          print('connect failed');
                                          _handleClickMe();
                                        }
                                      } else {
                                        _AlertNet(context);
                                      }
                                    }
                                    // _emailController.text.contains('@')
                                    //     ? showToast('Email ไม่ถูกต้อง')
                                    //     : print(_emailController.text);
                                    // print(_passwordController.text);

                                    // print(data);
                                  },
                                  child: _isButtonDisabled == true
                                      ? CircularProgressIndicator()
                                      : Text(
                                          'ลงชื่อเข้าใช้',
                                          style: TextStyle(
                                              color: Colors.orange,
                                              fontSize: 20),
                                        ),
                                  color: Colors.white,
                                  shape: StadiumBorder(),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // void chackAuth(BuildContext context) {
  //    var sst =  Network().checkAuth() ;
  //      print('sst $sst');
  //   if (sst != null) {
  //      print(sst);
  //      setState(() {
  //        isAuth = true;
  //      });
    
  //   }
  //   print('isAuth $isAuth');
  //    if(isAuth == true) {
  //       Navigator.of(context).pushNamedAndRemoveUntil(SaleWholosale.RouteName, (route) => false);
  //  }
  // }
}



// Future<void> loginFn() async {

// }
