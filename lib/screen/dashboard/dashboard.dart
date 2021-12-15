import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pos/models/product_model.dart';
import 'package:pos/network_api/api.dart';
import 'package:pos/provider/product_provider.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key? key}) : super(key: key);
  static const RouteName = 'dashboard';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var Wallet;
  var Defective;
  var Order;
  var ordersum;
  var product;
  List PRODUCT = [];
  var search = '';
  String URL = 'https://tawhan.xyz/';
  bool Issearch = false;
  void getWallet() async {
    var res = await Network().getData3('/wallet');
    if (res != 'error') {
      var wallet = jsonDecode(res.body)['wallet'];
      var Defective_r = jsonDecode(res.body)['Defective'];
      var Order_r = jsonDecode(res.body)['Order'];
      var ordersum_r = jsonDecode(res.body)['ordersum'];
      var product_r = jsonDecode(res.body)['product'];
      print(wallet);
      setState(() {
        Wallet = wallet;
        Defective = Defective_r;
        Order = Order_r;
        ordersum = ordersum_r;
        product = product_r;
        print('Wallet $Wallet');
      });
    }
  }

  getProducts() async {
    var sale_id = 0;
    var res;
    
      res = await Network().getData2(
           '/product/details');
  
    List productModel = [];
    if (res == 'error') {
      // _AlertNet(context);
    } else {
      var body = json.decode(res.body)['product'];
      body.forEach(
        (e) {
               productModel.add(
                  [e['num'],
                  e['name'],
                  e['qty_1'],
                  e['price_1'],
                  e['qty_2'],
                  e['price_2'],
                  e['sum_qty'],
                  e['sum_price'],
                  e['img'],
                  ]
                 );
        },
      );
    }
    setState(() {
      PRODUCT = productModel;
    });
  }

  @override
  void initState() {
    super.initState();
    getWallet();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายงาน'),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
                primary: Theme.of(context).colorScheme.onPrimary),
            onPressed: () {
              // showAlertDialog(context);
            },
            child: Row(
              children: [
                Icon(
                  Icons.library_books_outlined,
                  // Container(margin: EdgeInsets.all(5),
                ),
                Text(
                  'สรุปการขาย',
                  style: TextStyle(fontSize: 25),
                ),
              ],
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
      body: Container(
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  // margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          '$Wallet',
                          style: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                        Text(
                          'ยอดคงเหลือ',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  // padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Card(
                        color: Colors.deepPurpleAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 8,
                        child: Container(
                            padding: EdgeInsets.all(10),
                            width: 400,
                            height: 100,
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    child: Text('ยอดขาย',
                                        style: TextStyle(fontSize: 20))),
                                Container(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text('$Order',
                                        style: TextStyle(
                                            fontSize: 40,
                                            color: Colors.black87))),
                              ],
                            )),
                      ),
                      Card(
                        color: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 8,
                        child: Container(
                            padding: EdgeInsets.all(10),
                            width: 400,
                            height: 100,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text('กำไรวันนี้',
                                //     style: TextStyle(fontSize: 20)),
                                Container(
                                    child: Text('กำไรวันนี้',
                                        style: TextStyle(fontSize: 20))),
                                Container(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text('$ordersum',
                                        style: TextStyle(
                                            fontSize: 40,
                                            color: Colors.black87))),
                              ],
                            )),
                      ),
                      Card(
                        color: Colors.yellow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 8,
                        child: Container(
                            padding: EdgeInsets.all(10),
                            width: 400,
                            height: 100,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text('สินค้าชำรุด',
                                //     style: TextStyle(fontSize: 20)),
                                Container(
                                    child: Text('สินค้าชำรุด',
                                        style: TextStyle(fontSize: 20))),
                                Container(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text('$Defective',
                                        style: TextStyle(
                                            fontSize: 40,
                                            color: Colors.black87))),
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
                Card(
                  margin: EdgeInsets.only(
                      left: 57.0, right: 57.0, top: 30.0, bottom: 30.0),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 8,
                  child: Container(
                    margin: EdgeInsets.only(left: 20.0, right: 20.0),
                    width: 100,
                    // height: 100,
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            'รายการขายวันนี้',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                        DataTable(
                          columns: [
                            DataColumn(
                              label: Text(
                                '#',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'สินค้า',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'ยอดขายปลีก',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'ยอดเงิน(ปลีก)',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'ยอดขายส่ง',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'ยอดเงิน(ส่ง)',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'ยอดขายรวม',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'ยอดเงินขายรวม',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                          rows: 
                            PRODUCT
                                .map(
                                  (e) => DataRow(
                                    cells: [
                                      DataCell(Image.network(
                                  "${URL + e[8]}",
                                  fit: BoxFit.contain,
                                  width: 50,
                                  // height: 200,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                        child: CircularProgressIndicator());
                                  },
                                  errorBuilder:
                                      (context, exception, stackTrack) => Icon(
                                    Icons.error,
                                  ),
                                ),),
                                      DataCell(Text(
                                        e[1].length > 11 ? '${e[1].substring(0,10)}..'
                                        :'${e[1]}')
                                        ),
                                      DataCell(Text('${e[2]}')),
                                      DataCell(Text('${e[3]}')),
                                      DataCell(Text('${e[4]}')),
                                      DataCell(Text('${e[5]}')),
                                      DataCell(Text('${e[6]}')),
                                      DataCell(Text('${e[7]}')),
                                      
                                      ],
                                  ),
                                )
                                .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.only(
                      left: 57.0, right: 57.0, top: 30.0, bottom: 30.0),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 8,
                  child: Container(
                    margin: EdgeInsets.only(left: 20.0, right: 20.0),
                    width: 100,
                    height: 100,
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
