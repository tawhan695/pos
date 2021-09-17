import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:pos/models/product_model.dart';
import 'package:pos/network_api/api.dart';
import 'package:pos/screen/sale_widget/catagory.dart';
import 'package:shared_preferences/shared_preferences.dart';

var data = {
  'username': 'admin@gmail.com',
  'password': '123456789',
  'device_name': 'mobile'
};
const FOOD_DATA = [
  {"name": "Burger", "brand": "Hawkers", "price": 2.99, "image": "burger.png"},
  {
    "name": "Cheese Dip",
    "brand": "Hawkers",
    "price": 4.99,
    "image": "cheese_dip.png"
  },
  {"name": "Cola", "brand": "Mcdonald", "price": 1.49, "image": "cola.png"},
  {"name": "Fries", "brand": "Mcdonald", "price": 2.99, "image": "fries.png"},
  {
    "name": "Ice Cream",
    "brand": "Ben & Jerry's",
    "price": 9.49,
    "image": "ice_cream.png"
  },
  {
    "name": "Noodles",
    "brand": "Hawkers",
    "price": 4.49,
    "image": "noodles.png"
  },
  {"name": "Pizza", "brand": "Dominos", "price": 17.99, "image": "pizza.png"},
  {
    "name": "Sandwich",
    "brand": "Hawkers",
    "price": 2.99,
    "image": "sandwich.png"
  },
  {
    "name": "Sandwich",
    "brand": "Hawkers",
    "price": 2.99,
    "image": "sandwich.png"
  },
  {
    "name": "Sandwich",
    "brand": "Hawkers",
    "price": 2.99,
    "image": "sandwich.png"
  },
  {
    "name": "Sandwich",
    "brand": "Hawkers",
    "price": 2.99,
    "image": "sandwich.png"
  },
  {"name": "Wrap", "brand": "Subway", "price": 6.99, "image": "wrap.png"}
];

class SaleRetail extends StatefulWidget {
  static const RouteName = '/sale-retail';

  @override
  _SaleRetailState createState() => _SaleRetailState();
}

class _SaleRetailState extends State<SaleRetail> {
  final CategoriesScroller categoriesScroller = CategoriesScroller();
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;

  List<Widget> itemsData = [];

