import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos/network_api/api.dart';
import 'package:pos/provider/cart_provider.dart';
import 'package:pos/provider/customer_provider.dart';
import 'package:pos/provider/list_order_provider.dart';
import 'package:pos/provider/order_provider.dart';
import 'package:pos/provider/product_provider.dart';
import 'package:pos/provider/remove_provider.dart';
import 'package:pos/screen/CheckConnect.dart';
import 'package:pos/screen/Landing.dart';
import 'package:pos/screen/change/change.dart';
import 'package:pos/screen/customer.dart';
import 'package:pos/screen/dashboard/dashboard.dart';
// import 'package:pos/provider/product_provider.dart';
import 'package:pos/screen/login.dart';
import 'package:pos/screen/payment_widget/payment.dart';
import 'package:pos/screen/product/product.dart';
import 'package:pos/screen/receipt.dart';
import 'package:pos/screen/remove_product/remove_product.dart';
// import 'package:pos/routes/app_routes.dart';
import 'package:pos/screen/sale.dart';
import 'package:pos/screen/sale_wholosale.dart';
import 'package:pos/screen/setting.dart';
import 'package:pos/screen/user_widget/add_user.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'provider/printer_bluetooth.dart';
// import 'package:pos/screen/sale_wholosale.dart';
// import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

Future<void> main() async {
  // setlandscape
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }

  @override
  Widget build(BuildContext context) {
 
    return Container(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context){
            return OrderProvider();
          }),
          ChangeNotifierProvider(create: (context){
            return CartProvider();
          }),
          ChangeNotifierProvider(create: (context){
            return CustomerProvider();
          }),
          ChangeNotifierProvider(create: (context){
            return ListOrderProvider();
          }),
          ChangeNotifierProvider(create: (context){
            return ESC();
          }),
          ChangeNotifierProvider(create: (context){
            return ProductProvider();
          }),
          ChangeNotifierProvider(create: (context){
            return RemoveProvider();
          })
        ],
        child: OKToast(
          child: MaterialApp(
            // initialRoute: SaleWholosale.RouteName,
           
            initialRoute: 
            // auth == true ?
            // SaleWholosale.RouteName:
            Landing.RouteName,
            //  Sale.RouteName,
            
 
            routes: {
              Login.RouteName: (context) => Login(),
              Sale.RouteName: (context) => Sale(),
              SaleWholosale.RouteName: (context) => SaleWholosale(),
              // PaySuccess.RouteName: (context) => PaySuccess(),
              UserAddScreen.RouteName: (context) => UserAddScreen(),
              Change.RouteName: (context) => Change(),
              Receipt.RouteName: (context) => Receipt(),
              Customer.RouteName: (context) => Customer(),
              Setting.RouteName: (context) => Setting(),
              CheckConnect.RouteName: (context) => CheckConnect(),
              ProductScreen.RouteName: (context) => ProductScreen(),
              DashboardScreen.RouteName: (context) => DashboardScreen(),
              Landing.RouteName: (context) => Landing(),
              RemoveProduct.RouteName: (context) => RemoveProduct(),
            },
            title: 'MTN POS',
      
            theme: ThemeData(

              fontFamily: 'IBM Plex Sans Thai',
              primarySwatch:  createMaterialColor(Color(0xffFE7200)),
              accentColor: Colors.white,

            ),
            // home: MainPage(),
           
            // home: Login(),
          ),
        ),
      ),
    );
  }
}

