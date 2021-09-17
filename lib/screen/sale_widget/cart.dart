// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:pos/models/cart_model.dart';
// import 'package:pos/network_api/api.dart';

// class Cart extends StatelessWidget {
//   // const Cart(this.sale);

//   // get sale => null;
//   var Typesale;
//   void setTypeSale(sale) {
//     Typesale = sale;
//   }

//   Future<List<CartModel>> getCart() async {
//     double sum = 0.0;
//     double price = 0.0;
//     var quantity;
//     var product_id;
//     List<CartModel> cartList = [];
//     final response = await Network().getData3('/cart');
//     var body = json.decode(response.body);
//     // print(body);
//     body.forEach((e) {
//       product_id = e['pivot']['product_id'];
//       quantity = e['pivot']['quantity'];
//       if (Typesale == 'retail_price') {
//         price = e['retail_price'];
//       } else if (Typesale == 'wholesale_price') {
//         price = e['wholesale_price'];
//       }
//       CartModel val = CartModel(
//           e['id'], e['name'], e['image'], price, quantity, product_id);
//       cartList.add(val);
//     });
//     return cartList;
//   }

//   Future<void> addCart() async {
//     double sum = 0.0;
//     List<Cart> cart = [];
//     final response = await Network().getData2('/cart');
//     var body = json.decode(response.body);
//     print(body);
//     body.forEach((e) {
//       print(e);
//       print('pivot ' + e['pivot']);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         color: Colors.red,
//         child: Column(
//           children: [
//             Container(
//               height: 60,
//               color: Colors.white,
//               margin: EdgeInsets.all(10),
//               child: Row(
//                 children: [
//                   Text('255555'),
//                   Text('255555'),
//                   Text('255555'),
//                 ],
//               ),
//             ),
//             Container(
//               color: Colors.white,
//               height: 500,
              
//             ),
//             // Spacer(flex: 2),
//             // Container(
//             //   width: 280,
//             //   // color: Colors.blue,
//             //   child: RaisedButton(
//             //     // style: style,

//             //     onPressed: () => {
//             //       //do something
//             //     },
//             //     padding: EdgeInsets.all(20),
//             //     // margin: EdgeInsets.all(10),
//             //     color: Color(0xffFF8F33),

//             //     shape: RoundedRectangleBorder(
//             //       borderRadius: BorderRadius.all(
//             //         Radius.circular(30),
//             //       ),
//             //     ),
//             //     child: new Text(
//             //       'ชำระเงิน',
//             //       style: TextStyle(fontSize: 20, color: Colors.white),
//             //     ),
//             //   ),
//             // ),
//             // SizedBox(
//             //   height: 20,
//             // ),
//           ],
//           // children: [
//           //   SizedBox(height: 10),
//           //   // Container(

//           //   //   color: Colors.blue,
//           //   //   child: ListView(children: [
//           //   //   ListTile(
//           //   //     title:Text('egg -2000'),
//           //   //   ),
//           //   //   ListTile(
//           //   //     title:Text('egg -2000'),
//           //   //   ),
//           //   //   ],),
//           //   // ),
//           //   Spacer(flex:2),
//           //   Container(

//           //     width: 280,
//           //     child: RaisedButton(
//           //       // style: style,

//           //       onPressed: () => {
//           //         //do something
//           //       },
//           //       padding: EdgeInsets.all(20),
//           //       // margin: EdgeInsets.all(10),
//           //       color: Color(0xffFF8F33),

//           //       shape: RoundedRectangleBorder(
//           //         borderRadius: BorderRadius.all(Radius.circular(30),),
//           //       ),
//           //       child: new Text('ชำระเงิน',
//           //         style:TextStyle(fontSize:20,color:Colors.white),
//           //       ),
//           //     ),
//           //   ),
//           //   SizedBox(height: 20,),
//           // ],
//         ));
//   }
// }
