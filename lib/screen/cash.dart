import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos/provider/order_provider.dart';
import 'package:pos/screen/cash_widget/cash.dart';
import 'package:provider/provider.dart';

import 'cash_widget/prompay.dart';

class Cash_screen extends StatefulWidget {
  const Cash_screen({ Key? key }) : super(key: key);

  @override
  _Cash_screenState createState() => _Cash_screenState();
}

class _Cash_screenState extends State<Cash_screen> {
  @override
  Widget build(BuildContext context) {
        // final _controller = TextEditingController();
  var provider = Provider.of<OrderProvider>(context,listen:false);
      var sum = provider.getSum();
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
         appBar: AppBar(
           toolbarHeight: 150,
            title:  Center(child: Column(
              children: [
                Text('',style: TextStyle(fontSize: 6),),
                Text('$sum',style: TextStyle(fontSize: 60),),
                Text('ยอดเงนที่ต้องชำระ',style: TextStyle(fontSize: 25),),
              ],
            )),
            // toolbarHeight: 299,
            // flexibleSpace: <Widget>[],
            bottom:  TabBar(
              indicatorSize: TabBarIndicatorSize.label, 
              indicatorWeight: 10, 
              
              tabs: <Widget>[
                
                Tab(
                  text: 'เงินสด',
                  icon: Icon(Icons.money_rounded,size: 35,),
                ),
                Tab(
                  text: 'พร้อมเพย์',
                  icon: Icon(Icons.qr_code_2,size: 35,),
                ),
                Tab(
                  text: 'ธนาคาร',
                  icon: Icon(Icons.house_outlined,size: 35,),
                ),
                
              ],
            ),
          ),
          body: const TabBarView(
            children: <Widget>[
              
              Center(
                child: Cash(),
              ),
              Center(
                child: Promptpay(),
              ),
              Center(
                child: Text("รออัพเดท..",style: TextStyle(fontSize: 50),),
              ),
            ],
          ),
        // body: Center(
        //   child: Container(
        //     child: Column(
        //       children: [
        //         Padding(
        //           padding: const EdgeInsets.only(top:20.0),
        //           child: Center(
        //             child: Column(
        //               children: [
        //                 Text('$sum',style: TextStyle(fontSize: 50),),
        //                 Text('จำนวนเงนที่ต้องชำระ',style: TextStyle(fontSize: 20),),
        //                 TabBar(tabs: <Widget>[
        //                   Tab(
        //           icon: Icon(Icons.cloud_outlined),
        //         ),
        //         Tab(
        //           icon: Icon(Icons.beach_access_sharp),
        //         ),
        //         Tab(
        //           icon: Icon(Icons.brightness_5_sharp),
        //         ),
        //                 ]
        //                 ),
        //     //             TextFormField(
        //     // controller: _controller,
        //     // keyboardType: TextInputType.number,
        //     // inputFormatters: <TextInputFormatter>[
        //     //   WhitelistingTextInputFormatter.digitsOnly
        //     // ],
        //     // decoration: InputDecoration(
        //     //     labelText: "",
        //     //     hintText: "จำนวนสินค้า",
        //     //     icon: Icon(
        //     //       Icons.edit_outlined,
        //     //       size: 26,
        //     //     ),
        //     //     ),
        //     //     ),
        //               ],
        //             )
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
       
      ),
    );
  }
}

// class Cash_screen extends StatelessWidget {
//   const Cash_screen();
//   @override
//   Widget build(BuildContext context) {

//   }
// }