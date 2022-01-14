import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos/network_api/api.dart';
import 'package:pos/provider/cart_provider.dart';
import 'package:pos/provider/customer_provider.dart';
import 'package:pos/provider/order_provider.dart';
import 'package:pos/screen/change/change.dart';
import 'package:pos/screen/payment_widget/payment.dart';
import 'package:provider/provider.dart';

class Cash extends StatefulWidget {
  const Cash({Key? key}) : super(key: key);

  @override
  _CashState createState() => _CashState();
}

class _CashState extends State<Cash> {
  bool _submit = false;
  List ListJson = [];
  bool SubmitJson = false;
  double sum = 0.0;
  double sum_ = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListCart();
    setState(() {
      sum =
          double.parse(Provider.of<CartProvider>(context, listen: false).getSum().toString());
      sum_ = sum;
      if (sum >= sum_) {
        _submit = true;
      } else {
        _submit = false;
      }
    });
  }

  getListCart() {
    try {
      var cart = Provider.of<CartProvider>(context, listen: false).getCart();
      print('cart :>>>> $cart');

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
    } catch (e) {
      print('error $e');
    }
    // print(jsonDecode(data)[0]);
  }

  // final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // var provider = Provider.of<CartProvider>(context, listen: false);
    // setState(() {
    //   // sum = sum_;
    //   sum_ = sum;
    // });
    // _controller.text = sum;
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(80.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Row(
                //   children: [
                //     Text('เงินสดรับ'),
                //   ],
                // ),
                Container(
                  width: 400,
                  child: SizedBox(
                    // height: 300,
                    child: TextFormField(
                      // autofocus: true,
                      cursorHeight: 10,
                      // expands: true ,
                      // cursorWidth: 300,
                      // controller: _controller,
                      key: Key(sum.toString()),
                      initialValue: sum.toString(),
                      onChanged: (val) {
                        if (double.parse(val) >= sum_) {
                          setState(() {
                            _submit = true;
                          });
                        } else if (double.parse(val) < sum_) {
                          setState(() {
                            _submit = false;
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      // initialValue: sum.toString(),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),
                      ],
                      decoration: InputDecoration(
                        labelText: "เงินสดรับ",
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        hintText: "จำนวนเงิน",
                        // border: InputBorder.none,
                        icon: Icon(
                          Icons.edit_outlined,
                          size: 26,
                        ),
                        //               border: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(32.0)
                        // ),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Card(
                            child: SizedBox(
                                width: 100,
                                height: 70,
                                child: FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        sum += 5.0;
                                        if (sum >=
                                            sum_) {
                                          _submit = true;
                                        } else {
                                          _submit = false;
                                        }
                                      });
                                    },
                                    child: Center(
                                        child: Text('5',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22))))),
                          ),
                          Card(
                            child: SizedBox(
                                width: 100,
                                height: 70,
                                child: FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        sum += 10.0;
                                        if (sum >=
                                            sum_) {
                                          _submit = true;
                                        } else {
                                          _submit = false;
                                        }
                                      });
                                    },
                                    child: Center(
                                        child: Text('10',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22))))),
                          ),
                          Card(
                            child: SizedBox(
                                width: 100,
                                height: 70,
                                child: FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        sum += 20.0;
                                        if (sum >=
                                            sum_) {
                                          _submit = true;
                                        } else {
                                          _submit = false;
                                        }
                                      });
                                    },
                                    child: Center(
                                        child: Text('20',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22))))),
                          ),
                         
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Card(
                            child: SizedBox(
                                width: 100,
                                height: 70,
                                child: FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        sum += 100.0;
                                        if (sum>=
                                           sum_) {
                                          _submit = true;
                                        } else {
                                          _submit = false;
                                        }
                                      });
                                    },
                                    child: Center(
                                        child: Text('100',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22))))),
                          ),
                          Card(
                            child: SizedBox(
                                width: 100,
                                height: 70,
                                child: FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        sum += 200.0;
                                        if (sum >=
                                           sum_) {
                                          _submit = true;
                                        } else {
                                          _submit = false;
                                        }
                                      });
                                    },
                                    child: Center(
                                        child: Text('200',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22))))),
                          ),
                          Card(
                            child: SizedBox(
                                width: 100,
                                height: 70,
                                child: FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        sum += 500.0;
                                        if (sum >=
                                           sum_) {
                                          _submit = true;
                                        } else {
                                          _submit = false;
                                        }
                                      });
                                    },
                                    child: Center(
                                        child: Text('500',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22))))),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Card(
                            child: SizedBox(
                                width: 100,
                                height: 70,
                                child: FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        sum += 800.0;
                                        if (sum >=
                                           sum_) {
                                          _submit = true;
                                        } else {
                                          _submit = false;
                                        }
                                      });
                                    },
                                    child: Center(
                                        child: Text('800',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22))))),
                          ),
                          Card(
                            child: SizedBox(
                                width: 100,
                                height: 70,
                                child: FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        sum += 1000.0;
                                        if (sum >=
                                            sum_) {
                                          _submit = true;
                                        } else {
                                          _submit = false;
                                        }
                                      });
                                    },
                                    child: Center(
                                        child: Text('1000',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22))))),
                          ),
                          Card(
                            child: SizedBox(
                                width: 100,
                                height: 70,
                                child: FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        sum = 0.0;

                                        _submit = false;
                                      });
                                    },
                                    child: Center(
                                        child: Text('ล้าง',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22))))),
                          ),
                        ],
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
                    onPressed: _submit
                        ? () async {
                            // print(
                            //     'tel: ${Provider.of<CustomerProvider>(context,
                            //               listen: false)
                            //           .selectCustomer()[0]
                            //           .phone
                            //           .toString()}');
                            var data = {
                              'cart': jsonEncode(ListJson),
                              'cash': sum,
                              'payid_by': 'เงินสด',
                              'customer': Provider.of<CustomerProvider>(context,
                                              listen: false)
                                          .selectCustomer()
                                          .length >
                                      0
                                  ? Provider.of<CustomerProvider>(context,
                                          listen: false)
                                      .selectCustomer()[0]
                                      .phone
                                      .toString()
                                  : '0',
                            };
                            print(data);
                            // print(jsonEncode(ListJson));

                            final response =
                                await Network().getData(data, '/sale');
                            var body = json.decode(response.body);

                            // Navigator.of(context).pushReplacementNamed(PaySuccess.RouteName);
                            // pushNamedAndRemoveUntil คำสั่งนี้ไม่มีปุ้มย้อนกลับ
                            print(body);

                            if (body['success']) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PaySuccess(
                                          change: body['change'].toString(),
                                          payment: 'เงินสด',
                                          sum: sum.toStringAsFixed(1).toString(),
                                          id: body['order'].toString(),
                                          user_id: body['user_id'].toString(),
                                          customer_id:
                                              body['customer_id'].toString())),
                                  (route) => false);
                              Provider.of<CustomerProvider>(context,
                                      listen: false)
                                  .emtySelect();
                            } else {
                              print('ไม่สำเร็จ');
                            }

                            // Navigator.pushReplacementNamed(context,Change.RouteName);
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                PaySuccess.RouteName, (route) => false);
                          }
                        : null,
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
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:pos/provider/order_provider.dart';
// import 'package:provider/provider.dart';

