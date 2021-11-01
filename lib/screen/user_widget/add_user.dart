import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos/network_api/api.dart';
import 'package:pos/provider/customer_provider.dart';
import 'package:provider/provider.dart';

class UserAddScreen extends StatefulWidget {
  const UserAddScreen({Key? key}) : super(key: key);
  static const RouteName = '/user_add';

  @override
  _UserAddScreenState createState() => _UserAddScreenState();
}

class _UserAddScreenState extends State<UserAddScreen> {
  final _name = TextEditingController();

  final _phone = TextEditingController();
  final _company = TextEditingController();
  final _address = TextEditingController();
  showAlertDialog(BuildContext context) {
    // Create button
    Widget load = Center(
      child: Padding(
        padding: const EdgeInsets.all(80.0),
        child: CircularProgressIndicator(),
      ),
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      actions: [
        load,
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
        title: Center(
          child: Text('เพิ่มลูกค้าลงในออร์เดอร์'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 200, right: 200, top: 50),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black38, width: 1),
              // borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  'ข้อมูลลูกค้า',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Container(
                  child: TextField(
                    controller: _company,
                    maxLength: 60,
                    decoration: InputDecoration(
                        labelText: 'ชื่อร้าน',
                        icon: Icon(
                          Icons.house_outlined,
                          size: 40,
                        )),
                  ),
                ),
                Container(
                  child: TextField(
                    controller: _name,
                    maxLength: 100,
                    decoration: InputDecoration(
                        labelText: 'ชื่อ นามสกุล',
                        icon: Icon(
                          Icons.person,
                          size: 40,
                        )),
                  ),
                ),
                Container(
                  child: TextField(
                    controller: _phone,
                    maxLength: 10,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    // initialValue: sum.toString(),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                    ],
                    decoration: InputDecoration(
                        labelText: 'เบอร์โทร',
                        icon: Icon(
                          Icons.phone,
                          size: 40,
                        )),
                  ),
                ),
                Container(
                  child: TextField(
                    controller: _address,
                    maxLines: 2,
                    maxLength: 200,
                    decoration: InputDecoration(
                        labelText: 'ที่อยู่',
                        icon: Icon(
                          Icons.maps_home_work_sharp,
                          size: 40,
                        )),
                  ),
                ),
                Container(
                  margin: EdgeInsets.zero,
                  width: double.infinity,
                  height: 100,
                  padding: EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () async {
                      showAlertDialog(context);
                      print('add customer');
                      var data = {
                        'company': _company.text,
                        'name': _name.text,
                        'phone': _phone.text,
                        'address': _address.text
                      };
                      var res = await Network().getData(data, '/customer');
                      if (res.statusCode == 200) {
                        print('res');
                        print(json.decode(res.body));
                        if (json.decode(res.body)['success'] == true) {
                        print(json.decode(res.body)['success'] );
                         Navigator.pop(context);
                         Provider.of<CustomerProvider>(context, listen: false).initCustomer();
                         Navigator.pop(context);
                        } else {
                          //ใส่ข้อมูลไม่ถูก
                        }
                      } else {
                        //connect server fail
                      }
                    },
                    child: Text(
                      'บันทึก',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
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
