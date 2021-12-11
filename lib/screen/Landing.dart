import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pos/provider/printer_bluetooth.dart';
import 'package:pos/screen/login.dart';
import 'package:pos/screen/sale_wholosale.dart';
import 'package:provider/provider.dart';
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
  void initState() {
    super.initState();
  }

  start() async {
  //  await ;
  //  await ;
  //  await 
   
    // var data = await ;
    // print('Connect $data');
  }

  @override
  void dispose() {
    super.dispose();
    // Provider.of<ESC>(context, listen: false).stopScanDevices();
  }

  @override
  Widget build(BuildContext context) {
    checkAuth().then((success) {
      if (success) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(Login.RouteName, (route) => false);
      } else {
        // start();
        Provider.of<ESC>(context, listen: false).getBranch();
        Provider.of<ESC>(context, listen: false).startScanDevices();
        Provider.of<ESC>(context, listen: false).selectDevices();
       
        Navigator.of(context)
            .pushNamedAndRemoveUntil(SaleWholosale.RouteName, (route) => false);
      }
    });

    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
