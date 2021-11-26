import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pos/screen/login.dart';
import 'package:pos/screen/sale_wholosale.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Landing extends StatefulWidget {
  static const RouteName = '/landing';

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  checkAuth() async {
    final pref = await SharedPreferences.getInstance();
    var token2 = jsonDecode(pref.getString('token').toString());
    print(token2);
    if (token2 == null) {
      return true;
    } else {
      return false;
    }
  }
 @override
  Widget build(BuildContext context) {
    checkAuth().then((success) {
      if (success) {
        Navigator.of(context).pushNamedAndRemoveUntil(
                        Login.RouteName, (route) => false);
      } else {
         Navigator.of(context).pushNamedAndRemoveUntil(
                        SaleWholosale.RouteName, (route) => false);
      }
    });

    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
