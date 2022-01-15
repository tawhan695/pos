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
import 'package:pos/provider/remove_provider.dart';
import 'package:pos/screen/customer.dart';
import 'package:pos/screen/login.dart';
import 'package:pos/screen/receipt.dart';
import 'package:pos/screen/remove_product/remove_product.dart';
import 'package:pos/screen/sale_wholosale.dart';
import 'package:pos/screen/setting.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);
  static const RouteName = "product_screen";

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final _advancedDrawerController = AdvancedDrawerController();
  String _connectionStatus = 'Unknown';
  String dropdownValue = 'แตก';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  List<ProductModel> PRODUCT = [];
  List<CatagoryModel> Catagory = [];
  final _controller_2 = TextEditingController();
  var search = '';
  List removeQTY = [];
  bool Issearch = false;
  String URL = 'https://tawhan.xyz/';
  @override
  void initState() {
    get_sum();
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    getProducts('all');
    getCatagory();
    getuser();
    // Provider.of<RemoveProvider>(context,listen: false).get_sum();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
    // _controller_2.dispose();
  }

  get_sum() async {
    List sum = [];
    final res = await Network().getData3('/product/defective/show');
    if (res != 'error') {
      List sum = json.decode(res.body)['sum'];
      print('sum >> $sum');
      removeQTY = sum;
    }
  }

  void saveRemove(id_product, qty, status) {
    print("$id_product,$qty,$status");
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
                  e['image'],
                  e['wholesaler'],
                  
                  );
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
                e['image'],
                e['wholesaler']       
                );
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

   String name_ = '';
  String email_ = '';
  getuser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    setState(() {
      var User = jsonDecode(localStorage.getString('user').toString());
      // print(dara);
      name_ = User['name'];
      email_ = User['email'];
      print(User);
    });
  }
  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

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
                  child: Text('$name_',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                Container(
                  child: Text('email:$email_',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
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
                  leading: Icon(Icons.remove_shopping_cart),
                  title: Text(
                    'สินค้าชำรุด',
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
                                if (index == 0) {
                                  getProducts('all');
                                } else {
                                  getProducts('${Catagory[index].id}');
                                }
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Isselect == index
                                    ? Colors.orange
                                    : Colors.white,
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
                                  child: Text(
                                Catagory[index].name == 'all'
                                    ? 'ทั้งหมด'
                                    : '${Catagory[index].name}',
                                style: TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.bold,
                                    color: Isselect == index
                                        ? Colors.black
                                        : Colors.grey),
                              )),
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
                        var sum = '0';
                        for (var i = 0; i < removeQTY.length; i++) {
                          if (PRODUCT[index].id == removeQTY[i]['product_id']) {
                            print(removeQTY[i]);
                            sum = removeQTY[i]['sum'];
                            break;
                          }
                        }
                        return Container(
                          height: 226,
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
                                      Row(
                                        children: [
                                          Text(
                                              'ชำรุด :$sum ${PRODUCT[index].unit}',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.grey)),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          ElevatedButton(
                                              onPressed: PRODUCT[index].qty < 1
                                                  ? null
                                                  : () {
                                                      StateSetter _setState;
                                                      // String _demoText = "test";
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            content:
                                                                StatefulBuilder(
                                                              // You need this, notice the parameters below:

                                                              builder: (BuildContext
                                                                      context,
                                                                  StateSetter
                                                                      setState) {
                                                                _setState =
                                                                    setState;
                                                                return Center(
                                                                  child: Column(
                                                                    children: <
                                                                        Widget>[
                                                                      SizedBox(
                                                                        width:
                                                                            100,
                                                                        height:
                                                                            40,
                                                                      ),
                                                                      Text(
                                                                          "เพิ่มสินค้าที่เสียหาย ใส่จำนวน \"${PRODUCT[index].unit}\" ให้ถูกต้อง  ",
                                                                          style:
                                                                              TextStyle(fontSize: 21)),
                                                                      TextField(
                                                                        maxLength:
                                                                            6,
                                                                        autofocus:
                                                                            true,
                                                                        keyboardType:
                                                                            TextInputType.number,
                                                                        controller:
                                                                            _controller_2,
                                                                      ),
                                                                      Container(
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: <
                                                                              Widget>[
                                                                            // Checkbox(
                                                                            //     checkColor:
                                                                            //         Colors.white,
                                                                            //     fillColor: MaterialStateProperty
                                                                            //         .resolveWith(
                                                                            //             getColor),
                                                                            //     value: isChecked,
                                                                            //     onChanged: (bool?
                                                                            //         value) {
                                                                            //       setState(() {
                                                                            //         isChecked =
                                                                            //             value!;
                                                                            //       });
                                                                            //     }),
                                                                            Text('ประเภทควาเสียหาย',
                                                                                style: TextStyle(fontSize: 20)),
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: DropdownButton<String>(
                                                                                value: dropdownValue,
                                                                                icon: const Icon(Icons.arrow_downward),
                                                                                iconSize: 24,
                                                                                elevation: 16,
                                                                                style: const TextStyle(color: Colors.deepPurple),
                                                                                underline: Container(
                                                                                  height: 2,
                                                                                  color: Colors.deepPurpleAccent,
                                                                                ),
                                                                                onChanged: (String? newValue) {
                                                                                  setState(() {
                                                                                    dropdownValue = newValue!;
                                                                                  });
                                                                                },
                                                                                items: <String>[
                                                                                  'แตก',
                                                                                  'เน่า',
                                                                                  'บุป/ร้าว',
                                                                                ].map<DropdownMenuItem<String>>((String value) {
                                                                                  return DropdownMenuItem<String>(
                                                                                    value: value,
                                                                                    child: Text(value),
                                                                                  );
                                                                                }).toList(),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                          children: [
                                                                            DialogButton(
                                                                                child: Text(
                                                                                  "บันทึก",
                                                                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                                                                ),
                                                                                color: Colors.green,
                                                                                onPressed:
                                                                                    // _controller_2.value.text.isNotEmpty ?
                                                                                    () async {
                                                                                  bool load = true;
                                                                                  // saveRemove(
                                                                                  //     PRODUCT[index].id,
                                                                                  //     _controller_2.text,
                                                                                  //     dropdownValue);
                                                                                  // Navigator.pop(context);

                                                                                  onLoadAlert(context);
                                                                                  var data = {
                                                                                    'id': PRODUCT[index].id,
                                                                                    'defective': _controller_2.value.text,
                                                                                    // 'defective': 5,
                                                                                    'status': '${dropdownValue}',
                                                                                    // 'status': 'แตก',
                                                                                  };
                                                                                  print(data);
                                                                                  print(_controller_2.text);
                                                                                  _controller_2.text = '';
                                                                                  // product/defective/add
                                                                                  final response = await Network().getData(data, '/product/defective/add');
                                                                                  if (response.statusCode == 200) {
                                                                                    var body = json.decode(response.body);
                                                                                    print(body);
                                                                                    // if (body['success'] == 'บันทึกเรียบร้อย') {
                                                                                    // Navigator.pop(context);
                                                                                    Navigator.pushNamed(context, ProductScreen.RouteName);
                                                                                    // getProducts('all');
                                                                                    // Navigator.of(context).pushNamed(ProductScreen.RouteName);
                                                                                    // } else {
                                                                                    //   Navigator.pop(context);
                                                                                    // }
                                                                                  }
                                                                                }
                                                                                // :null
                                                                                ),
                                                                            DialogButton(
                                                                              child: Text(
                                                                                "ยกเลิก",
                                                                                style: TextStyle(color: Colors.white, fontSize: 20),
                                                                              ),
                                                                              onPressed: () => Navigator.pop(context),
                                                                              color: Colors.red,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                              child: Text('เพิ่มในรายการชำรุด',
                                                  style:
                                                      TextStyle(fontSize: 16))
                                              // : CircularProgressIndicator()
                                              ),
                                        ],
                                      )
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

  void onLoadAlert(context) {
    Alert(
        context: context,
        content: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
            ),
            Text('รอสักครู่', style: TextStyle(fontSize: 25)),
            SizedBox(
              width: 10,
            ),
            CircularProgressIndicator(),
          ],
        ))).show();
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}
