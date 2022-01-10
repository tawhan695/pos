import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:pos/network_api/api.dart';
import 'package:pos/provider/printer_bluetooth.dart';
import 'package:pos/screen/customer.dart';
import 'package:pos/screen/login.dart';
import 'package:pos/screen/printter/printter.dart';
import 'package:pos/screen/product/product.dart';
import 'package:pos/screen/receipt.dart';
import 'package:pos/screen/remove_product/remove_product.dart';
import 'package:pos/screen/sale_wholosale.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Setting extends StatefulWidget {
  // const Setting({ Key? key }) : super(key: key);
  static const RouteName = '/setting';

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final _advancedDrawerController = AdvancedDrawerController();
 
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  getuser();
  Provider.of<ESC>(context, listen: false).startScanDevices();
  // Provider.of<ESC>(context, listen: false).selectDevices();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
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
        print(' Internet ${result.toString()}');
        break;
      case ConnectivityResult.mobile:
        setState(() => _connectionStatus = result.toString());
        print(' Internet ${result.toString()}');
        break;
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        print('โปรดเชื่อมต่อ Internet');
        _AlertNet(context);
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }
  _AlertNet(context){
      Alert(
          context: context,
          title: "การเชื่อมต่ออินเตอร์เน็ตล้มเหลว",
          desc: "โปรเชื่อมต่อ อินเตอร์เน็ต",
        ).show();
  }
    String name_ = '';
  String email_ = '';
  getuser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    setState(() {
     var User= jsonDecode(localStorage.getString('user').toString());
      // print(dara);
     name_= User['name'];
     email_= User['email'];
    print(User);
    });
  }
  @override
  Widget build(BuildContext context) {
      return AdvancedDrawer(
      backdropColor: Color(0xffFF8F33),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      drawer: SafeArea(
        child: Container(
          child: ListTileTheme(
            textColor: Colors.white,
            iconColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 128.0,
                  height: 128.0,
                  margin: const EdgeInsets.only(
                    top: 24.0,
                    // bottom: 64.0,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    // color: Colors.black26,
                    color: Color(0xffFE7300),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/5942.png',
                  ),
                ),
                Container(
                  child: Text(
                  
                    '$name_'
                    ,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                Container(
                  child: Text(
                    
                    'email:$email_',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(SaleWholosale.RouteName, (route) => false);
                  },
                  
                  leading: Icon(
                    Icons.storefront_sharp,
                   
                  ),
                  title: Text(
                    'ขาย',
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(Receipt.RouteName, (route) => false);
                  },
                  leading: Icon(Icons.list_alt_rounded,
                   ),
                  
                  title: Text('ใบเสร็จ',
                  
                  ),
                ),
                 ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        RemoveProduct.RouteName, (route) => false);
                  },
                  leading: Icon(Icons.remove_shopping_cart),
                  title: Text('สินค้าชำรุด',),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(Customer.RouteName, (route) => false);
                  },
                  leading: Icon(Icons.person,
                  
                  ),
                  title: Text('ลูกค้า',
                  //  style: TextStyle(color: Colors.orange),
                  ),
                ),
                ListTile(
                  onTap: () {
                    //  Navigator.of(context).pushNamedAndRemoveUntil(Customer.RouteName, (route) => false);
                    Navigator.of(context).pushNamed(ProductScreen.RouteName);
                  },
                  leading: Icon(Icons.card_travel),
                  title: Text('รายการสินค้า'),
                ),
                ListTile(
                  onTap: () {
                     
                     Navigator.of(context).pushNamedAndRemoveUntil(Setting.RouteName, (route) => false);
                  },
                  leading: Icon(Icons.settings,
                  color: Colors.orange,
                  ),
                  tileColor: Colors.white,
                  title: Text('ตั้งค่า',
                  style: TextStyle(color: Colors.orange),
                  ),
                ),
                ListTile(
                    leading: Icon(Icons.logout),
                    onTap: () async {
                      var stt = await Network().logOut();
                      //print('stt $stt');
                      if (stt == true) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            Login.RouteName, (route) => false);
                      }
                    },
                    title: Text('ออกจากระบบ')),
                Spacer(),
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 16.0,
                    ),
                    child: Text('Terms of Service | Tawhan Studio'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      child: Scaffold(
        
        appBar: AppBar(
          title: const Text('MTN POS'),
          leading: IconButton(
            onPressed: _handleMenuButtonPressed,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 250),
                  child: Icon(
                    value.visible ? Icons.clear : Icons.menu,
                    key: ValueKey<bool>(value.visible),
                  ),
                );
              },
            ),
          ),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 50,horizontal:50),
          child: Column(
            children: <Widget>[
              Card(
                child: ListTile(
                  title: Text('เครื่องพิมพ์',style: TextStyle(fontSize:30)),
                  leading:  Icon(Icons.print,size: 50),
                  onTap: () {   
                    Navigator.push(context,
                          MaterialPageRoute(builder: (_) => Printer()));
                    }
                ),
              ),
              Card(
                child: ListTile(
                  title: Text('อื่นๆ',style: TextStyle(fontSize:30)),
                  leading:  Icon(Icons.settings,size: 50),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text('ข้อมูลสาขา',style: TextStyle(fontSize:30)),
                  leading:  Icon(Icons.home,size: 50),
                ),
              ),

              // Text('setting'),
            ],
          ),
          ),
        ),
        );  
  }
   void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }

  await(Future<ConnectivityResult> checkConnectivity) {}
}