// class Cash extends StatelessWidget {
//   // Cash();

//   const Cash();

//   @override
//   Widget build(BuildContext context) {
//     var provider = Provider.of<OrderProvider>(context, listen: false);
//     var sum = provider.getSum();
//     var _controller = TextEditingController();
//     return 
//     SingleChildScrollView(
//       child: Container(
//         child: Padding(
//           padding: const EdgeInsets.all(80.0),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Row(
//                 //   children: [
//                 //     Text('เงินสดรับ'),
//                 //   ],
//                 // ),
//                 Container(
//                   width: 400,
//                   child: SizedBox(
//                     // height: 300,
//                     child: TextFormField(
//                       autofocus: true,
//                       cursorHeight: 10,
//                       // expands: true ,
//                       // cursorWidth: 300,
//                       controller: _controller,
//                       validator: (value) {
//                         double val = double.parse(sum);
//                         if (double.parse(value!) < val) {}
//                       },
//                       keyboardType: TextInputType.number,
//                       // initialValue: '30',
//                       inputFormatters: <TextInputFormatter>[
//                         WhitelistingTextInputFormatter.digitsOnly
//                       ],
//                       decoration: InputDecoration(
//                         labelText: "เงินสดรับ",
//                         contentPadding:
//                             EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//                         hintText: "จำนวนเงิน",
//                         // border: InputBorder.none,
//                         icon: Icon(
//                           Icons.edit_outlined,
//                           size: 26,
//                         ),
//                         //               border: OutlineInputBorder(
//                         // borderRadius: BorderRadius.circular(32.0)
//                         // ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   width: 400,
//                   height: 80,
//                   margin: EdgeInsets.only(top: 20),
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       shape: const BeveledRectangleBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(15))),
//                     ),
//                     onPressed: () {
//                       // Navigator.push(
//                       //   context,
//                       //   MaterialPageRoute(
//                       //       builder: (context) => Cash_screen()),
//                       // );
//                     },
//                     //  icon: Icon(Icons.attach_money_rounded),

//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.attach_money,
//                           size: 35,
//                         ),
//                         Text(
//                           'ชำระเงิน',
//                           style: TextStyle(
//                               fontSize: 30, fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