  void getPostsData() {
    List<dynamic> responseList = FOOD_DATA;
    List<Widget> listItems = [];
    responseList.forEach((post) {
      listItems.add(
        Container(
          // height: 210,
          // width: 210,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Stack(
              // fit: StackFit.passthrough,
              // overflow: Overflow.visible,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Image.asset("assets/images/${post["image"]}",
                          height: 80
                          // double.infinity,
                          ),
                    ),
                    Text(
                      post["name"],
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "฿ ${post["price"]}",
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });

    setState(() {
      itemsData = listItems;
    });
  }

  @override
  void initState() {
    super.initState();
    getPostsData();
    controller.addListener(() {
      double value = controller.offset / 10;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height * 0.30;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          // leading: Icon(
          //   Icons.menu,
          //   color: Colors.black,
          // ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.person, color: Colors.black),
              onPressed: () {},
            )
          ],
        ),
        drawer: SizedBox(
          width: MediaQuery.of(context).size.width * 0.25,
          // width:50,
          child: Drawer(
            child: Column(
              children: <Widget>[
                // SizedBox(
                //   height: 80,
                // ),
                DrawerHeader(
                  child: UserAccountsDrawerHeader(
                    accountName: Text("Ashish Rawat"),
                    accountEmail: Text("ashishrawat2911@gmail.com"),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00897b),
                    ),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).platform == TargetPlatform.android
                              ? const Color(0xFF00897b)
                              : Colors.white,
                      child: Text(
                        "A",
                        style: TextStyle(fontSize: 40.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          height: size.height,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          child: Text(
                            "ขายปลีก",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(child: categoriesScroller),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 2, vertical: 1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
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
                              // maxCrossAxisExtent: 390,
                              // childAspectRatio: 1.5,
                              // // crossAxisSpacing: 5,
                              // mainAxisSpacing: 50
                              crossAxisCount: 5,
                            ),
                            itemCount: itemsData.length,
                            itemBuilder: (BuildContext ctx, index) {
                              return Container(
                                alignment: Alignment.center,
                                child: itemsData[index],
                                decoration: BoxDecoration(
                                    // color: Colors.amber,
                                    borderRadius: BorderRadius.circular(15)),
                              );
                            }),
                      ),
                   
                    )
                  ],
                ),
              ),
              // order
              Container(
                width: 300,
                // color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withAlpha(100), blurRadius: 2.0),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text('ออเดอร์', style: TextStyle(fontSize: 25)),
                        Text('ออเดอร์', style: TextStyle(fontSize: 25)),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//   late Future<ProductModel> futureProduct;

// final ScrollController _scrollController = ScrollController();

// get child => null;
// Future<void> readProduct() async {
//   var res = await Network().authData({
//     'username' : 'admin@gmail.com',
//     'password' : '123456789',
//     'device_name': 'mobile'
//   }, '/login');
//   print(res);
//   var body = json.decode(res.body);
//   print(body);

//   // Map<String, dynamic> decoded = json.decode(productsJson);
//   // Product = decoded['last'];
// }

// getProducrt() async {
//   var res = await Network().authData(data, '/product');
//   var body = json.decode(res.body);
// }

//   Future <ProductModel> fetchProduct() async {
//   // final response = await http
//   //     .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
//   var res = await Network().getData({'sale':'0','catagory':'2'},'/product');
//   var body = json.decode(res.body);
//   print(res.statusCode);
//   if (res.statusCode == 200) {
//     print(body);
//     // return ProductModel.fromJson(body);
//   } else {

//     // throw Exception('Failed to load album');
//   }
// }

//   @override
//   void initState() {
//     super.initState();
//     print('sale page');
//   }

//   @override
//   Widget build(BuildContext context) {
//     var screen_saleWidth = MediaQuery.of(context).size.width * 0.3;
//     // var productModel2 = productModel;
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: true,
//         title: Text('ขาย ปลีก',
//             style: TextStyle(
//                 // fontSize: 40,
//                 // color: Colors.white
//                 )),
//         centerTitle: true,
//         // toolbarHeight: 110,
//         // leading: Builder(
//         //   builder: (context) => // Ensure Scaffold is in context
//         //       IconButton(
//         //           icon: Icon(Icons.menu, size: 50),
//         //           onPressed: () => Scaffold.of(context).openDrawer()),
//         // ),

//         actions: <Widget>[
//           Padding(
//               padding: EdgeInsets.only(right: 20.0),
//               child: GestureDetector(
//                 onTap: () {},
//                 child: Icon(
//                   Icons.more_vert,
//                   size: 50.0,
//                 ),
//               )),
//           // Icon(Icons.more_vert, size: 50),
//         ],
//         // leading: Icon(Icons.android),
//       ),
//       drawer: SizedBox(
//         width: MediaQuery.of(context).size.width * 0.25,
//         // width:50,
//         child: Drawer(
//           child: Column(
//             children: <Widget>[
//               // SizedBox(
//               //   height: 80,
//               // ),
//               DrawerHeader(
//                 child: UserAccountsDrawerHeader(
//                   accountName: Text("Ashish Rawat"),
//                   accountEmail: Text("ashishrawat2911@gmail.com"),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF00897b),
//                   ),
//                   currentAccountPicture: CircleAvatar(
//                     backgroundColor:
//                         Theme.of(context).platform == TargetPlatform.android
//                             ? const Color(0xFF00897b)
//                             : Colors.white,
//                     child: Text(
//                       "A",
//                       style: TextStyle(fontSize: 40.0),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: Container(
//         child: Row(
//           children: <Widget>[
//             Container(
//               child: Row(
//                 children:<Widget> [
//                   Container(
//                     child: ListView.builder(
//                       padding: EdgeInsets.only(top: 10),
//                       scrollDirection: Axis.horizontal,
//                       itemCount: 5,
//                       itemBuilder: (BuildContext ctxt, int index) {
//                         return new Text('litems[index]');
//                       },
//                     ),
//                   ),
//                   Container(),
//                 ],
//               ),
//             ),
//             Container(),
// child: Container(
//   color: Color(0xffE8EAF1),
//   margin: EdgeInsets.only(
//     right: 0,
//     left: 10,
//     bottom: 10,
//     top: 10,
//   ),
//   child: Row(children: <Widget>[
//     Container(
//       alignment: Alignment.topCenter,
//       color: Color(0xffE8EAF1),
//       width: 100,
//       child: new ListView.builder(
//         // padding: EdgeInsets.only(top: 10),
//         scrollDirection: Axis.horizontal,
//         itemCount: 50,
//         itemBuilder: (BuildContext ctxt, int index) {
//           return new Text('litems[index]');
//         },
//       ),
//     ),
//     Container(
//       color: Colors.black,
//       child: new ListView.builder(
//         // padding: EdgeInsets.only(top: 10),
//         scrollDirection: Axis.horizontal,
//         itemCount: 50,
//         itemBuilder: (BuildContext ctxt, int index) {
//           return new Text('litems[index]');
//         },
//       ),

//     )
//     // Text('data'),
//     // Text('data'),
//   ]),
// ),
// ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ProductsList extends StatelessWidget {
//   const ProductsList({Key? key, required this.product}) : super(key: key);

//   final List<ProductModel> product;

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//        scrollDirection: Axis.vertical,
//       // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//       //   crossAxisCount: 2,
//       // ),
//       itemCount: product.length,
//       itemBuilder: (context, index) {
//         return Image.network('https://picsum.photos/250?image=$index');
//       },
//     );
//   }
// }

// class OrderList extends StatefulWidget {
//   OrderList({Key? key}) : super(key: key);

//   @override
//   _OrderListState createState() => _OrderListState();
// }

// class _OrderListState extends State<OrderList> {
//   @override
//   Widget build(BuildContext context) {
//     return  Container(
//             margin: EdgeInsets.all(10),
//             // alignment: Alignment.centerRight,
//             padding: EdgeInsets.only(right: screen_saleWidth),
//             color: Colors.green,
//           );
//   }
// }
