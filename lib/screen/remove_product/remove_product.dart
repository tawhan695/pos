import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:intl/intl.dart';
import 'package:pos/models/order_model.dart';
import 'package:pos/models/product_model.dart';
import 'package:pos/models/remove_model.dart';
import 'package:pos/network_api/api.dart';
import 'package:pos/provider/customer_provider.dart';
import 'package:pos/provider/list_order_provider.dart';
import 'package:pos/provider/product_provider.dart';
import 'package:pos/provider/remove_provider.dart';
import 'package:pos/screen/customer.dart';
import 'package:pos/screen/login.dart';
import 'package:pos/screen/order_details/order_details.dart';
import 'package:pos/screen/product/product.dart';
import 'package:pos/screen/receipt.dart';
import 'package:pos/screen/sale_wholosale.dart';
import 'package:pos/screen/setting.dart';
import 'package:provider/provider.dart';

// import 'order_details/order_details.dart';

import 'package:connectivity/connectivity.dart';
import 'dart:async';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/services.dart';

class RemoveProduct extends StatefulWidget {
  static const RouteName = '/RemoveProduct';
  // const RemoveProduct({ Key? key }) : super(key: key);

  @override
  _RemoveProductState createState() => _RemoveProductState();
}

class _RemoveProductState extends State<RemoveProduct> {
  final _advancedDrawerController = AdvancedDrawerController();
  var _search = TextEditingController();
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool CheckNet = false;
  var product;
  int maxPage = 0;
  var current_page = 0;
  int ii = 1;
  List<ProductModel> _products2 = [];
  String URL = 'https://tawhan.xyz/';

  oderPage() async {
    final res = await Network().getData3('/product/defective');
    if (res != 'error') {
      var links = json.decode(res.body)['defective']['links'];
      //  current_page = json.decode(res.body)['order']['current_page'];
      //  setState(() {
      //    current_page
      //  });
      // var body2 = json.decode(res.body)['detail'];
      if (res.statusCode == 200) {
        maxPage = links.length - 2;
      }
    }
  }

  int Nnext = 0;
  setState_net(int page) {
    // setState(() {
    // });
    Nnext += page;

    if (Nnext < 0) {
      Nnext = maxPage;
    } else if (Nnext > maxPage) {
      Nnext = 0;
    }
    print(Nnext);
    setState(() {
      current_page = Nnext;
    });
    print("maxPage $maxPage");
    Provider.of<RemoveProvider>(context, listen: false).initRemove(Nnext);
  }

  getDate(date) {
    date = '2021-01-26T03:17:00.000000Z';
    DateTime parseDate =
        new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('MM/dd/yyyy hh:mm ');
    var outputDate = outputFormat.format(inputDate);
    print(outputDate);
    return outputDate;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    oderPage();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    // setproduct();
    Provider.of<ProductProvider>(context, listen: false).initData('0', 'all');

    Provider.of<RemoveProvider>(context, listen: false).initRemove(0);
    // getName(28);
    setState(() {
      // _products2 = Provider.of<ProductProvider>(context, listen: false).initData('0','all');
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // int _page = 1;
  // List _data = [];
  // Future<List<dynamic>> getremove(page) async {
  //   List data = [];
  //   // print('22');
  //   var response;
  //   if (page == 0) {
  //     response = await Network().getData3('/product/defective');
  //   } else {
  //     response = await Network().getData3('/product/defective?page=$page');
  //   }
  //   var body = json.decode(response.body)['defective']['data'];
  //   data = body;
  //   _data = body;
  //   print(data);
  //   // setState(() {
  //   //   _page = body['current_page'];
  //   //   print('_page $_page');
  //   // });

  //   return data;
  // }
  // setproduct()  {
  //   // product =
  //   // print(product);
  // // _product.forEach((e){
  // //   // print(e.name);
  // //   // print(e.id);
  // //   product['${e.id}'] = e.name;
  //   // print(product[0]);
  // // });
  // }

  getName(id) {
    var name = '';
    for (var i = 0; i < product.length; i++) {
      // print(product[i].name);
      // print(name+'$id');
      if (product[i].id == id) {
        name = product[i];
        // print(id);
        break;
      }
    }
    return name;
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
                  ),
                  title: Text(
                    'ใบเสร็จ',
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        RemoveProduct.RouteName, (route) => false);
                  },
                  tileColor: Colors.white,
                  leading: Icon(
                    Icons.remove_shopping_cart,
                    color: Colors.orange,
                  ),
                  title: Text(
                    'สินค้าชำรุด',
                    style: TextStyle(color: Colors.orange),
                  ),
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
              'รายการสินค้าชำรุด',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            )),

