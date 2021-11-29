import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pos/models/cart_model.dart';
import 'package:pos/models/product_model.dart';
import 'package:pos/network_api/api.dart';

class CartProvider with ChangeNotifier {
  List<CartModel> cartList = [];
  List<ProductModel> productModel = [];
  Map<String, CartModel> data = {};

  List<CartModel> getCart() {
    return cartList;
  }

  getSum() {
    double sum = 0;
    data.forEach((key, value) => sum += value.sum);
    return sum;
  }

  emptyCart() {
    data.clear();
    cartList.clear();
    notifyListeners();
  }

  changQty(id, qty) {
    addCart(id, int.parse(qty));
  }

  del(id){
    print(id);
    cartList.removeWhere((item) => item.id == id);
    print(cartList.length);
    data.remove(id);
    // cartList.clear();
    // data.clear();
    // data.forEach((key, value) => cartList.add(value));
    notifyListeners();
    //cart/delete
  }

  innitProduct() async {
    print('innitProduct');
    var res = await Network().getData({'sale': '0'}, '/product');
    var body = json.decode(res.body);
    body.forEach((e) {
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
    });
    print(productModel.length);
  }

  addCart(sku, qty) async {
    // print('addCart sku $sku ');
    productModel.forEach((product) {
      if (product.sku == sku) {
        var id = product.sku;
        var name = product.name;
        var image = product.image;
        var price = 0.0;
        var quantity = 1;
        var product_id = product.id;
        var sum = 0.0;
        // print(product.retail_price);
        // print(data['$sku']);
        if (data['$sku'] == null) {
          sum = double.parse(product.retail_price.toString());
          // print(sum);
          price = double.parse(product.retail_price.toString());
          CartModel cart = CartModel(
            id,
            name,
            image,
            price,
            quantity,
            product_id,
            sum,
            'ขายปลีก',
          );
          data['$sku'] = cart;
          print(data['$sku']!.name);
          print(data['$sku']!.price);
          print(data['$sku']!.quantity);
          print(data['$sku']!.sum);
        } else {
          if (qty == 1) {
            data['$sku']!.quantity += 1;
          } else {
            data['$sku']!.quantity = qty;
          }

          // อย่าลืมทำการตั้งค่าตัวนี้ด้วยเด้อตัวที่กำหนดว่าจะขายปลีกขายส่ง

          if (data['$sku']!.quantity >= 10) {
            data['$sku']!.price =
                double.parse(product.wholesale_price.toString());
            data['$sku']!.status_sale = 'ขายส่ง';
          } else {
            price = double.parse(product.retail_price.toString()); // ขายปลีก

          }
          data['$sku']!.sum = data['$sku']!.price * data['$sku']!.quantity;

          //  var cc =  data['$sku']!.name;
          print(data['$sku']!.name);
          print(data['$sku']!.price);
          print(data['$sku']!.quantity);
          print(data['$sku']!.sum);
          //  var cc2 = data['$sku']!.name = "Unknown";
          //  print(cc2);

          // sum += price;
          // quantity += 1;
          // // print(sum);
          // CartModel cart = CartModel(
          //    data['$sku']!.id,
          //   data['$sku']!.name,
          //   data['$sku']!.image,
          //   price,
          //   quantity,
          //   data['$sku']!.product_id,
          //   sum,
          // );
          // data['$sku'] = cart;
        }
        // cartList.add(product);

      }
    });
    print(data.length);
    cartList.clear();
    data.forEach((key, value) => cartList.add(value));
    print('cartList.length');
    print(cartList.length);
    print(cartList);
    notifyListeners();
  }
}
