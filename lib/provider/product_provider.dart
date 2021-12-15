import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pos/models/product_model.dart';
import 'package:pos/network_api/api.dart';

class ProductProvider with ChangeNotifier {
  // ตัวอย่างข้อมูล
  List<ProductModel> productModel = [];

  // ดึงข้อมูล
  List<ProductModel> getProduct() {
    return productModel;
  }

  void initData(sale_id, catagory_id) async {
    var res;
    if (catagory_id == 'all') {
      res = await Network().getData({'sale': '$sale_id'}, '/product');
    } else {
      res = await Network().getData(
          {'sale': '$sale_id', 'catagory': '$catagory_id'}, '/product');
    }
    if(res.statusCode == 200){
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
    }
     
  }

   getName(id) {
    var name;
    var img;
    productModel.forEach((product) {
      if (product.id == id) {
        name = product.name;
        img = product.image;
      }
    });
    return {'name':name,'img':img};
  }

  void addTransaction(ProductModel statement) async {
    // var db=TransactionDB(dbName: "ProductModel.db");
    // //บันทึกข้อมูล
    // await db.InsertData(statement);
    // //ดึงข้อมูลมาแสดงผล
    // ProductModel=await db.loadAllData();
    //แจ้งเตือน Consumer
    notifyListeners();
  }

 
}
