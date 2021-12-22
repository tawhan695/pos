import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pos/models/order_dertail_model.dart';
import 'package:pos/models/order_model.dart';
import 'package:pos/network_api/api.dart';
import 'package:pos/provider/customer_provider.dart';
import 'package:pos/provider/printer_bluetooth.dart';
import 'package:pos/screen/receipt.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetail extends StatefulWidget {
  final String title;
  final ListOrder_model order;
  const OrderDetail(this.title, this.order);
  static const RoteName = 'order_detail';
  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  List<OrdreDetail> listData = [];
  var USER = '';
  var USER_id;
  bool print_status = false;
  detail(id) async {
    List<OrdreDetail> _detail = [];
    var res = await Network().getData({'id': '$id'}, '/order/detail');
    if (res != 'error') {
      var body = json.decode(res.body)['detail'];
      // print(body);
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
    setState(() => listData = _detail);
    // listData =  _detail;
    return _detail;
  }

  user_sale() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user').toString());
    print(user['name']);
    setState(() {
      USER = user['name'];
      USER_id = user['id'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    detail('${widget.title}');

    print(listData);
    user_sale();
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("ยกเลิก"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("ยืนยัน"),
      onPressed: () async {
        final res = await Network().getDataEmpty('/order/${widget.order.id}');
        if (res != 'error') {
          var links = json.decode(res.body)['success'];
          print(links);
          if (links == true) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(Receipt.RouteName, (route) => false);
          } else {
            Navigator.of(context).pop();
          }
        }
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("แน่ใจหรือไม่ที่ต้องการลบรายการนี้ ${widget.order.id}"),
      content: Text("หาก ยืนยันการลบแล้วจะไม่สามารถกู้ข้อมูลกลับมาได้ !!"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ใบเสร็จที่ #${widget.title}',
              style: TextStyle(fontSize: 25)),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                  primary: Theme.of(context).colorScheme.onPrimary),
              onPressed: () {
                showAlertDialog(context);
              },
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
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: CustomScrollView(slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Center(
                      child: Text(
                        '${widget.order.net_amount}',
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'รวมทั้งหมด',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Container(
                        // padding: EdgeInsets.only(top: 20, bottom: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                                width: 2.0, color: Colors.grey.shade300),
                            //   bottom: BorderSide(
                            //       width: 16.0, color: Colors.lightBlue.shade900),
                          ),
                          // color: Colors.white,
                        ),
                        child: null),
                  ),
                  Text(
                    'แคชเชียร์: ${USER}',
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    'ลูกค้า:  ${Provider.of<CustomerProvider>(context, listen: false).getName(widget.order.customer_id.toString())}',
                    style: TextStyle(fontSize: 24),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Container(
                        // padding: EdgeInsets.only(top: 20, bottom: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                                width: 2.0, color: Colors.grey.shade300),
                            //   bottom: BorderSide(
                            //       width: 16.0, color: Colors.lightBlue.shade900),
                          ),
                          // color: Colors.white,
                        ),
                        child: null),
                  ),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  print(listData.length);
                  if (listData.length > 0) {
                    return Container(
                      child: Row(
                        children: [
                          Container(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${listData[index].name}',
                                  style: TextStyle(fontSize: 22)),
                              Text(
                                  '${listData[index].qty} X ${listData[index].price}',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.grey)),
                            ],
                          )),
                          Spacer(),
                          Container(
                              child: Column(
                            children: [
                              Text('', style: TextStyle(fontSize: 20)),
                              Text('${listData[index].totol}',
                                  style: TextStyle(fontSize: 20)),
                            ],
                          )),
                        ],
                      ),
                    );
                  } else {
                    return new Container(
                      child: Center(child: new CircularProgressIndicator()),
                    );
                  }
                },
                childCount: listData.length,
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Container(
                      // padding: EdgeInsets.only(top: 20, bottom: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                              width: 2.0, color: Colors.grey.shade300),
                          //   bottom: BorderSide(
                          //       width: 16.0, color: Colors.lightBlue.shade900),
                        ),
                        // color: Colors.white,
                      ),
                      child: null),
                ),
                Center(
                  child: Text(" ( ${widget.order.status_sale} ) ",
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                ),
                Container(
                    child: Row(
                  children: [
                    Text("รวมทั้งหมด",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    Spacer(),
                    Text("${widget.order.net_amount}",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                )),
                Container(
                    child: Row(
                  children: [
                    Text("${widget.order.paid_by}",
                        style: TextStyle(
                          fontSize: 20,
                        )),
                    Spacer(),
                    Text("${widget.order.cash}",
                        style: TextStyle(
                          fontSize: 20,
                        )),
                  ],
                )),
                Container(
                    child: Row(
                  children: [
                    Text("เงินทอน",
                        style: TextStyle(
                          fontSize: 20,
                        )),
                    Spacer(),
                    Text("${widget.order.change}",
                        style: TextStyle(
                          fontSize: 20,
                        )),
                  ],
                )),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Container(
                      // padding: EdgeInsets.only(top: 20, bottom: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                              width: 2.0, color: Colors.grey.shade300),
                          //   bottom: BorderSide(
                          //       width: 16.0, color: Colors.lightBlue.shade900),
                        ),
                        // color: Colors.white,
                      ),
                      child: null),
                ),
                Text("${widget.order.created_at}",
                    style: TextStyle(
                      fontSize: 20,
                    )),
                Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            print_status = true;
                          });
                          var cus = Provider.of<CustomerProvider>(context,
                                  listen: false)
                              .getName(widget.order.customer_id.toString());
                          Provider.of<ESC>(context, listen: false)
                              .Print(widget.order.id, cus, USER);
                          Timer(Duration(seconds: 7), () {
                            setState(() {
                              print_status = false;
                            });
                          });
                        },
                        icon: Icon(Icons.print_rounded,
                            size: 50.0, color: Colors.blue)),
                    Center(
                        child: Text(
                            print_status == false
                                ? '     พิมพ์'
                                : '     กำลังพิมพ์...',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold))),
                  ],
                )),
              ]),
            ),
          ]),
        ));
  }
}
