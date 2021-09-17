import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos/network_api/api.dart';
import 'package:pos/screen/sale_retail.dart';
import 'package:pos/screen/sale_wholosale.dart';
import 'package:shared_preferences/shared_preferences.dart';

var data = {
  'username': 'admin@gmail.com',
  'password': '123456789',
  'device_name': 'mobile'
};

class Login extends StatefulWidget {
  static const RouteName = '/login';
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final scaffoldkey = GlobalKey<ScaffoldState>();

  GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();

  bool hidePassword = true;

  void initState() {
    super.initState();
    print('Login page');
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

// dialog
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      backgroundColor: Theme.of(context).accentColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  margin: EdgeInsets.symmetric(vertical: 80, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).primaryColor,
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).hintColor.withOpacity(0.2),
                            offset: Offset(0, 10),
                            blurRadius: 20)
                      ]),
                  child: Form(
                    key: globalFormKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 25,
                        ),
                        Text("Login",
                            style: Theme.of(context).textTheme.headline2),
                        SizedBox(
                          height: 20,
                        ),
                        new TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          validator: (input) => input!.contains('@')
                              ? "Email Id should be Valid"
                              : null,
                          decoration: new InputDecoration(
                            hintText: "Email",
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.2))),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Theme.of(context).accentColor,
                            )),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        // password
                        new TextFormField(
                          keyboardType: TextInputType.text,
                          validator: (input) => input!.length < 8
                              ? "Password should be more than 3 charact"
                              : null,
                          obscureText: hidePassword,
                          decoration: new InputDecoration(
                            hintText: "Password",
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.2))),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Theme.of(context).accentColor,
                            )),
                            prefixIcon: Icon(
                              Icons.password,
                              color: Theme.of(context).accentColor,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                              color: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.4),
                              icon: Icon(hidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
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
                            var res = await Network().authData(data, '/login');
                            var body = json.decode(res.body); 
                             print(body);
                            if (res.statusCode == 200) {
                              if (body['sucess']) {
                                SharedPreferences localStorage =
                                    await SharedPreferences.getInstance();
                                localStorage.setString(
                                    'token', json.encode(body['token']));
                                localStorage.setString(
                                    'user', json.encode(body['user']));
                                print('exit page login ');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      // builder: (context) => SaleRetail()),
                                      builder: (context) => SaleWholosale()),
                                );
                                // var token = jsonDecode(localStorage.getString('token').toString());
                                // print(token);
                              } else {
                                print(body['sucess']);
                              }
                            } else {
                              print(res.statusCode);
                              print('connect failed');
                              _handleClickMe();
                            }
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(color: Colors.black),
                          ),
                          color: Color(0xffFFD600),
                          shape: StadiumBorder(),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

// Future<void> loginFn() async {

// }
