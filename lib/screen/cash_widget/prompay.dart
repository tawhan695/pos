import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pos/network_api/api.dart';
import 'package:pos/provider/cart_provider.dart';
import 'package:pos/provider/customer_provider.dart';
import 'package:pos/provider/order_provider.dart';
import 'package:pos/screen/payment_widget/payment.dart';
import 'package:provider/provider.dart';

class Promptpay extends StatefulWidget {
  const Promptpay({Key? key}) : super(key: key);

  @override
  _PromptpayState createState() => _PromptpayState();
}

class _PromptpayState extends State<Promptpay> {
  bool _submit = true;
  List ListJson = [];
  var sum;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListCart();
     var provider = Provider.of<CartProvider>(context, listen: false);
    sum = provider.getSum();
  }

  getListCart() {
    var cart = Provider.of<CartProvider>(context, listen: false).getCart();
    print(cart);

    cart.forEach((e) {
      var toJson = {
        'quantity': e.quantity,
        'product_id': e.product_id,
        'price': e.price,
        'status_sale': e.status_sale,
        // 'retail_price': e.retail_price,
      };
      setState(() {
        ListJson.add(toJson);
      });
    });
    // var json = jsonEncode(ListJson, toEncodable: (e) => e.toJsonAttr());
    // print(json);
    print(jsonEncode(ListJson));
    String data = jsonEncode(ListJson);
    
    // print(jsonDecode(data)[0]);
  }

  @override
  Widget build(BuildContext context) {
   
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Column(
            children: [
              Image.network(
                'https://promptpay.io/0655577688/$sum',
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, exception, stackTrack) => Icon(
                  Icons.error,
                ),
              ),
              Text(
                'พร้อมเพย์ 0655577688 ฿$sum',
                style: TextStyle(fontSize: 30),
              ),
            ],
          ),
        ),
        Container(
          width: 400,
          height: 80,
          margin: EdgeInsets.only(top: 20),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
            ),
            onPressed: () async {
              print('payment>>');
              var data = {
                 'cart': jsonEncode(ListJson),
                'cash': Provider.of<CartProvider>(context, listen: false)
                    .getSum()
                    .toString(),
                'payid_by': 'พร้อมเพย์',
                'customer':
                    Provider.of<CustomerProvider>(context, listen: false)
                                .selectCustomer()
                                .length >
                            0
                        ? Provider.of<CustomerProvider>(context, listen: false)
                            .selectCustomer()[0]
                            .phone
                            .toString()
                        : '0',
              };
              print(data);
              final response = await Network().getData(data, '/sale');
              var body = json.decode(response.body);

              // Navigator.of(context).pushReplacementNamed(PaySuccess.RouteName);
              // pushNamedAndRemoveUntil คำสั่งนี้ไม่มีปุ้มย้อนกลับ
              print(body);
              if (body['success']) {
               try {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaySuccess(
                          change: body['change'].toString(),
                          payment: 'เงินสด',
                          sum: sum.toString(),
                          id: body['order'].toString(),
                          user_id: body['user_id'].toString(),
                          customer_id: body['customer_id'].toString()),
                    ),
                    (route) => false);
                Provider.of<CustomerProvider>(context, listen: false)
                    .emtySelect();
               }catch (e) {
                 print('error: $e');
               }
              } else {
                print('ไม่สำเร็จ');
              }
              //   Navigator.of(context).pushNamedAndRemoveUntil(
              //       PaySuccess.RouteName, (route) => false);
            },
            //  icon: Icon(Icons.attach_money_rounded),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.attach_money,
                  size: 35,
                ),
                Text(
                  'ชำระเงิน',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
