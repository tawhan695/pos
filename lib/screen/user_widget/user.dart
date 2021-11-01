import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos/models/customer_model.dart';
import 'package:pos/provider/customer_provider.dart';
import 'package:pos/screen/user_widget/add_user.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);
  static const RouteName = '/user_main';

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _name = TextEditingController();

  final _phone = TextEditingController();
  final _company = TextEditingController();
  final _address = TextEditingController();
  late FocusNode focusNode;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    

    // FocusScope.of(context).unfocus();
    // focusNode = FocusNode();
    // focusNode.addListener(() {
    //   print('Listener');
    // });
    // focusNode.unfocus();
    // provider.initCustomer();
    //  print(provider.getListCustomer());
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<CustomerProvider>(context, listen: false).initCustomer();
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('เพิ่มลูกค้าลงในออร์เดอร์'),
        ),
      ),
      body: 
      Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 200, right: 200, top: 50),
                  // padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        // border: Border.all(color: Colors.black38, width: 3),
                        // borderRadius: BorderRadius.circular(20),
                        ),
                    child: Column(
                      children: <Widget>[
                        // Text(
                        //   'ข้อมูลลูกค้า',
                        //   style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        // ),
                        Container(
                          child: TextField(
                            controller: _company,
                            autofocus: false,
                            showCursor: true,
                            keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9]')),
                            ],
                            onChanged: (text) {
                              
                              Provider.of<CustomerProvider>(context, listen: false).getindex(text);
                            },
                            maxLength: 10,
                            decoration: InputDecoration(
                              labelText: 'ค้นหา',
                              icon: Icon(
                                Icons.search,
                                size: 40,
                              ),
                              hintText: 'เบอร์โทร',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          width: double.infinity,
                          height: 100,
                          padding: EdgeInsets.all(20),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(UserAddScreen.RouteName);
                            },
                            child: Text(
                              'เพิ่มลูกค้า',
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 40),
                                child: Text(
                                  'รายชื่อลูกค้า',
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 300, right: 300),
                child: Center(
                  child: Consumer(
                    builder: (context, CustomerProvider customers, Widget) {
                      int count = customers.getListCustomer().length;
                      if (count > 0) {
                        print(customers.getListCustomer()[0]);
                        return
                            // Container();
                            ListView.builder(
                          //   // shrinkWrap: true,
                          itemCount: count,
                          itemBuilder: (context, index) {
                            var customer = customers.getListCustomer()[index];
                            // print('customer.name${customer.name}');
                            // return Container();
                            return Card(
                              child: ListTile(
                                leading: Icon(
                                  Icons.person_pin_outlined,
                                  size: 40,
                                ),
                                title: Text(
                                  customer.company,
                                  style: TextStyle(fontSize: 25),
                                ),
                                subtitle: Text(
                                  'คุณ ${customer.name} tel:${customer.phone}',
                                  style: TextStyle(fontSize: 20),
                                ),
                                trailing: IconButton(
                                    color: Colors.green,
                                    icon: Icon(
                                      Icons.add,
                                      size: 50,
                                    ),
                                    onPressed: () {
                                      Provider.of<CustomerProvider>(context,
                                              listen: false)
                                          .addCustomer(customer);

                                      // ฝฝเลือกแล้วย้อนกลับ

                                      Navigator.pop(context);
                                    }),
                                //  Icon(Icons.add,size: 50,),
                              ),
                            );
                          },
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('ไม่พบข้อมูล'),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
