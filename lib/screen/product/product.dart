import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:pos/models/catagory_model.dart';
import 'package:pos/models/product_model.dart';
import 'package:pos/network_api/api.dart';
import 'package:pos/provider/order_provider.dart';
import 'package:pos/screen/customer.dart';
import 'package:pos/screen/receipt.dart';
import 'package:pos/screen/sale_wholosale.dart';
import 'package:pos/screen/setting.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);
  static const RouteName = "product_screen";

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final _advancedDrawerController = AdvancedDrawerController();
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  List<ProductModel> PRODUCT = [];
  List<CatagoryModel> Catagory = [];
  var search = '';
  bool Issearch = false;
  String URL = 'https://tawhan.xyz/';
  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    getProducts('all');
    getCatagory();
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

  _AlertNet(context) {
    Alert(
      context: context,
      title: "การเชื่อมต่ออินเตอร์เน็ตล้มเหลว",
      desc: "โปรเชื่อมต่อ อินเตอร์เน็ต",
    ).show();
  }

  getCatagory() async {
    final response = await Network().getData2('/catagory');
    List<CatagoryModel> _listCatagory = [];
    if (response == 'error') {
      // _AlertNet(context);
    } else {
      var body = json.decode(response.body);
      CatagoryModel catagory = CatagoryModel(-1, 'all');
      CatagoryModel search = CatagoryModel(-2, 'search');
      // _listCatagory.add(search);
      _listCatagory.add(catagory);
      body.forEach((e) {
        CatagoryModel catagory = CatagoryModel(e['id'], e['name']);
        _listCatagory.add(catagory);
      });
      // print(_listCatagory.length);
    }
    setState(() {
      Catagory = _listCatagory;
    });
  }

  getProducts(catagory_id) async {
    var sale_id = 0;
    var res;
    if (catagory_id == 'all') {
      res = await Network().getData({'sale': '$sale_id'}, '/product');
    } else {
      res = await Network().getData(
          {'sale': '$sale_id', 'catagory': '$catagory_id'}, '/product');
    }

    List<ProductModel> productModel = [];
    if (res == 'error') {
      // _AlertNet(context);
    } else {
      var body = json.decode(res.body);
      body.forEach(
        (e) {
          if (Issearch) {
            if (search == e['name'] ||
                search == e['id'] ||
                search == e['sku']) {
              ProductModel products = ProductModel(
                  e['id'],
                  e['name'],
                  e['sku'],
                  e['unit'],
                  e['retail_price'],
                  e['wholesale_price'],
                  e['sale_price'],
                  e['qty'],
                  e['image']);
              productModel.add(products);
            }
          } else {
            ProductModel products = ProductModel(
                e['id'],
                e['name'],
                e['sku'],
                e['unit'],
                e['retail_price'],
                e['wholesale_price'],
                e['sale_price'],
                e['qty'],
                e['image']);
            productModel.add(products);
          }
        },
      );
    }
    setState(() {
      PRODUCT = productModel;
    });
  }
  int Isselect = 0;
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
                        Customer.RouteName, (route) => false);
                  },
                  leading: Icon(
                    Icons.person,
                  ),
                  title: Text(
                    'ลูกค้า',
                    //  style: TextStyle(color: Colors.orange),
                  ),
                ),
                ListTile(
                  onTap: () {
                    //  Navigator.of(context).pushNamedAndRemoveUntil(Customer.RouteName, (route) => false);
                    Navigator.of(context).pushNamed(ProductScreen.RouteName);
                  },
                  leading: Icon(
                    Icons.card_travel,
                    color: Colors.orange,
                  ),
                  tileColor: Colors.white,
                  title: Text(
                    'รายการสินค้า',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        Setting.RouteName, (route) => false);
                  },
                  leading: Icon(
                    Icons.settings,
                  ),
                  // tileColor: Colors.white,
                  title: Text('ตั้งค่า'),
                ),
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
        body: Container(
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  child: CustomScrollView(slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                Isselect = index;
                                if(index == 0){

                                getProducts('all');
                                }else{
                                getProducts('${Catagory[index].id}');
                                }
                              });
                            },
                            child: Container(
                              
                              decoration: BoxDecoration(
                                color: 
                                Isselect == index?
                                Colors.orange:
                                Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              height: 80,
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(10),
                              child: Center(
                                child:
                                 Text(
                                 Catagory[index].name =='all'? 
                                  'ทั้งหมด'
                                  :'${Catagory[index].name}',
                                  style: TextStyle(
                                      fontSize: 27,
                                      fontWeight: FontWeight.bold,
                                      color: 
                                      Isselect == index?
                                      Colors.black:
                                      Colors.grey
                                      ),
                                )
                                

                              ),
                            ),
                          );
                        },
                        childCount: Catagory.length,
                      ),
                    ),
                  ]),
                ),
              ),
              Expanded(
                flex: 9,
                child: CustomScrollView(slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Container(
                          height: 200,
                          width: double.infinity,
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(15),
                                child: Image.network(
                                  "${URL + PRODUCT[index].image}",
                                  fit: BoxFit.contain,
                                  width: 200,
                                  height: 200,
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
                              Container(
                                  margin: EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('${PRODUCT[index].name}',
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold)),
                                      Text('รหัสสินค้า ${PRODUCT[index].sku}',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.grey)),
                                      Container(
                                        child: Row(
                                          children: [
                                            Text('ราคา :',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.grey)),
                                            Text(
                                                '  (ปลีก) ${PRODUCT[index].wholesale_price}',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.grey)),
                                            Text(
                                                '  (ส่ง) ${PRODUCT[index].retail_price}',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.grey)),
                                          ],
                                        ),
                                      ),
                                      Text(
                                          'คลัง :  ${PRODUCT[index].qty} ${PRODUCT[index].unit}',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.grey)),
                                    ],
                                  ))
                            ],
                          ),
                        );
                      },
                      childCount: PRODUCT.length,
                    ),
                  ),
                ]),
              ),
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
}
