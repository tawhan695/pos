import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos/network_api/api.dart';
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
  bool _submit = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<OrderProvider>(context, listen: false);
    var sum = provider.getSum();
    _controller.text = sum.toString();
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(80.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      controller: _controller,
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
                            print(_controller.text);
                            var data = {
                              'cash': _controller.text,
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
                                          sum: sum.toString())),
                                  (route) => false);
                              Provider.of<CustomerProvider>(context,
                                      listen: false)
                                  .emtySelect();
                            } else {
                              print('ไม่สำเร็จ');
                            }

                            // Navigator.pushReplacementNamed(context,Change.RouteName);
                            //  Navigator.of(context).pushNamedAndRemoveUntil(PaySuccess.RouteName, (route) => false);
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
