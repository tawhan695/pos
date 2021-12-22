import 'package:flutter/material.dart';
import 'package:pos/models/order_model.dart';
import 'package:pos/provider/customer_provider.dart';
import 'package:pos/provider/list_order_provider.dart';
import 'package:pos/screen/order_details/order_details.dart';
import 'package:provider/provider.dart';

class CustomerDetail extends StatefulWidget {
  static const RouteName = 'customer_detail';
  final customer;
  CustomerDetail(this.customer);

  @override
  _CustomerDetailState createState() => _CustomerDetailState();
}

class _CustomerDetailState extends State<CustomerDetail> {
  List<ListOrder_model> custom_listOrder2 = [];
  int tiket = 0;
  double total = 0;

  @override
  void initState() {
    super.initState();
    // print(widget.customer.id);
    Provider.of<ListOrderProvider>(context, listen: false)
        .customerorder(widget.customer.id);

       custom_listOrder2 = Provider.of<ListOrderProvider>(context, listen: false)
        .getDetailCustomer();
   install();

  }
   install()  {
        for (var i = 0; i <custom_listOrder2.length; i++){
        //  setState(() {
          tiket = i;
          total += double.parse( custom_listOrder2[i].net_amount.toString());
            print('tiket $tiket');
            print('total $total');
  // });
        }
// custom_listOrder2.forEach((e){
 
// });
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลลูกค้า ${widget.customer.name}'),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Consumer(builder:
                  (BuildContext context, ListOrderProvider listorder, Widget) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: Card(
            
                        color: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        elevation: 8,
                        child: Container(
                          child: Center(child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Text('จำนวนบิล',style: TextStyle(fontSize:30)),
                                Text('${listorder.gettiket()}',style: TextStyle(fontSize:28)),
                              ],
                            ),
                          )),
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: Card(
            
                        color: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        elevation: 8,
                        child: Container(
                          child: Center(child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Text('จำนวนเงิน',style: TextStyle(fontSize:30)),
                                Text('฿${listorder.gettotol()}',style: TextStyle(fontSize:28)),
                              ],
                            ),
                          )),
                        ),
                      ),
                    ),
                   
                  ],
                );
                  }
              ),
              Consumer(builder:
                  (BuildContext context, ListOrderProvider listorder, Widget) {
                var data = listorder.getDetailCustomer();
                if (data.length > 0){
                   return DataTable(
                  columns: [
                    DataColumn(
                        label: Text('ใบเสร็จ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('ลูกค้า',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))),
                    // DataColumn(label: Text(
                    //     'รายการ',
                    //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                    // )),
                    DataColumn(
                        label: Text('วันที่',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('ชำระโดย',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('รวมทั้งสิ้น',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('จัดการ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))),
                  ],
                  rows: data
                      .map(
                        (e) => DataRow(cells: [
                          DataCell(Text('${e.id}')),
                          DataCell(Provider.of<CustomerProvider>(context,
                                          listen: false)
                                      .getName(e.customer_id.toString())
                                      .length <
                                  1
                              ? Text('-')
                              : Text(
                                  '${Provider.of<CustomerProvider>(context, listen: false).getName(e.customer_id.toString())}')),
                          // DataCell(Text('${e.customer_id}')),
                          DataCell(Text('${e.created_at}')),
                          DataCell(Text('${e.paid_by}')),
                          DataCell(Text('฿${e.net_amount}')),
                          DataCell(IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        OrderDetail("${e.id}", e)));
                              },
                              icon: Icon(
                                Icons.list_alt,
                                color: Colors.orange,
                                size: 40,
                              ))),
                        ]),
                      )
                      .toList(),
                );

                }else{
                  return Center(child: Text('ไม่มีข้อมูล'));
                }              }),
            ],
          ),
        ),
      ),
    );
  }
}
