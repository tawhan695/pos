import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:pos/models/cart_model.dart';
import 'package:pos/models/catagory_model.dart';
import 'package:pos/models/product_model.dart';
import 'package:pos/network_api/api.dart';
import 'package:pos/provider/cart_provider.dart';
import 'package:pos/provider/catagory_provider.dart';
import 'package:pos/provider/customer_provider.dart';
import 'package:pos/provider/order_provider.dart';
import 'package:pos/provider/printer_bluetooth.dart';
import 'package:pos/provider/product_provider.dart';
import 'package:pos/screen/cash.dart';
import 'package:pos/screen/customer.dart';
import 'package:pos/screen/dashboard/dashboard.dart';
import 'package:pos/screen/login.dart';
import 'package:pos/screen/product/product.dart';
import 'package:pos/screen/receipt.dart';
import 'package:pos/screen/remove_product/remove_product.dart';
import 'package:pos/screen/sale_widget/cart.dart';
import 'package:pos/screen/setting.dart';
import 'package:pos/screen/user_widget/user.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image/flutter_image.dart';
// import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';


// import 'package:flutter_url/splash_screen.dart';
// import 'package:url_launcher/url_launcher.dart';

class SaleWholosale extends StatefulWidget {
  // SaleWholosale({Key? key}) : super(key: key);
  static const RouteName = '/sale-wholosale';

  @override
  _SaleWholosaleState createState() => _SaleWholosaleState();
}

class _SaleWholosaleState extends State<SaleWholosale> {
  final _advancedDrawerController = AdvancedDrawerController();
  var isActive = 0;
  var sale = '0';
  var catagory = 'all';
  var Typesale = 'wholesale_price';
  var search = '';
  bool Issearch = false;
  String URL = 'https://tawhan.xyz/';
  List<CatagoryModel> _order = [];
  // @override
  // catagory  is a list