            // Padding(
            //   padding: const EdgeInsets.only(
            //       left: 200.0, right: 200, top: 0, bottom: 20),
            //   child: Center(
            //     child: TextField(
            //       controller: _search,
            //       onChanged: (text) {
            //         // print(text);
            //         Provider.of<ListOrderProvider>(context, listen: false)
            //             .getSearch(text);
            //       },
            //       decoration: InputDecoration(
            //         hintText: 'เลขที่ใบเสร็จ',
            //         icon: Icon(
            //           Icons.search,
            //           size: 40,
            //         ),
            //         suffixIcon: IconButton(
            //           onPressed: () {
            //             setState(() {
            //               _search.clear();
            //               Provider.of<ListOrderProvider>(context, listen: false)
            //                   .clear_search();
            //             });
            //           },
            //           icon: Icon(Icons.clear),
            //         ),
            //         // border: OutlineInputBorder(
            //         //   borderRadius: BorderRadius.all(Radius.circular(0.0)),
            //         // ),
            //       ),
            //     ),
            //   ),
            // ),

            Consumer(builder: (context, RemoveProvider remove, Widget) {
              var data = remove.getRemove();
              ii = 1;
              if (data.length > 0) {
                return Container(
                  // padding: EdgeInsets.only(left:50,right:50),
                  child: DataTable(
                    columns: [
                      DataColumn(
                        label: Text(
                          '#',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'สินค้า',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'สถานะ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'จำนวนเสียหาย',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'วันเดือนปี/เวลา',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows: data
                        .map(
                          (e) => DataRow(
                            cells: [
                              DataCell(
                                Image.network(
                                  "${URL + Provider.of<ProductProvider>(context, listen: false).getName(e.product_id)['img'].toString()}",
                                  fit: BoxFit.contain,
                                  width: 50,
                                  // height: 200,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                        child: CircularProgressIndicator());
                                  },
                                  errorBuilder:
                                      (context, exception, stackTrack) => Icon(
                                    Icons.error,
                                  ),
                                ),
                              ),
                              // DataCell(Text('${}')),
                              // DataCell(Text("${ product['$id']}")),
                              DataCell(Text(
                                  '${Provider.of<ProductProvider>(context, listen: false).getName(e.product_id)['name']}')),
                              DataCell(Text('${e.status}')),
                              DataCell(Text('${e.qty}')),
                              DataCell(Text(getDate(e.date))),
                              // DataCell(Text(e.date)),
                              // DataCell(Text(DateFormat('yyyy/MM/dd HH:mm:ss').parse(_data[i]['created_at']).toString()),),
                              // print();
                            ],
                          ),
                        )
                        .toList(),

                    // Text(snapshot.data[0]['status']
                  ),
                );
              } else {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            }),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () => setState_net(-1),
                      icon: Icon(Icons.arrow_back_ios, size: 40)),
                  Container(
                      child: current_page == 0
                          ? Text('หน้า 1')
                          : Text('หน้า $current_page')),
                  IconButton(
                      onPressed: () => setState_net(1),
                      icon: Icon(Icons.arrow_forward_ios, size: 40)),
                ],
              ),
            ),
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
