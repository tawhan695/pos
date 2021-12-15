import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pos/models/cart_model.dart';
import 'package:pos/models/product_model.dart';
import 'package:pos/network_api/api.dart';

class CartProvider with ChangeNotifier {
  List<CartModel> cartList = [];
  List<ProductModel> productList = [];
  Map<String, ProductModel> producs = {};
  Map<String, CartModel> data = {};

  List<CartModel> getCart() {
    // notifyListeners();
    return cartList;
  }

  getSum() {
    double sum = 0;
    data.forEach((key, value) => sum += value.sum);
    return sum;
  }

  emptyCart() {
    data = {};
    cartList.forEach((e) {
      print(' delete >>id product ' + e.id.toString());
      print('cart qty ' + e.quantity.toString());
      print('qty ' + producs['${e.id}']!.qty.toString());
      print('new qty ${producs['${e.id}']!.qty} + ${e.quantity} = ');
      producs['${e.id}']!.qty += e.quantity;
      print(' ' + producs['${e.id}']!.qty.toString());
    });
    cartList.clear();
    notifyListeners();
  }

  changQty(id, qty) {
    if (int.parse(qty) > int.parse(producs['$id']!.qty.toString())) {
      producs['$id']!.qty += data['$id']!.quantity;
      addCart(id, producs['$id']!.qty);
    } else {
      producs['$id']!.qty += data['$id']!.quantity;
      addCart(id, qty);
    }
  }

  del(id) {
    producs['$id']!.qty += data['$id']!.quantity;
    print(id);
    cartList.removeWhere((item) => item.id == id);
    print(cartList.length);
    data.remove(id);
    notifyListeners();
  }

  innitProduct() async {
    print('innitProduct');
    var res = await Network().getData({'sale': '0'}, '/product');
    var body = json.decode(res.body);
    if(res.statusCode == 200){
       for (var i = 0; i < body.length; i++) {
      ProductModel product = ProductModel(
          body[i]['id'],
          body[i]['name'],
          body[i]['sku'],
          body[i]['unit'],
          body[i]['retail_price'],
          body[i]['wholesale_price'],
          body[i]['sale_price'],
          body[i]['qty'],
          body[i]['image']);
      productList.add(product);

      producs["${body[i]['sku']}"] = product;
    }
    }
    // notifyListeners();
  }

  addCart(sku, qty) async {
    bool status = false;
    qty = int.parse(qty.toString());
    if (producs['$sku']!.qty != 0 && producs['$sku']!.qty >= qty) {
      if (data['$sku'] == null) {
        var id = producs['$sku']!.sku;
        var name = producs['$sku']!.name;
        var image = producs['$sku']!.image;
        var price = 0.0;
        var quantity = 0;
        producs['$sku']!.qty -= 1;
        var product_id = producs['$sku']!.id;
        var sum = 0.0;
        sum = double.parse(producs['$sku']!.retail_price.toString());
        // print(sum);
        price = double.parse(producs['$sku']!.retail_price.toString());
        CartModel cart = CartModel(
          id,
          name,
          image,
          price,
          1,
          product_id,
          sum,
          'ขายปลีก',
        );
        data['$sku'] = cart;
        // print(data['$sku']!.name);
        // print(data['$sku']!.price);
        // print(data['$sku']!.quantity);
        // print(data['$sku']!.sum);
      } else {
        var price = 0.0;
        if (qty == 1) {
          // print("#######3");
          // print("data['$sku']!.quantity = qty : ${data['$sku']!.quantity}");
          data['$sku']!.quantity += 1;
          producs['$sku']!.qty -= 1;
          print('addCart sku $sku  QTY : ${producs['$sku']!.qty}');
          // print("data['$sku']!.quantity = qty : ${data['$sku']!.quantity}");
        } else {
          data['$sku']!.quantity = qty;
          producs['$sku']!.qty -= qty;
          print('addCart sku $sku  QTY : ${producs['$sku']!.qty}');
          // print("data['$sku']!.quantity = qty : $qty ");
        }

        // อย่าลืมทำการตั้งค่าตัวนี้ด้วยเด้อตัวที่กำหนดว่าจะขายปลีกขายส่ง

        if (data['$sku']!.quantity >= 10) {
          data['$sku']!.price =
              double.parse(producs['$sku']!.wholesale_price.toString());
          data['$sku']!.status_sale = 'ขายส่ง';
        } else {
          price =
              double.parse(producs['$sku']!.retail_price.toString()); // ขายปลีก

        }
        data['$sku']!.sum = data['$sku']!.price * data['$sku']!.quantity;
        //   print(data['$sku']!.name);
        // print(data['$sku']!.price);
        // print(data['$sku']!.quantity);
        // print(data['$sku']!.sum);
      }
      print('status ยังเหลือ ${producs['$sku']!.qty} ');
    } else {
      print('status หมด ${producs['$sku']!.qty}');
    }

    // // print(data.length);
    cartList.clear();
    data.forEach((key, value) => cartList.add(value));
    // print('cartList.length');
    // print(cartList.length);
    // print(cartList);
    if (producs['$sku']!.qty <= 0 ){
        status=false;
    }else{
        status=true;
    }
     print('status  ${status}');
    notifyListeners();
    return status;
  }
}