  // checkConnectivity
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Future<List<CatagoryModel>> getCatagory() async {
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
      //print(_listCatagory.length);
    }
    return _listCatagory;
  }

  Future<List<ProductModel>> getProducts(sale_id, catagory_id) async {
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
                  e['wholesaler']
                  
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
                e['wholesaler'],
                );
            productModel.add(products);
          }
        },
      );
    }
    return productModel;
  }

  final _controller = TextEditingController();
  final _search = TextEditingController();
  var SUM = 0;
  // var layout =  [[3,25],[4,18]];
  // var selectLayout = 0;
  void showDeitDialog(id, qty) {
    _controller.text = qty.toString();
    // Create button
    //  String qty ='';
    Widget okButton = FlatButton(
      child: Text(
        "??????????????????",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 27, color: Colors.orange),
      ),
      onPressed: () {
        //print(_controller.text);
        Provider.of<CartProvider>(context, listen: false)
            .changQty(id, _controller.text);
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "??????????????????????????????",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 35, color: Colors.orange),
      ),
      content: TextFormField(
        controller: _controller,
        keyboardType: TextInputType.number,
        // inputFormatters: <TextInputFormatter>[
        //   WhitelistingTextInputFormatter.digitsOnly
        // ],
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),],
        decoration: InputDecoration(
          labelText: "?????????????????????????????????",
          hintText: "?????????????????????????????????",
          icon: Icon(
            Icons.edit_outlined,
            size: 26,
          ),
        ),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  start() async {
    //  await Provider.of<ESC>(context, listen: false).getBranch();
    //  await Provider.of<ESC>(context, listen: false).startScanDevices();
    //  await Provider.of<ESC>(context, listen: false).getPrintter();

    //   var data = await Provider.of<ESC>(context, listen: false).getESC();
    //   print('Connect $data');
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuser();

    //  start();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    // Provider.of<OrderProvider>(context, listen: false).initCart();
    print('CartProvider');
    Provider.of<CartProvider>(context, listen: false).innitProduct();
    Provider.of<ProductProvider>(context, listen: false).initData('0', 'all');
    // Provider.of<ESC>(context, listen: false).getPrintter();
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
      // //print(e.toString());
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
        // //print(' Internet ${result.toString()}');
        break;
      case ConnectivityResult.mobile:
        setState(() => _connectionStatus = result.toString());
        // //print(' Internet ${result.toString()}');
        break;
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        // //print('??????????????????????????????????????? Internet');
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
      title: "?????????????????????????????????????????????????????????????????????????????????????????????",
      desc: "???????????????????????????????????? ????????????????????????????????????",
    ).show();
  }

  bool Hsearch = true;

  // var User;
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
  // _launchURLBrowser() async {
  //   const url = 'https://tawhan.zyx/';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Provider.of<ESC>(context, listen: false).getPrintter();
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
                  tileColor: Colors.white,
                  leading: Icon(
                    Icons.storefront_sharp,
                    color: Colors.orange,
                  ),
                  title: Text(
                    '?????????',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        Receipt.RouteName, (route) => false);
                  },
                  leading: Icon(Icons.list_alt_rounded),
                  title: Text('?????????????????????'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        RemoveProduct.RouteName, (route) => false);
                  },
                  leading: Icon(Icons.remove_shopping_cart),
                  title: Text(
                    '?????????????????????????????????',
                  ),
                ),
                ListTile(
                  onTap: () {
                    //  Navigator.of(context).pushNamedAndRemoveUntil(Customer.RouteName, (route) => false);
                    Navigator.of(context).pushNamed(Customer.RouteName);
                  },
                  leading: Icon(Icons.person),
                  title: Text('??????????????????'),
                ),
                ListTile(
                  onTap: () {
                    //  Navigator.of(context).pushNamedAndRemoveUntil(Customer.RouteName, (route) => false);
                    Navigator.of(context).pushNamed(ProductScreen.RouteName);
                  },
                  leading: Icon(Icons.card_travel),
                  title: Text('????????????????????????????????????'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        Setting.RouteName, (route) => false);
                  },
                  leading: Icon(Icons.settings),
                  title: Text('?????????????????????'),
                ),
                // ListTile(
                //   onTap:  ,
                //   leading: Icon(Icons.settings),
                //   title: Text('????????????????????????????????????'),
                // ),
                ListTile(
                    leading: Icon(Icons.logout),
                    onTap: () async {
                      var stt = await Network().logOut();
                      print('stt $stt');
                      if (stt == true) {
                      // var logout = await Network().getData2('/logout');
                      // var body = json.decode(logout.body);
                      // print(body['success']);
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            Login.RouteName, (route) => false);
                      }
                    },
                    title: Text('??????????????????????????????')),
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
                    child: Column(
                      children: [
                        Text('Terms of Service | Tawhan Studio V1'),
                      ],
                    ),
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
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                  primary: Theme.of(context).colorScheme.onPrimary),
              onPressed: () {
                // showAlertDialog(context);
                Navigator.of(context).pushNamed(DashboardScreen.RouteName);
              },
              child: Row(
                children: [
                  Icon(Icons.dashboard_customize_outlined),
                  Container(
                    margin: EdgeInsets.all(5),
                  ),
                  Text(
                    '??????????????????',
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                  primary: Theme.of(context).colorScheme.onPrimary),
              onPressed: () {},
              child: const Text(
                '',
                style: TextStyle(fontSize: 25),
              ),
            ),
          ],
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
              // left
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    // Hsearch == false ?Container(child: Text('Search'),):Container(),

                    Container(
                      height: 80,
                      // color: Colors.black12,
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Container(
                              height: 90,
                              padding: EdgeInsets.only(right: 20, left: 20),
                              child: Hsearch
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          //print(Hsearch);
                                          isActive = -1;
                                          Hsearch = false;
                                        });
                                      },
                                      child: Container(
                                        width: Hsearch ? 80 : 400,
                                        height: 80,
                                        margin: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: (isActive == -1)
                                              ? Color(0xffFF8F33)
                                              : Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
                                          boxShadow: [
                                            BoxShadow(
                                                color:
                                                    Colors.black.withAlpha(100),
                                                blurRadius: 5.0),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(7.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                Icons.search,
                                                size: 46,
                                              )

                                              // Text(
                                              //   '???????????????',
                                              //   style: TextStyle(
                                              //       fontSize: 20,
                                              //       color: (isActive == -1)
                                              //           ? Colors.white
                                              //           : Colors.black,
                                              //       fontWeight: FontWeight.bold),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : Row(
                                      children: [
                                        Container(
                                          width: 500,
                                          height: 80,
                                          margin: EdgeInsets.only(top: 7),
                                          child: TextFormField(
                                            controller: _search,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20),
                                                    bottomLeft:
                                                        Radius.circular(20)),
                                                borderSide: BorderSide(
                                                    color: Colors.white),
                                              ),
                                              //  suffix: Icon(Icons.search),
                                              prefixIcon: Icon(Icons.search),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 65,
                                          child: ElevatedButton(
                                              style: ButtonStyle(
                                                  shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.only(
                                                              topRight: Radius
                                                                  .circular(20),
                                                              bottomRight:
                                                                  Radius.circular(
                                                                      20)),
                                                          side: BorderSide(
                                                              color: Colors
                                                                  .red)))),
                                              onPressed: () {
                                                setState(() {
                                                  //print(_search.text);
                                                  search = _search.text;
                                                  Issearch = true;
                                                });
                                              },
                                              child: Text(
                                                '???????????????',
                                                style: TextStyle(fontSize: 16),
                                              )),
                                        )
                                      ],
                                    ),
                            ),
                            FutureBuilder(
                              future: getCatagory(),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (snapshot.data != null) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) {
                                      if (index == 0) {
                                        return Container(
                                          child: new GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isActive = 0;
                                                sale = '0';
                                                catagory = 'all';
                                                Hsearch = true;
                                                //print(Hsearch);
                                              });
                                            },
                                            child: Container(
                                              width: 150,
                                              height: 60,
                                              margin: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: (isActive == 0)
                                                    ? Color(0xffFF8F33)
                                                    : Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20.0)),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black
                                                          .withAlpha(100),
                                                      blurRadius: 5.0),
                                                ],
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
                                                      child: Center(
                                                        child: Text(
                                                          '?????????????????????',
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color: (isActive ==
                                                                      0)
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return  GestureDetector(
                                          onTap: () {
                                            var name = snapshot.data[index].id;
                                            //print(index.toString() + '$name');
                                            setState(() {
                                              isActive = index;
                                              sale = '0';
                                              Issearch = false;
                                              catagory =
                                                  '${snapshot.data[index].id}';
                                              Hsearch = true;
                                              //print(Hsearch);
                                            });
                                          },
                                          child: Container(
                                            width: 150,
                                            height: 60,
                                            margin: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: (isActive == index)
                                                  ? Color(0xffFF8F33)
                                                  : Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0)),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black
                                                        .withAlpha(100),
                                                    blurRadius: 5.0),
                                              ],
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Center(
                                                      child: Text(
                                                        snapshot
                                                                    .data[index]
                                                                    .name
                                                                    .length >
                                                                15
                                                            ? snapshot
                                                                    .data[index]
                                                                    .name
                                                                    .substring(
                                                                        0, 10) +
                                                                '..'
                                                            : snapshot
                                                                .data[index]
                                                                .name,
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color: (isActive ==
                                                                    index)
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  );
                                } else {
                                  return Container(
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: FutureBuilder(
                            future: getProducts(sale, catagory),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.data != null) {
                                return Container(
                                  padding: const EdgeInsets.all(10.0),
                                  child: GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                      ),
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (BuildContext ctx, index) {
                                        return Container(
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Container(
                                              // height: 210,
                                              // width: 210,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 5),

                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  // color: Colors.white,
                                                  primary:
                                                      snapshot.data[index].qty >
                                                              0
                                                          ? Colors.white
                                                          : Colors.grey[350],

                                                  onPrimary:
                                                      Colors.orangeAccent,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16), // <-- Radius
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  // var provider = Provider.of<
                                                  //         OrderProvider>(
                                                  //     context,
                                                  //     listen: false);
                                                  // if (provider.e429()) {
                                                  //   showAlertDialog(context);
                                                  // }
                                                  print(
                                                      'qty product ${snapshot.data[index].qty}');
                                                  if (snapshot.data[index].qty >
                                                      0) {
                                                    var SSt = await Provider.of<
                                                                CartProvider>(
                                                            context,
                                                            listen: false)
                                                        .addCart(
                                                            snapshot.data[index]
                                                                .sku,
                                                            1);
                                                    // setState(() {
                                                      // print('sst $SSt');
                                                      if (SSt == false) {
                                                        showAlertDialog2(
                                                            context);
                                                      }
                                                      // snapshot.data[index].qty -= 1;
                                                    // });

                                                    // snapshot.data[index].qty -
                                                    //     1;
                                                  } else {
                                                    showAlertDialog2(context);
                                                  }
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                                  child: Stack(
                                                    children: <Widget>[
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Expanded(
                                                            child: Center(
                                                              child:
                                                                  Image.network(
                                                                "${URL + snapshot.data[index].image}",
                                                                fit: BoxFit
                                                                    .cover,
                                                                loadingBuilder:
                                                                    (context,
                                                                        child,
                                                                        loadingProgress) {
                                                                  if (loadingProgress ==
                                                                      null)
                                                                    return child;
                                                                  return Center(
                                                                      child:
                                                                          CircularProgressIndicator());
                                                                },
                                                                errorBuilder: (context,
                                                                        exception,
                                                                        stackTrack) =>
                                                                    Icon(
                                                                  Icons.error,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(height: 5),
                                                          Center(
                                                            child: snapshot
                                                                        .data[
                                                                            index]
                                                                        .qty >
                                                                    0
                                                                ? Text(
                                                                    snapshot.data[index].name.length >
                                                                            30
                                                                        ? snapshot.data[index].name.substring(0,
                                                                                30) +
                                                                            '..'
                                                                        : snapshot
                                                                            .data[index]
                                                                            .name,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .black87),
                                                                  )
                                                                : Text(
                                                                    snapshot.data[index].name.length >
                                                                            30
                                                                        ? '(?????????)' +
                                                                            snapshot.data[index].name.substring(0,
                                                                                30) +
                                                                            '..'
                                                                        : '(?????????)' +
                                                                            snapshot.data[index].name,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .black87),
                                                                  ),
                                                          ),
                                                          Container(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center, //Center Row contents horizontally,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center, //Center Row contents vertically,
                                                              children: [
                                                                snapshot.data[index]
                                                                            .qty >
                                                                        0
                                                                    ? Text(
                                                                        "??? ${double.parse(snapshot.data[index].retail_price.toString())}/",
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.bold),
                                                                      )
                                                                    : Text(
                                                                        "( ????????? )??? ${double.parse(snapshot.data[index].retail_price.toString())}/",
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
                                                                Text(
                                                                  "${double.parse(snapshot.data[index].wholesale_price.toString())}",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      color: Colors
                                                                          .black54,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                // color: Colors.amber,
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                          ),
                                        );
                                      }),
                                );
                              } else {
                                return Container(
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                            }),
                      ),
                    ),

                    // product show
                  ],
                ),
              ),
              //right
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withAlpha(100), blurRadius: 5.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        // height: 80,
                        child: Row(
                          children: [
                            Container(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(
                                  '???????????????????????????',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                      color: Colors.black54),
                                )),
                            Spacer(),
                            //Customer
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Consumer(builder: (context,
                                  CustomerProvider customers, Widget) {
                                return Column(
                                  children: [
                                    customers.selectCustomer().length > 0
                                        ? IconButton(
                                            color: Color(0xffFE7300),
                                            onPressed: () {
                                              customers.emtySelect();
                                            },
                                            icon: Icon(
                                              Icons.person_remove,
                                              size: 40,
                                            ))
                                        : IconButton(
                                            color: Color(0xffFE7300),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserScreen(),
                                                ),
                                              );
                                            },
                                            icon: Icon(
                                              Icons.person_add_alt,
                                              size: 40,
                                            ))
                                  ],
                                );
                              }),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  IconButton(
                                      color: Color(0xffFE7300),
                                      onPressed: () {
                                        Provider.of<CartProvider>(context,
                                                listen: false)
                                            .emptyCart();
                                        Provider.of<CartProvider>(context,
                                                listen: false)
                                            .innitProduct();
                                        Provider.of<ProductProvider>(context,
                                                listen: false)
                                            .initData('0', 'all');
                                      },
                                      icon: Icon(
                                        Icons.delete_forever_sharp,
                                        size: 40,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Consumer(builder:
                          (context, CustomerProvider customers, Widget) {
                        return Container(
                          child: customers.selectCustomer().length > 0
                              ? Card(
                                  child: Text(
                                    '?????????????????? ${customers.selectCustomer()[0].name} ${customers.selectCustomer()[0].phone}',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange[800]),
                                  ),
                                )
                              : Container(),
                        );
                      }),
                      Expanded(
                        child: Container(
                          child: Consumer(
                            builder: (BuildContext context, CartProvider order,
                                Widget) {
                              var count = order.getCart().length;
                              if (count > 0) {
                                return new ListView.builder(
                                    // padding: const EdgeInsets.all(8),
                                    itemCount: count,
                                    // itemCount: 2,
                                    itemBuilder: (context, index) {
                                      CartModel data = order.getCart()[index];

                                      return Container(
                                        padding: EdgeInsets.all(2),
                                        child: ListTile(
                                          onTap: () {},
                                          title: Container(
                                            child: Column(
                                              children: [
                                                Container(
                                                  // alignment: Alignment.topRight,
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            right: 10),
                                                        child: Image.network(
                                                          "${URL + data.image}",
                                                          width: 70,
                                                          fit: BoxFit.cover,
                                                          loadingBuilder: (context,
                                                              child,
                                                              loadingProgress) {
                                                            if (loadingProgress ==
                                                                null)
                                                              return child;
                                                            return Center(
                                                                child:
                                                                    CircularProgressIndicator());
                                                          },
                                                          errorBuilder: (context,
                                                                  exception,
                                                                  stackTrack) =>
                                                              Icon(
                                                            Icons.error,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start, //Center Row contents horizontally,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .zero,
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 1),
                                                              alignment:
                                                                  Alignment
                                                                      .topRight,
                                                              child: Text(
                                                                data.name.length >
                                                                        18
                                                                    ? data.name.substring(
                                                                            0,
                                                                            18) +
                                                                        '...'
                                                                    : data.name,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black54),
                                                              ),
                                                            ),
                                                            Container(
                                                              alignment:
                                                                  Alignment
                                                                      .topRight,
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    '???${data.price}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .black54),
                                                                  ),
                                                                  Text(
                                                                    ' X${data.quantity}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .green),
                                                                  ),
                                                                  // Spacer(),
                                                                  data.sum <
                                                                          10000
                                                                      ? Container(
                                                                          alignment:
                                                                              Alignment.topLeft,
                                                                          padding:
                                                                              EdgeInsets.only(left: 20),
                                                                          child:
                                                                              Text(
                                                                            ' ???${data.sum}',
                                                                            style: TextStyle(
                                                                                fontSize: 19,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                        )
                                                                      : Container(),
                                                                ],
                                                              ),
                                                            ),
                                                            data.sum >= 10000
                                                                ? Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    // padding: EdgeInsets
                                                                    //     .only(
                                                                    //         left:
                                                                    //             20),
                                                                    child: Text(
                                                                      ' ???${data.sum}',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              19,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  )
                                                                : Container(),
                                                          ],
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Container(
                                                        color:
                                                            Colors.orange[300],
                                                        child: IconButton(
                                                          onPressed: () {
                                                            showDeitDialog(
                                                                data.id,
                                                                data.quantity);
                                                          },
                                                          icon: Icon(
                                                            Icons.edit,
                                                            size: 30,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        color: Colors.red[300],
                                                        child: IconButton(
                                                          onPressed: () {
                                                            var provider = Provider
                                                                .of<CartProvider>(
                                                                    context,
                                                                    listen:
                                                                        false);
                                                            provider
                                                                .del(data.id);
                                                          },
                                                          icon: Icon(
                                                            Icons
                                                                .delete_forever_sharp,
                                                            size: 30,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              } else {
                                return Center(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(40),
                                        child: Image.asset(
                                            'assets/images/5942.png'),
                                      ),
                                      Text(
                                        '????????????????????????',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 35,
                                            color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            // future: getCart(),
                          ),
                        ),
                      ),
                      Consumer(
                        builder:
                            (BuildContext context, CartProvider order, Widget) {
                          return Container(
                            height: 60,
                            padding: EdgeInsets.only(right: 20, top: 10),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2.0)),
                              color: Colors.white,
                              // boxShadow: [
                              //   BoxShadow(
                              //       color: Colors.black.withAlpha(100),
                              //       blurRadius: 3.0),
                              // ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      '?????????     ???${order.getSum().toString()} ',
                                      style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green),
                                    ),
                                    // Text(),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        height: 80,
                        width: double.infinity,
                        margin:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        child: ElevatedButton(
                          onPressed: () {
                            if (Provider.of<CartProvider>(context,
                                        listen: false)
                                    .getSum() >
                                0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Cash_screen()),
                              );
                            }
                          },
                          //  icon: Icon(Icons.attach_money_rounded),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.attach_money,
                                size: 35,
                              ),
                              Text(
                                '????????????????????????',
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
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
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}

showAlertDialog(BuildContext context) {
  // Create button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("???????????????????????????"),
    content: Text("?????????????????????????????????????????????! \n ????????????????????????????????????..."),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAlertDialog2(BuildContext context) {
  // Create button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("???????????????????????????"),
    content: Text(
      "???????????????????????????",
      style: TextStyle(fontSize: 40),
    ),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
