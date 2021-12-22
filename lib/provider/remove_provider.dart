import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pos/models/remove_model.dart';
import 'package:pos/network_api/api.dart';

class RemoveProvider with ChangeNotifier {
  List<RemoveModel> _data = [];
   List<RemoveModel> getRemove(){
    return _data;
  }
  void initRemove(page) async {
    List<RemoveModel> data = [];
    var response;
    if (page == 0) {
      response = await Network().getData3('/product/defective');
    } else {
      response = await Network().getData3('/product/defective?page=$page');
    }
    var body = json.decode(response.body)['defective']['data'];
    body.forEach((e){
      
      RemoveModel m = RemoveModel(
        e['product_id'],
        e['status'],
        e['qty'],
        e['created_at'],
      );
      data.add(m);
    });
    _data = data;

    // return data;
    notifyListeners();
  }
 
 
}
