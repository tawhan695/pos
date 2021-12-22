import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:charset_converter/charset_converter.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos/models/order_dertail_model.dart';
import 'package:pos/network_api/api.dart';
import 'package:pos/provider/cart_provider.dart';
import 'package:pos/provider/customer_provider.dart';
import 'package:pos/provider/printer_bluetooth.dart';
import 'package:pos/screen/sale_wholosale.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaySuccess extends StatefulWidget {
  const PaySuccess({ required this.change, required this.payment, required this.sum,required this.id,required this.user_id,required this.customer_id});
  static const RouteName = '/pay_cash';
   final String change;
   final String payment;
   final String sum;
   final String id;
   final String user_id;
   final String customer_id;


  @override
  _PaySuccessState createState() => _PaySuccessState();
}

class _PaySuccessState extends State<PaySuccess> {
  bool success = false;

  @override
  void initState() {
    super.initState();
    //  detail(widget.id);
    // print("getBranch()['name']");
    // getBranch();
    // print(Branches);
     Provider.of<ESC>(context, listen: false).getBranch();
     Provider.of<ESC>(context, listen: false).Print(widget.id,widget.customer_id,widget.user_id);
    // print(branch.length);
    // print(branch['name']);
     PrintTicket(widget.id,widget.customer_id,widget.user_id);

    // print(branch['name']);
    Provider.of<CartProvider>(context, listen: false).setEmpty();
    Timer(Duration(seconds: 3), () {
    print("Yeah, this line is printed after 3 seconds");
    setState(() {
      success = true;
    });
});
  }
    PrintTicket(id,customer_id,user_id){
      print('print : $id  $customer_id  $user_id');
    }
  
 @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
   
  // Provider.of<CustomerProvider>(context, listen: false).getName(widget.customer_id);
  
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    
    // try {

    // }catch (e) {
    //   print('error $e');
    //       }
    
  }
 
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Center(
        child: Container(
          // margin: EdgeInsets.only(top: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        widget.sum
                        ,
                        style: TextStyle(
                            fontSize: 50, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'ยอดเงินที่ชำระ',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 100,
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          double.parse(widget.change).toString(),
                          style: TextStyle(
                              fontSize: 50, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'เงินทอน',
                          style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Spacer(),
          success == false?
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('กำลังพิมพ์ ',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
              // SizedBox(width: 100, height: 100,child: CircularProgressIndicator()),
            SizedBox(width: 10, height: 10,),
            SizedBox(
              width: 70, height: 70,
              child: CircularProgressIndicator(
                strokeWidth: 20,
                valueColor : AlwaysStoppedAnimation(Colors.orange),
              ),
            ),
            ],
          ):
          Container(
            width: 600,
            height: 70,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(SaleWholosale.RouteName, (route) => false);
              },
              child: Text('เริ่มการขายใหม่', style: TextStyle(fontSize: 30)),
            ),
          )
            ],
          ),
        ),
      ),
    );
  }
}
