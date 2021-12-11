import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:pos/models/order_model.dart';
import 'package:pos/network_api/api.dart';
import 'package:pos/provider/customer_provider.dart';
import 'package:pos/provider/list_order_provider.dart';
import 'package:pos/screen/customer.dart';
import 'package:pos/screen/login.dart';
// import 'package:pos/screen/page_emty.dart';
import 'package:pos/screen/product/product.dart';
import 'package:pos/screen/remove_product/remove_product.dart';
import 'package:pos/screen/sale_wholosale.dart';
import 'package:pos/screen/setting.dart';
import 'package:provider/provider.dart';

import 'order_details/order_details.dart';

import 'package:connectivity/connectivity.dart';
import 'dart:async';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/services.dart';

class Receipt extends StatefulWidget {
  static const RouteName = '/receipt';
  // const Receipt({ Key? key }) : super(key: key);

  @override
  _ReceiptState createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  final _advancedDrawerController = AdvancedDrawerController();
  var _search = TextEditingController();
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool CheckNet = false;

  int  maxPage = 0;
  var  current_page = 0;

   oderPage() async {
      final res =   await Network().getData3('/order');
      if (res != 'error'){
        var links = json.decode(res.body)['order']['links'];
        //  current_page = json.decode(res.body)['order']['current_page'];
        //  setState(() {
        //    current_page
        //  });
  // var body2 = json.decode(res.body)['detail'];
    if(res.statusCode == 200){
      maxPage = links.length - 2;
      
      }
    }

  }
  int Nnext = 0;
setState_net(int page){
    // setState(() {
    // });
      Nnext += page;

      if (Nnext < 0){
        Nnext = maxPage;
      }else if (Nnext > maxPage){
        Nnext = 0;
      }
    print(Nnext);
       setState(() {
           current_page= Nnext;
         });
    print("maxPage $maxPage");
    Provider.of<ListOrderProvider>(context, listen: false).initListorder(Nnext);
}
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    oderPage();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    Provider.of<ListOrderProvider>(context, listen: false).initListorder(0);
    Provider.of<CustomerProvider>(context, listen: false).initCustomer();
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
        setState(() {
          CheckNet = true;
        });
        break;
      case ConnectivityResult.mobile:
        setState(() => _connectionStatus = result.toString());
        print(' Internet ${result.toString()}');
        setState(() {
          CheckNet = true;
        });
        break;
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        print('โปรดเชื่อมต่อ Internet');
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
                Center(
                  child: Text('ออกจากระบบ'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        SaleWholosale.RouteName, (route) => false);
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
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        Receipt.RouteName, (route) => false);
                  },
                  leading: Icon(
                    Icons.list_alt_rounded,
                    color: Colors.orange,
                  ),
                  tileColor: Colors.white,
                  title: Text(
                    'ใบเสร็จ',
                    style: TextStyle(color: Colors.orange),
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
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        Customer.RouteName, (route) => false);
                  },
                  leading: Icon(Icons.person),
                  title: Text('ลูกค้า'),
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
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        Setting.RouteName, (route) => false);
                  },
                  leading: Icon(Icons.settings),
                  title: Text('ตั้งค่า'),
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
                    child: Text('Terms of Service | Privacy Policy'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tawhan POS ( มัทนาไข่สด )'),
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
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(children: <Widget>[
            Center(
                child: Text(
              'รายการใบเสร็จ',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            )),
            Padding(
              padding: const EdgeInsets.only(
                  left: 200.0, right: 200, top: 0, bottom: 20),
              child: Center(
                child: TextField(
                  controller: _search,
                  onChanged: (text) {
                    // print(text);
                    Provider.of<ListOrderProvider>(context, listen: false)
                        .getSearch(text);
                  },
                  decoration: InputDecoration(
                    hintText: 'เลขที่ใบเสร็จ',
                    icon: Icon(
                      Icons.search,
                      size: 40,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _search.clear();
                          Provider.of<ListOrderProvider>(context, listen: false)
                              .clear_search();
                        });
                      },
                      icon: Icon(Icons.clear),
                    ),
                    // border: OutlineInputBorder(
                    //   borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    // ),
                  ),
                ),
              ),
            ),
            
            Consumer(builder:
                (BuildContext context, ListOrderProvider listorder, Widget) {
              var data = listorder.getListorder();
              return DataTable(
                columns: [
                  DataColumn(
                      label: Text('ใบเสร็จ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('ลูกค้า',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                  // DataColumn(label: Text(
                  //     'รายการ',
                  //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                  // )),
                  DataColumn(
                      label: Text('วันที่',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('ชำระโดย',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('รวมทั้งสิ้น',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('จัดการ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                ],
                rows: data
                    .map(
                      (e) => DataRow(cells: [
// CustomerProvider
                        DataCell(Text('${e.id}')),
                        DataCell(Provider.of<CustomerProvider>(context,
                                        listen: false)
                                    .getName(e.customer_id.toString())
                                    .length <
                                1
                            ? Text('-')
                            : Text(
                                '${Provider.of<CustomerProvider>(context, listen: false).getName(e.customer_id.toString())}')),
                        // DataCell(Text('${e.customer_id}')),
                        DataCell(Text('${e.created_at}')),
                        DataCell(Text('${e.paid_by}')),
                        DataCell(Text('฿${e.net_amount}')),
                        DataCell(IconButton(
                            onPressed: () {
                              if (CheckNet == false) {
                                _AlertNet(context);
                              } else {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        OrderDetail("${e.id}", e)));
                              }
                              // OrderDetail(title: );
                              // Navigator.of(context).pushNamed(OrderDetail.RoteName);
                            },
                            icon: Icon(
                              Icons.list_alt,
                              color: Colors.orange,
                              size: 40,
                            ))),
                      ]),
                    )
                    .toList(),
              );
            }),
            
            Container(child:Row(
              crossAxisAlignment:CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: ()=>setState_net(-1), icon: Icon(Icons.arrow_back_ios,size: 40)),
                Container(child: 
                current_page == 0 ?
                Text('หน้าแรก'):
                Text('หน้า $current_page')
                ),
                IconButton(onPressed: ()=>setState_net(1), icon: Icon(Icons.arrow_forward_ios,size: 40)),
              ],
            ) ,),
          ]),
        ),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}
