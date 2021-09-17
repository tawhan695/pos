import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:pos/models/cart_model.dart';
import 'package:pos/models/catagory_model.dart';
import 'package:pos/models/product_model.dart';
import 'package:pos/network_api/api.dart';
import 'package:pos/provider/product_provider.dart';
import 'package:pos/screen/sale_widget/cart.dart';
import 'package:provider/provider.dart';

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
  String URL = 'https://mtn.tawhan-studio.com/';
  // List<CatagoryModel> catagory =[];
  // @override
  // catagory  is a list

  Future<List<CatagoryModel>> getCatagory() async {
    final response = await Network().getData2('/catagory');
    var body = json.decode(response.body);
    List<CatagoryModel> _listCatagory = [];
    CatagoryModel catagory = CatagoryModel(-1, 'all');
    _listCatagory.add(catagory);
    body.forEach((e) {
      CatagoryModel catagory = CatagoryModel(e['id'], e['name']);
      _listCatagory.add(catagory);
    });
    print(_listCatagory.length);
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

    var body = json.decode(res.body);
    List<ProductModel> productModel = [];
    body.forEach(
      (e) {
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
      },
    );
    return productModel;
  }

  Future<void> addCart(sku) async {
    var res = await Network().getData({'sku': '$sku'}, '/cart');
    // var body = json.decode(res.body);
    print('add');
  }

  // Cart
  Future<List<CartModel>> getCart() async {
    double sum = 0.0;
    var price;
    var quantity;
    var product_id;
    List<CartModel> cartList = [];
    final response = await Network().getData3('/cart');
    var body = json.decode(response.body);
    // print(body);
    body.forEach((e) {
      product_id = e['pivot']['product_id'];
      quantity = e['pivot']['quantity'];
      if (Typesale == 'retail_price') {
        price = e['retail_price'];
      } else if (Typesale == 'wholesale_price') {
        price = e['wholesale_price'];
      }
      CartModel val = CartModel(
          e['id'], e['name'], e['image'], price, quantity, product_id);
      cartList.add(val);
    });
    return cartList;
  }

  // Future<void> addCart() async {
  //   double sum = 0.0;
  //   List<CartModel> cart = [];
  //   final response = await Network().getData2('/cart');
  //   var body = json.decode(response.body);
  //   print(body);
  //   body.forEach((e) {
  //     print(e);
  //     print('pivot ' + e['pivot']);
  //   });
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Provider.of<ProductProvider>(context, listen: false).initData('1', 'all');
    // Cart().setTypeSale('retail_price');
    // Cart().getCart();
    // catagory =
    // _product();
    // print('fetchCatagory()');
    // print(getCatagory());
    // print(fetchCatagory());
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
                    bottom: 64.0,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    // color: Colors.black26,
                    color: Color(0xffFE7300),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/avocado.png',
                  ),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.account_circle_rounded),
                  title: Text('Profile'),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.favorite),
                  title: Text('Favourites'),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
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
          title: const Text('Advanced Drawer Example'),
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
                    Container(
                      height: 80,
                      // color: Colors.black12,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
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
                                                    Text(
                                                      'ทั้งหมด',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: (isActive == 0)
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return new GestureDetector(
                                          onTap: () {
                                            var name = snapshot.data[index].id;
                                            print(index.toString() + '$name');
                                            setState(() {
                                              isActive = index;
                                              sale = '0';
                                              catagory =
                                                  '${snapshot.data[index].id}';
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
                                                  Text(
                                                    snapshot.data[index].name,
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color:
                                                            (isActive == index)
                                                                ? Colors.white
                                                                : Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
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
                                      child: Text('Loding...'),
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
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 2, vertical: 1),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    color: Colors.white,
                                    boxShadow: [
                                      // BoxShadow(
                                      //     // color: Colors.black.withAlpha(100),
                                      //     blurRadius: 1.0),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(10.0),
                                  child: GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                      ),
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (BuildContext ctx, index) {
                                        return InkWell(
                                          splashColor: Color(0xffFF8F33),
                                          highlightColor: Color(0xffFF8F33)
                                              .withOpacity(0.3),
                                          onTap: () {
                                            addCart(snapshot.data[index].sku);
                                            print(
                                                'id : ${snapshot.data[index].id} id : ${snapshot.data[index].sku} price: ${snapshot.data[index].retail_price}');
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Container(
                                              // height: 210,
                                              // width: 210,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 15),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20.0)),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black
                                                          .withAlpha(100),
                                                      blurRadius: 10.0),
                                                ],
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 10),
                                                child: Stack(
                                                  // fit: StackFit.passthrough,
                                                  // overflow: Overflow.visible,
                                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                              // height: 65
                                                              // double.infinity,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 5),
                                                        Center(
                                                          child: Text(
                                                            snapshot
                                                                        .data[
                                                                            index]
                                                                        .name
                                                                        .length >
                                                                    14
                                                                ? snapshot
                                                                        .data[
                                                                            index]
                                                                        .name
                                                                        .substring(
                                                                            0,
                                                                            14) +
                                                                    '...'
                                                                : snapshot
                                                                    .data[index]
                                                                    .name,
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        Center(
                                                          child: Text(
                                                            "฿ ${snapshot.data[index].retail_price}",
                                                            style: const TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
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
                                    child: Text('Loding...'),
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
                flex: 2,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 60,
                      child: Text('Title'),
                    ),
                    Expanded(
                      child: Container(
                        child: FutureBuilder(
                            future: getCart(),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.data != null) {
                                // return Text('text ${snapshot.data.length}');
                                return ListView.builder(
                                    // padding: const EdgeInsets.all(8),
                                    itemCount: snapshot.data.length,
                                    // itemCount: 2,
                                    itemBuilder: (context, index) {
                                      return Container(
                                            padding:EdgeInsets.all(3),
                                          child: Row(
                                        children: [
                                          //img
                                          Image.network(
                                            "${URL + snapshot.data[index].image}",
                                            width: 70,
                                          ),
                                          Container(
                                            padding:EdgeInsets.all(10),
                                            child: Column(
                                              
                                              children: [
                                                Text(
                                                  '${snapshot.data[index].name}',
                                                  style: TextStyle(fontSize: 20),
                                                ),
                                                Text(
                                                  '${snapshot.data[index].price} X ${snapshot.data[index].quantity}',
                                                  style: TextStyle(fontSize: 16),
                                                ),
                                                
                                              ],
                                            ),
                                          ),
                                          // Text(
                                          //   '$index',
                                          //   style: TextStyle(fontSize: 30),
                                          // ),
                                          // Text(
                                          //   '$index',
                                          //   style: TextStyle(fontSize: 30),
                                          // ),
                                          //text
                                        ],
                                      ));
                                    });
                              } else {
                                return Center(
                                  child: Text('Loading...'),
                                );
                              }
                            }),
                      ),
                    ),
                    // Spacer(
                    //   flex: 2,
                    // ),
                    Container(
                      height: 150,
                      child: Text('data'),
                    ),
                  ],
                ),
              )
              // Container(
              //   width: 300,
              //   // color: Colors.blue,
              //   margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.all(Radius.circular(5.0)),
              //     color: Colors.blue,
              //     boxShadow: [
              //       BoxShadow(
              //           color: Colors.black.withAlpha(100), blurRadius: 2.0),
              //     ],
              //   ),
              //   child: Expanded(
              //     child: Column(
              //       children: [
              //         Container(
              //           color: Colors.black,
              //           height: 60,
              //           child: Text('order'),
              //         ),
              //         Container(
              //           // width:500,
              //           color: Colors.black.withAlpha(100),
              //           child: Row(
              //             children: [
              //               Container(
              //                 child: SingleChildScrollView(
              //                   scrollDirection: Axis.vertical,
              //                   child: Column(
              //                     children: <Widget>[
              //                       Expanded(
              //                         child: Column(
              //                           children: [
              //                             Container(
              //                               child: FutureBuilder(
              //                                   future: getCart(),
              //                                   builder:
              //                                       (context, AsyncSnapshot snapshot) {
              //                                     if (snapshot.data != null) {
              //                                       // return Text('text ${snapshot.data.length}');
              //                                       return Container(
              //                                         child: ListView.builder(
              //                                             padding: const EdgeInsets.all(8),
              //                                             itemCount: snapshot.data.length,
              //                                             // itemCount: 2,

              //                                             itemBuilder: (context, index) {
              //                                               return Container(
              //                                                   child: Text('Entry'));
              //                                             },),
              //                                       );
              //                                     } else {
              //                                       return Center(
              //                                         child: Text('Loading...'),
              //                                       );
              //                                     }
              //                                   }),
              //                             ),
              //                           ],
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
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
