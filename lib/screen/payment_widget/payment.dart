import 'dart:convert';
import 'dart:typed_data';

import 'package:charset_converter/charset_converter.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos/models/order_dertail_model.dart';
import 'package:pos/network_api/api.dart';
import 'package:pos/provider/customer_provider.dart';
import 'package:pos/provider/printer_bluetooth.dart';
import 'package:pos/screen/sale_wholosale.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaySuccess extends StatefulWidget {
  const PaySuccess({ required this.change, required this.payment, required this.sum,required this.id,required this.user_id,required this.customer_id});
  static const RouteName = '/pay';
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
//   List Branches = []; 
//  getBranch() async { 
//    SharedPreferences localStorage = await SharedPreferences.getInstance();
//    var branch = jsonDecode(localStorage.getString('branch').toString());
   
//   //  print(branch);
//   //  print(branch);
//   //  print(branch['name']);
 
    
//    Branches.add(branch['name']);
//    Branches.add(branch['des']);
//    print('11 Branches  object ${Branches}');
  
   
//    return Branches ;
//    }
  @override
  void initState() {
    super.initState();
    //  detail(widget.id);
    // print("getBranch()['name']");
    // getBranch();
    // print(Branches);
     Provider.of<ESC>(context, listen: false).Print(widget.id,widget.customer_id,widget.user_id);
    // print(branch.length);
    // print(branch['name']);

    // print(branch['name']);
  
  }
 @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
   
  // Provider.of<CustomerProvider>(context, listen: false).getName(widget.customer_id);
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
                        'ยอกเงินที่ชำระ',
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
                          widget.change,
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
