import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
// import 'package:pos/models/Order_model.dart';
import 'package:pos/models/order_model.dart';
import 'package:pos/network_api/api.dart';

class ListOrderProvider with ChangeNotifier {
  List<ListOrder_model> order = [];
  List<ListOrder_model> _order2 = [];
  List<ListOrder_model> order_detail = [];
  List<ListOrder_model> _order_detail2 = [];
  List<ListOrder_model> custom_listOrder = [];
  int Tiket = 0;
  double Totol = 0.0;

  List<ListOrder_model> getListorder() {
    // _order2 = order;
    return _order2;
  }

  getSearch(id) {
    // print('ID : $id');
    if (id.toString().length > 0) {
      List<ListOrder_model> _order3 = [];
      order.forEach((e) {
        String ID = e.id.toString();
        // print(ID.indexOf(id.toString()));
        if (ID.indexOf("$id") == 0) {
          // print(e);
          _order3.add(e);
        }
      });
      _order2 = _order3;
    } else {
      _order2 = order;
    }
    notifyListeners();
  }

  clear_search() {
    _order2 = order;
    notifyListeners();
  }

  initListorder(page) async {
    List<ListOrder_model> _order = [];
    var res;
    if (page == 0) {
      res = await Network().getData3('/order');
    } else {
      res = await Network().getData3('/order?page=$page');
    }
    if (res != 'error') {
      var body = json.decode(res.body)['order']['data'];
      // var body2 = json.decode(res.body)['detail'];
      if (res.statusCode == 200) {
        body.forEach((e) {
          var str = e['created_at'];
          var newStr = str.substring(0, 10) + ' ' + str.substring(11, 19);
          // print(newStr); // 2019-04-05 14:00:51.000
          ListOrder_model model = ListOrder_model(
              e['id'],
              e['cash_totol'],
              e['cash'],
              e['discount'],
              e['net_amount'],
              e['change'],
              e['status'],
              e['status_sale'],
              e['paid_by'],
              e['user_id'],
              e['customer_id'],
              e['branch_id'],
              newStr
              // e['created_at'],
              );
          _order.add(model);
        });
      }
      order = _order;
      _order2 = _order;
      //  print(body2);
      notifyListeners();
    }
  }

  List<ListOrder_model> getDetailCustomer() {
    return custom_listOrder;
  }
  int gettiket() {
    return Tiket;
  }
  String gettotol() {
    return Totol.toStringAsFixed(1);
  }

  customerorder(id) async {
    List<ListOrder_model> custom_listOrder2 = [];
    var res = await Network().getData3('/order/customer/$id');
    var body = json.decode(res.body)['order'];
    if (body.length <= 0) {
        custom_listOrder.clear();
    }
    if (res.statusCode == 200) {
      int tiket = 0;
      double total = 0;
      body.forEach((e) {
         var str = e['created_at'];
          var newStr = str.substring(0, 10) + ' ' + str.substring(11, 19);
          ++tiket;
          total +=e['net_amount'];
        ListOrder_model model = ListOrder_model(
            e['id'],
            e['cash_totol'],
            e['cash'],
            e['discount'],
            e['net_amount'],
            e['change'],
            e['status'],
            e['status_sale'],
            e['paid_by'],
            e['user_id'],
            e['customer_id'],
            e['branch_id'],
            newStr);
        custom_listOrder2.add(model);
      });
      Tiket = tiket;
      Totol = total;
      custom_listOrder = custom_listOrder2;
      notifyListeners();
    }
  }
}
