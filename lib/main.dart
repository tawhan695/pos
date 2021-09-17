import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos/provider/product_provider.dart';
import 'package:pos/screen/login.dart';
// import 'package:pos/routes/app_routes.dart';
import 'package:pos/screen/sale_retail.dart';
import 'package:pos/screen/sale_wholosale.dart';
import 'package:provider/provider.dart';
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

  // This widget is the root of your application.
  // Color selection = Colors.yellow[400]!;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context){
          return ProductProvider();
        })
      ],
      child: MaterialApp(
        // initialRoute: SaleWholosale.RouteName,
        initialRoute: Login.RouteName,
        routes: {
          Login.RouteName: (context) => Login(),
          SaleRetail.RouteName: (context) => SaleRetail(),
          SaleWholosale.RouteName: (context) => SaleWholosale(),
        },
        title: 'Flutter Demo',
    
        theme: ThemeData(
          fontFamily: 'IBM Plex Sans Thai',
          primarySwatch:  createMaterialColor(Color(0xffFE7200)),
          accentColor: Colors.white,
        ),
        // home: MainPage(),
        home: Login(),
      ),
    );
  }
}

