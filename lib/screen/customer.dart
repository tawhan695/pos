import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:pos/network_api/api.dart';
import 'package:pos/provider/customer_provider.dart';
import 'package:pos/screen/login.dart';
// import 'package:pos/screen/page_emty.dart';
import 'package:pos/screen/product/product.dart';
import 'package:pos/screen/receipt.dart';
import 'package:pos/screen/remove_product/remove_product.dart';
import 'package:pos/screen/sale_wholosale.dart';
import 'package:pos/screen/setting.dart';
import 'package:pos/screen/user_widget/add_user.dart';
import 'package:provider/provider.dart';

class Customer extends StatefulWidget {
  // const Customer({ Key? key }) : super(key: key);
  static const RouteName = '/customer';

  @override
  _CustomerState createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  final _advancedDrawerController = AdvancedDrawerController();
  final _company = TextEditingController();
  @override
  void initState() {
    super.initState();
    Provider.of<CustomerProvider>(context, listen: false).initCustomer();
  }
  @override
  Widget build(BuildContext context) {
      return AdvancedDrawer(
      backdropColor: Color(0xffFF8F33),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      drawer: SafeArea(
        child: Container(
          child: ListTileTheme(
            textColor: Colors.white,
            iconColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 128.0,
                  height: 128.0,
                  margin: const EdgeInsets.only(
                    top: 24.0,
                    // bottom: 64.0,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    // color: Colors.black26,
                    color: Color(0xffFE7300),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/5942.png',
                  ),
                ),
                Center(
                  child: Text('ออกจากระบบ'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(SaleWholosale.RouteName, (route) => false);
                  },
                  
                  leading: Icon(
                    Icons.storefront_sharp,
                   
                  ),
                  title: Text(
                    'ขาย',
                   
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(Receipt.RouteName, (route) => false);
                  },
                  leading: Icon(Icons.list_alt_rounded,
                   ),
                  // tileColor: Colors.white,
                  title: Text('ใบเสร็จ',
                  
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        RemoveProduct.RouteName, (route) => false);
                  },
                  leading: Icon(Icons.remove_shopping_cart),
                  title: Text('สินค้าชำรุด',),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(Customer.RouteName, (route) => false);
                  },
                  leading: Icon(Icons.person,
                  color: Colors.orange,
                  ),
                  tileColor: Colors.white,
                  title: Text('ลูกค้า',
                   style: TextStyle(color: Colors.orange,),
                   
                  ),
                ),
                ListTile(
                  onTap: () {
                    //  Navigator.of(context).pushNamedAndRemoveUntil(Customer.RouteName, (route) => false);
                    Navigator.of(context).pushNamed(ProductScreen.RouteName);
                  },
                  leading: Icon(Icons.card_travel),
                  title: Text('รายการสินค้า'),
                ),
                ListTile(
                  onTap: () {
                     
                     Navigator.of(context).pushNamedAndRemoveUntil(Setting.RouteName, (route) => false);
                  },
                  leading: Icon(Icons.settings,
                  
                  ),
                  title: Text('ตั้งค่า',
                  // style: TextStyle(color: Colors.orange),
                  ),
                ),
                ListTile(
                    leading: Icon(Icons.logout),
                    onTap: () async {
                      var stt = await Network().logOut();
                      //print('stt $stt');
                      if (stt == true) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            Login.RouteName, (route) => false);
                      }
                    },
                    title: Text('ออกจากระบบ')),
                Spacer(),
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 16.0,
                    ),
                    child: Text('Terms of Service | Privacy Policy'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tawhan POS ( มัทนาไข่สด )'),
          leading: IconButton(
            onPressed: _handleMenuButtonPressed,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 250),
                  child: Icon(
                    value.visible ? Icons.clear : Icons.menu,
                    key: ValueKey<bool>(value.visible),
                  ),
                );
              },
            ),
          ),
        ),
        body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 100, right: 100, top: 50),
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
                padding: const EdgeInsets.only(left: 100, right: 100),
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
                                      Icons.person,
                                      size: 50,
                                    ),
                                    onPressed: () {
                                      // Provider.of<CustomerProvider>(context,
                                      //         listen: false)
                                      //     .addCustomer(customer);

                                      // // ฝฝเลือกแล้วย้อนกลับ

                                      // Navigator.pop(context);
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
        ),
        );
        
        
      
  }
   void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}