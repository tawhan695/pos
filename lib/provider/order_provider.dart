import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pos/models/cart_model.dart';
import 'package:pos/network_api/api.dart';
import 'package:pos/provider/product_provider.dart';
import 'package:provider/provider.dart';

class OrderProvider with ChangeNotifier {
  List<CartModel> cartList = [];
  var Typesale = 'wholesale_price';
  bool httpE429 = false ;
  double sum =0.0;
  int Value_price = 10;

  List<CartModel> getCart() {
    return cartList;
  }

  getSum()=> sum;
   e429()  {
     return httpE429;
  }
  addCart(sku) async {
    sleep(const Duration(milliseconds: 100)); // ดีเลเพื่อไม่ให้ส่งรีเคสเร็วเกินไป
    await Network().getData({'sku': '$sku'}, '/cart');
    await initCart();
    // print('Init Cart ... ok');
  }

  // Cart
  initCart() async {
    // cartList = []
    
    List<CartModel> cart = [];
  
  
    final response = await Network().getData3('/cart');
    var body = json.decode(response.body);
    // if (response.statusCode != 200) return null;
    // print(body);
    if (response.statusCode == 200) {
      httpE429 = false;
      double Sum = 0.0;
      await body.forEach((e) async {
          var price;
    var quantity;
    var product_id;
        product_id = e['pivot']['product_id'];
        quantity = e['pivot']['quantity'];


        if (quantity >= Value_price) {
          price = e['wholesale_price'];
        } else  {
          price = e['retail_price'];
        }
        CartModel val = CartModel(
            e['id'], e['name'], e['image'], price, quantity, product_id,((price).toDouble() * quantity));
        cart.add(val);
         Sum +=  ((  price).toDouble() *  quantity);
      });
      sum = Sum;
      cartList = cart;
      print('Init Cart ... ok');
    }else{
      print(response.statusCode);
      // if(response.statuscode == 429){
      httpE429 = true;
        
      // }
    }
      notifyListeners();

  }

  emptyCart() async {
    // notifyListeners();
    await Network().getDataEmpty('/cart/empty');
    initCart();
  }

  del(id) async {
    await Network().getDataDelete({'product_id':'$id'},'/cart/delete');
    initCart();
 //cart/delete  
  }
  changQty(id,qty) async {
    await Network().getData({'product_id':'$id','quantity':'$qty'},'/cart/change-qty');
    initCart();
    // ProductProvider().initData();
 //cart/delete  
  }


  
}
