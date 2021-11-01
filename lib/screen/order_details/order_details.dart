import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pos/models/order_dertail_model.dart';
import 'package:pos/models/order_model.dart';
import 'package:pos/network_api/api.dart';

class OrderDetail extends StatefulWidget {
  final String title;
  final ListOrder_model order;
  const OrderDetail(this.title, this.order);
  static const RoteName = 'order_detail';
  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  Future<List<OrdreDetail>> detail(id) async {
    List<OrdreDetail> _detail = [];
    var res = await Network().getData({'id': '$id'}, '/order/detail');
    if (res != 'error'){
      var body = json.decode(res.body)['detail'];
    print(body);
    body.forEach((e) {
      print(e);
      OrdreDetail item = OrdreDetail(
        e['unit'],
        e['id'],
        e['product_id'],
        e['order_id'],
        e['name'],
        e['price'],
        e['totol'],
        e['qty'],
        e['created_at'],
      );
      _detail.add(item);
    });
    }
    return _detail;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('ใบเสร็จที่ #${widget.title}', style: TextStyle(fontSize: 25)),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
                primary: Theme.of(context).colorScheme.onPrimary),
            onPressed: () {},
            child: const Text(
              'ยกเลิกใบเสร็จ',
              style: TextStyle(fontSize: 25),
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
          // IconButton(
          //   onPressed: (){},
          //   icon: Icon(Icons.cancel)
          // )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left:80.0,right:80),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Center(
                  child: Text(
                    '${widget.order.net_amount}',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Center(
                child: Text(
                  'รวมทั้งหมด',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Text(
                'แคชเชียร์: ${widget.order.user_id}',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                'ลูกค้า:  ${widget.order.customer_id}',
                style: TextStyle(fontSize: 20),
              ),
              Expanded(
                child: FutureBuilder(
                    future: detail('${widget.title}'),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.data != null) {
                        return Container(
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  child: Text('${snapshot.data[index].name}'),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
